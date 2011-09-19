class @Player
	constructor: (@name) ->
		@keys = {
			up: 87 # w
			down: 83 # s
		}

		@rate = 1

	update: (keysDown, paddlePosition, ballPosition, ballDirection) ->
		distance = 0
		distance = @rate if @keyDown('down', keysDown)
		distance = (0 - @rate) if @keyDown('up', keysDown)

		return distance
		
	keyDown: (keyName, keysDown) ->
		keysDown.indexOf(@keys[keyName]) != -1
