class @PlayMode
	constructor: (@main) ->
		@field = @main.field
		@midfield = @main.midfield

		@main.score = [0,0]

	update: (keysDown) ->
		paddle1 = @main.paddle1
		paddle2 = @main.paddle2

		ball = @main.ball

		paddle1.location[1] += @main.player1.update(keysDown, paddle1.location, ball.location, ball.direction)
		@constrainPaddleToField(paddle1)

		paddle2.location[1] += @main.player2.update(keysDown, paddle2.location, ball.location, ball.direction)
		@constrainPaddleToField(paddle2)

		@updateBall(ball, paddle1, paddle2)
	
	updateBall: (ball, paddle1, paddle2) ->
		ball.location[0] += ball.direction[0]
		ball.location[1] += ball.direction[1]

		left = @field[0]
		if (ball.location[0] < left)
			ball.location = [
				@midfield[0]
				@midfield[1]
			]
			@main.score[1]++
		
		right = @field[2]
		if (ball.location[0] > right)
			ball.location = [
				@midfield[0]
				@midfield[1]
			]
			@main.score[0]++

		ballBounds = ball.boundingBox()
		if (ball.collidesWith(paddle1))
			paddle1Bounds = paddle1.boundingBox()
			paddle1Right = paddle1Bounds[2]

			ball.direction = @calculateBallDirection(ball, paddle1)

			ball.location[0] += ((paddle1Right - ballBounds[0]) + (ball.size / 2))
			@main.play('hit')

		ballBounds = ball.boundingBox()
		if (ball.collidesWith(paddle2))
			paddle2Bounds = paddle2.boundingBox()
			paddle2Left = paddle2Bounds[0]

			ball.direction = @calculateBallDirection(ball, paddle2)

			ball.location[0] -= ((ballBounds[2] - paddle2Left) + (ball.size / 2))
			@main.play('hit')

		top = @field[1] + ball.size
		if (ball.location[1] < top)
			ball.direction[1] = 0 - ball.direction[1]
			ball.location[1] = top + (top - ball.location[1])

		bottom = @field[3] - ball.size
		if (ball.location[1] > bottom)
			ball.direction[1] = 0 - ball.direction[1]
			ball.location[1] = bottom - (ball.location[1] - bottom)

		if(@main.score[0] >= 7)
			@main.modes.pop
			@main.modes.push new GameOverMode(@main, @main.player1.name)

		if(@main.score[1] >= 7)
			@main.modes.pop
			@main.modes.push new GameOverMode(@main, @main.player2.name)

	calculateBallDirection: (ball, paddle) ->
		direction = [
			(paddle.size[1]) - Math.abs(ball.location[1] - paddle.location[1])
			(ball.location[1] - paddle.location[1])
		]
		length = Math.sqrt((direction[0]*direction[0]) + (direction[1]*direction[1]))
		direction[0] = Math.abs(direction[0] / length * 2)
		direction[1] = direction[1] / length * 2

		direction[0] = -1 * direction[0] if (ball.location[0] < paddle.location[0])

		return direction

	constrainPaddleToField: (paddle) ->
		halfPaddleSize = paddle.size[1] / 2
		paddle.location[1] = @field[1] + halfPaddleSize if (paddle.location[1] < (@field[1] + halfPaddleSize))
		paddle.location[1] = @field[3] - halfPaddleSize if (paddle.location[1] > (@field[3] - halfPaddleSize))

	draw: (canvas) ->
		canvas.width = canvas.width
		context = canvas.getContext('2d')
		context.fillStyle = '#000'
		context.fillRect(0, 0, canvas.width, canvas.height)

		context.beginPath()
		context.moveTo @field[0] + 0.5, @field[1] + 0.5
		context.lineTo @field[2] + 0.5, @field[1] + 0.5
		context.moveTo @field[0] + 0.5, @field[3] + 0.5
		context.lineTo @field[2] + 0.5, @field[3] + 0.5
		context.closePath()
		context.strokeStyle = '#FFF'
		context.stroke()

		@main.paddle1.draw(context)
		@main.paddle2.draw(context)
		@main.ball.draw(context)

		context.font = "25px Arial"
		context.textBaseline = "top"
		context.textAlign = "right"
		context.fillText(@main.player1.name, (canvas.width / 2) - 10, 10)
		context.fillText(@main.score[0], (canvas.width / 2) - 10, 40)

		context.textAlign = "left"
		context.fillText(@main.player2.name, (canvas.width / 2) + 10, 10)
		context.fillText(@main.score[1], (canvas.width / 2) + 10, 40)

		context.textAlign = "right"
		context.textBaseline = "bottom"
		context.fillText(@main.lastFps + ' fps', canvas.width - 1, canvas.height - 1)

