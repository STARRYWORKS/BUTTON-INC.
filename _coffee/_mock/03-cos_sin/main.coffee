
WIDTH = 800
HEIGHT = 800
NUM_POINTS = 80

class Main
	constructor: () ->
		$canvas = $("#Play2")
		@canvas = $canvas.get(0)
		@ctx = @canvas.getContext('2d')
		@blue = new Circle(@ctx,'rgba(0,0,255,0.75)')
		@red = new Circle(@ctx,'rgba(255,0,0,0.75)')
		@green = new Circle(@ctx,'rgba(0,255,0,0.75)')

		# ctx.beginPath()
		# ctx.moveTo(0,0)
		# ctx.lineTo(10,10)
		# ctx.strokeStyle = 'rgb(0, 0, 0)'
		# ctx.lineWidth = 5
		# ctx.stroke()
		@count = 0
		@update()
		return

	update: () =>
		@count += 0.05
		@ctx.clearRect(0,0,WIDTH,HEIGHT)
		@blue.x = @green.x = 200 + Math.cos(@count) * 100
		@blue.y = 200
		@red.x = 200
		@red.y = @green.y = 200 + Math.sin(@count) * 100
		@blue.draw()
		@red.draw()
		@green.draw()

		baseY = HEIGHT-200
		@ctx.moveTo(0,baseY)
		for i in [0..NUM_POINTS]
			phase = @count + i/NUM_POINTS * 4 * Math.PI
			amplitude = Math.sin((@count + i/NUM_POINTS)*1.3) * 10
			x = i*WIDTH/NUM_POINTS
			y = baseY + Math.sin(phase) * amplitude
			@ctx.lineTo(x,y)
		@ctx.strokeStyle = 'rgb(0, 0, 0)'
		@ctx.strokeWidth = 3
		@ctx.stroke()

		requestAnimationFrame(@update)
		return


class Circle
	constructor: (ctx,color) ->
		@ctx = ctx
		@color = color
		@x = 0
		@y = 0

	draw: ->
		@ctx.fillStyle = @color
		@ctx.beginPath()
		@ctx.arc(@x, @y, 10, 0, Math.PI*2, false)
		@ctx.fill()


$(->
	main = new Main()
)