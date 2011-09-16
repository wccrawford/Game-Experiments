class Pong
	main: ->
		@running = true

		@date = new Date
		@time = @date.getTime()
		@fpsTime = @date.getTime()
		@fps = 0
		@lastFps = 0
		@keysDown = []

		@framerate = 1000/60

		@canvas = document.getElementById('canvas')
		@context = @canvas.getContext('2d')

		@field = [
			50,
			100,
			@canvas.width - 50,
			@canvas.height - 50,
		]

		window.onblur = @pause
		
		window.onfocus = @unpause

		document.onkeydown = @getKeys

		document.onkeyup = @clearKeys

		@setup()

		@loop()

	pause: =>
		@running = false

	unpause: =>
		@running = true
	
	getKeys: (event) =>
		if @keysDown.indexOf(event.keyCode) == -1
			@keysDown.push event.keyCode
	
	clearKeys: (event) =>
		index = @keysDown.indexOf(event.keyCode)
		if index != -1
			@keysDown[index..index] = []

	loop: ->
		if @running
			@update()

			@date = new Date()
			if ((@date.getTime() - @time) >= @framerate)
				@draw()
				@time = @date.getTime()

			@fps++
			if ((@date.getTime() - @fpsTime) >= 1000)
				@fpsTime = @date.getTime()
				@lastFps = @fps
				@fps = 0

		setTimeout =>
			@loop()
		, 1

	setup: ->
		midfield = @field[1] + ((@field[3] - @field[1])/2)
		@paddle1 = new Paddle
		@paddle1.location = [@field[0]+10, midfield]

		@paddle2 = new Paddle
		@paddle2.location = [@field[2]-10, midfield]
		@ball = new Ball 2

	update: ->
		@updateBall()

		@updatePaddle1()

		@updatePaddle2()
	
	updatePaddle1: ->
		@paddle1.location[1] -= 1 if @keysDown.indexOf(38) != -1 # Up
		@paddle1.location[1] += 1 if @keysDown.indexOf(40) != -1 # Down

	updatePaddle2: ->

	updateBall: ->
		@ball.location[0] += @ball.direction[0]
		@ball.location[1] += @ball.direction[1]

		@left = @field[0] + @ball.size
		if (@ball.location[0] < @left)
			@ball.direction[0] = 0 - @ball.direction[0]
			@ball.location[0] = @left + (@left - @ball.location[0])

		@right = @field[2] - @ball.size
		if (@ball.location[0] > @right)
			@ball.direction[0] = 0 - @ball.direction[0]
			@ball.location[0] = @right - (@ball.location[0] - @right)

		@top = @field[1] + @ball.size
		if (@ball.location[1] < @top)
			@ball.direction[1] = 0 - @ball.direction[1]
			@ball.location[1] = @top + (@top - @ball.location[1])

		@bottom = @field[3] - @ball.size
		if (@ball.location[1] > @bottom)
			@ball.direction[1] = 0 - @ball.direction[1]
			@ball.location[1] = @bottom - (@ball.location[1] - @bottom)

	draw: ->
		@canvas.width = @canvas.width
		@context.fillStyle = '#000'
		@context.fillRect(0, 0, @canvas.width, @canvas.height)

		@context.beginPath()
		@context.moveTo @field[0] + 0.5, @field[1] + 0.5
		@context.lineTo @field[2] + 0.5, @field[1] + 0.5
		@context.moveTo @field[0] + 0.5, @field[3] + 0.5
		@context.lineTo @field[2] + 0.5, @field[3] + 0.5
		@context.closePath()
		@context.strokeStyle = '#FFF'
		@context.stroke()

		@paddle1.draw(@context)
		@paddle2.draw(@context)
		@ball.draw(@context)

class Paddle
	constructor: ->
		@location = [60, 300]
	
	draw: (context) ->
		context.fillStyle = '#FFF'
		context.fillRect(@location[0]-5, @location[1]-25, 10, 50)
		

class Ball
	constructor: (@size) ->
		@location = [400,300]
		@direction = [-1,-1]

	draw: (context) ->
		context.beginPath()
		context.arc(@location[0] + 0.5, @location[1] + 0.5, @size*2, 0, Math.PI * 2, false)
		context.closePath()

		context.fillStyle = '#FFF'
		context.strokeStyle = '#FFF'
		context.stroke()
		context.fill()

pong = new Pong
pong.main()
