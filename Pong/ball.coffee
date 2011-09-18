class @Ball
	constructor: (@size) ->
		@location = [400, 300]
		@direction = [-1, -1]

	draw: (context) ->
		context.beginPath()
		context.arc(@location[0] + 0.5, @location[1] + 0.5, @size*2, 0, Math.PI * 2, false)
		context.closePath()

		context.fillStyle = '#FFF'
		context.strokeStyle = '#FFF'
		context.stroke()
		context.fill()
	
	boundingBox: ->
		return [
			@location[0] - (@size / 2)
			@location[1] - (@size / 2)
			@location[0] + (@size / 2)
			@location[1] + (@size / 2)
		]

	collidesWith: (object) ->
		ballBounds = @boundingBox()
		objectBounds = object.boundingBox()
		
		if ((ballBounds[0] >= objectBounds[0]) &&
		(ballBounds[0] <= objectBounds[2])) ||
		(ballBounds[2] >= objectBounds[0]) &&
		(ballBounds[2] <= objectBounds[2])
			if ((ballBounds[1] >= objectBounds[1]) &&
			(ballBounds[1] <= objectBounds[3])) ||
			(ballBounds[3] >= objectBounds[1]) &&
			(ballBounds[3] <= objectBounds[3])
					return true

		false
