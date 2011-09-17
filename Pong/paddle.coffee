class @Paddle
	constructor: ->
		@location = [60, 300]
		@size = [10, 50]
	
	draw: (context) ->
		context.fillStyle = '#FFF'
		context.fillRect(@location[0] - (@size[0] / 2), @location[1] - (@size[1] / 2), @size[0], @size[1])
	
	boundingBox: ->
		return [
			@location[0] - (@size[0] / 2)
			@location[1] - (@size[1] / 2)
			@location[0] + (@size[0] / 2)
			@location[1] + (@size[1] / 2)
		]
