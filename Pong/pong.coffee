class @Pong
	main: ->
		@date = new Date
		@time = @date.getTime()
		@fpsTime = @date.getTime()
		@fps = 0
		@lastFps = 0
		@keysDown = []
		@audio = {
			hit: document.getElementById('hit')
		}
		@score = [0, 0]

		@framerate = 1000/60

		@canvas = document.getElementById('canvas')

		@field = [
			50,
			100,
			@canvas.width - 50,
			@canvas.height - 50,
		]

		window.onblur = @pause
		
		window.onfocus = @start

		document.onkeydown = @getKeys

		document.onkeyup = @clearKeys

		@setup()

		@loop()

	pause: =>
		if (@loopRef != null)
			clearTimeout(@loopRef)
			@loopRef = null

	start: =>
		if(@loopRef == null)
			@loopRef = setTimeout =>
				@loop()
			, 1

	getKeys: (event) =>
		if @keysDown.indexOf(event.keyCode) == -1
			@keysDown.push event.keyCode
	
	clearKeys: (event) =>
		index = @keysDown.indexOf(event.keyCode)
		if index != -1
			@keysDown[index..index] = []

	loop: ->
		@date = new Date()
		if ((@date.getTime() - @time) >= @framerate)
			@draw(@canvas.getContext('2d'))
			@time += @framerate

			@fps++
			if ((@date.getTime() - @fpsTime) >= 1000)
				@fpsTime += 1000
				@lastFps = @fps
				@fps = 0

		@update()

		@loopRef = setTimeout =>
			@loop()
		, 1

	setup: ->
		@midfield = [
			@field[0] + ((@field[2] - @field[0])/2)
			@field[1] + ((@field[3] - @field[1])/2)
		]

		@paddle1 = new Paddle
		@paddle1.location = [@field[0]+10, @midfield[1]]

		@paddle2 = new Paddle
		@paddle2.location = [@field[2]-10, @midfield[1]]

		@ball = new Ball 2
		@ball.location = [
			@midfield[0]
			@midfield[1]
		]

	update: ->
		@updatePaddle1()

		@updatePaddle2()

		@updateBall()
	
	updatePaddle1: ->
		@paddle1.location[1] -= 1 if @keysDown.indexOf(87) != -1 # w
		@paddle1.location[1] += 1 if @keysDown.indexOf(83) != -1 # s

		@paddle1.location[1] = @field[1] + 25 if (@paddle1.location[1] < (@field[1] + 25))
		@paddle1.location[1] = @field[3] - 25 if (@paddle1.location[1] > (@field[3] - 25))

	updatePaddle2: ->
		@paddle2.location[1] -= 1 if @keysDown.indexOf(38) != -1 # Up
		@paddle2.location[1] += 1 if @keysDown.indexOf(40) != -1 # Down

		@paddle2.location[1] = @field[1] + 25 if (@paddle2.location[1] < (@field[1] + 25))
		@paddle2.location[1] = @field[3] - 25 if (@paddle2.location[1] > (@field[3] - 25))

	updateBall: ->
		@ball.location[0] += @ball.direction[0]
		@ball.location[1] += @ball.direction[1]

		left = @field[0]
		if (@ball.location[0] < left)
			@ball.location = [
				@midfield[0]
				@midfield[1]
			]
			@score[1]++
		
		right = @field[2]
		if (@ball.location[0] > right)
			@ball.location = [
				@midfield[0]
				@midfield[1]
			]
			@score[0]++

		ballBounds = @ball.boundingBox()
		if (@ball.collidesWith(@paddle1))
			paddle1Bounds = @paddle1.boundingBox()
			paddle1Right = paddle1Bounds[2]
			@ball.direction[0] = Math.abs(@ball.direction[0])
			@ball.location[0] += ((paddle1Right - ballBounds[0]) + (@ball.size / 2))
			@play('hit')

		ballBounds = @ball.boundingBox()
		if (@ball.collidesWith(@paddle2))
			paddle2Bounds = @paddle2.boundingBox()
			paddle2Left = paddle2Bounds[0]
			@ball.direction[0] = 0 - Math.abs(@ball.direction[0])
			@ball.location[0] -= ((ballBounds[2] - paddle2Left) + (@ball.size / 2))
			@play('hit')

		@top = @field[1] + @ball.size
		if (@ball.location[1] < @top)
			@ball.direction[1] = 0 - @ball.direction[1]
			@ball.location[1] = @top + (@top - @ball.location[1])

		@bottom = @field[3] - @ball.size
		if (@ball.location[1] > @bottom)
			@ball.direction[1] = 0 - @ball.direction[1]
			@ball.location[1] = @bottom - (@ball.location[1] - @bottom)

	play: (sound) ->
		if(@audio[sound] != undefined)
			@audio[sound].play()
	
	draw: (context) ->
		@canvas.width = @canvas.width
		context.fillStyle = '#000'
		context.fillRect(0, 0, @canvas.width, @canvas.height)

		context.beginPath()
		context.moveTo @field[0] + 0.5, @field[1] + 0.5
		context.lineTo @field[2] + 0.5, @field[1] + 0.5
		context.moveTo @field[0] + 0.5, @field[3] + 0.5
		context.lineTo @field[2] + 0.5, @field[3] + 0.5
		context.closePath()
		context.strokeStyle = '#FFF'
		context.stroke()

		@paddle1.draw(context)
		@paddle2.draw(context)
		@ball.draw(context)

		context.font = "25px Arial"
		context.textBaseline = "top"
		context.textAlign = "right"
		context.fillText("Left Player", (@canvas.width / 2) - 10, 10)
		context.fillText(@score[0], (@canvas.width / 2) - 10, 40)

		context.textAlign = "left"
		context.fillText("Right Player", (@canvas.width / 2) + 10, 10)
		context.fillText(@score[1], (@canvas.width / 2) + 10, 40)

		context.textAlign = "right"
		context.textBaseline = "bottom"
		context.fillText(@lastFps, @canvas.width - 1, @canvas.height - 1)


pong = new Pong
pong.main()
