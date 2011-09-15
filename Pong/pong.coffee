class Pong
	main: ->
		@running = true
		@date = new Date
		@time = @date.getTime()
		@framerate = 1000/60
		@canvas = document.getElementById('canvas')
		console.log @canvas
		@context = @canvas.getContext('2d')

		@setup()

		@loop()
	
	loop: ->
		@update()

		@date = new Date()
		if ((@date.getTime() - @time) >= @framerate)
			@draw()
			@time = @date.getTime()

		if !@running
			return

		setTimeout =>
			@loop()
		, 1

	setup: ->
		@paddle1 = new Paddle
		@paddle2 = new Paddle
		@paddle2.side = 'right'
		@ball = new Ball

	update: ->
		@ball.location[0] += @ball.direction[0]
		@ball.location[1] += @ball.direction[1]

		if (@ball.location[0] < 0)
			@ball.direction[0] = 0 - @ball.direction[0]
			@ball.location[0] = 0 - @ball.location[0]

		if (@ball.location[0] > @canvas.width)
			@ball.direction[0] = 0 - @ball.direction[0]
			@ball.location[0] = @canvas.width - (@ball.location[0] - @canvas.width)

		if (@ball.location[1] < 0)
			@ball.direction[1] = 0 - @ball.direction[1]
			@ball.location[1] = 0 - @ball.location[1]

		if (@ball.location[1] > @canvas.height)
			@ball.direction[1] = 0 - @ball.direction[1]
			@ball.location[1] = @canvas.height - (@ball.location[1] - @canvas.height)

	draw: ->
		@canvas.width = @canvas.width
		@context.fillStyle = '#000'
		@context.fillRect(0, 0, @canvas.width, @canvas.height)

		@paddle1.draw(@context)
		@paddle2.draw(@context)
		@ball.draw(@context)

class Paddle
	constructor: ->
		@side = 'left'
		@location = 50
	
	draw: (context) ->
		

class Ball
	constructor: ->
		@location = [400,300]
		@direction = [-1,-1]

	draw: (context) ->
		context.beginPath()
		context.arc(@location[0], @location[1], 4, 0, Math.PI * 2, false)
		context.closePath()

		context.fillStyle = '#FFF'
		context.strokeStyle = '#FFF'
		context.stroke()
		context.fill()

pong = new Pong
pong.main()
