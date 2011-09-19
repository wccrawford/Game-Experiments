class @TitleMode
	constructor: (@main) ->
		@keys = {
			start: 32 # space
		}


	update: (keysDown) ->
		@main.modes.push new PlayMode(@main) if @keyDown('start', keysDown)

	draw: (canvas) ->
		context = canvas.getContext('2d')

		context.fillStyle = '#000'
		context.fillRect(0, 0, canvas.width, canvas.height)

		context.fillStyle = '#FFF'
		context.textAlign = "center"
		context.textBaseline = "top"
		context.font = "125px Arial"
		context.fillText('Balls!', (canvas.width / 2) + 10, 50)
		context.font = "25px Arial"
		context.fillText('Press Spacebar to continue!', (canvas.width / 2) + 10, canvas.height - 100)

	keyDown: (keyName, keysDown) ->
		keysDown.indexOf(@keys[keyName]) != -1
