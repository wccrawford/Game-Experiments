class @Pong
	constructor: ->
		@date = new Date
		@time = @date.getTime()
		@fpsTime = @date.getTime()
		@fps = 0
		@lastFps = 0
		@keysDown = []
		@score = [0, 0]
		@modes = []
		@audio = {}

		@framerate = 1000/60

	main: ->
		@setup()

		@loop()

	setup: ->
		@audio = {
			hit: document.getElementById('hit')
		}
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

		@midfield = [
			@field[0] + ((@field[2] - @field[0])/2)
			@field[1] + ((@field[3] - @field[1])/2)
		]

		@player1 = new Player('Left Player')
		@player2 = new Player('Right Player')
		@player2.keys = {
			up: 38
			down: 40
		}

		@paddle1 = new Paddle
		@paddle1.location = [@field[0]+10, @midfield[1]]

		@paddle2 = new Paddle
		@paddle2.location = [@field[2]-10, @midfield[1]]

		@ball = new Ball 2
		@ball.location = [
			@midfield[0]
			@midfield[1]
		]

		@modes.push new Mode.Title this
	
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
			@getCurrentMode().draw(@canvas)
			@time += @framerate

			@fps++
			if ((@date.getTime() - @fpsTime) >= 1000)
				@fpsTime += 1000
				@lastFps = @fps
				@fps = 0

		@getCurrentMode().update(@keysDown)

		@loopRef = setTimeout =>
			@loop()
		, 1

	getCurrentMode: ->
		if @modes.length > 0 then @modes[@modes.length - 1] else null

	play: (sound) ->
		if(@audio[sound] != undefined)
			@audio[sound].play()


pong = new Pong
pong.main()
