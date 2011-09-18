class @ComputerPlayer extends Player
	update: (keysDown, paddlePosition, ballPosition, ballDirection) ->
		distance = 0
		distance = @rate if (ballPosition[1] > paddlePosition[1])
		distance = (0 - @rate) if (ballPosition[1] < paddlePosition[1])

		return distance
