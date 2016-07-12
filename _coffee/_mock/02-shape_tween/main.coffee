
#
# Mainクラス
#
class Main
	constructor: () ->
		console.log 'main'
		@$canvas = $('#MainCanvas')
		@canvas = @$canvas.get(0)
		console.log '@canvas',@canvas
		@context = @canvas.getContext('2d')
		@$window = $(window)

		# キャンバス指定
		paper.setup(@canvas)

		@PATH1 = [
			new paper.Segment( new paper.Point(0,400), new paper.Point(0,0), new paper.Point(200,0) ),
			new paper.Segment( new paper.Point(300,0), new paper.Point(-200,0), new paper.Point(200,0) ),
			new paper.Segment( new paper.Point(600,400), new paper.Point(-200,0), new paper.Point(0,0) )
		]

		@PATH2 = [
			new paper.Segment( new paper.Point(100,0), new paper.Point(0,0), new paper.Point(0,200) ),
			new paper.Segment( new paper.Point(300,400), new paper.Point(-100,0), new paper.Point(100,0) ),
			new paper.Segment( new paper.Point(500,0), new paper.Point(0,200), new paper.Point(0,0) )
		]

		@layer = paper.project.activeLayer
		@path = new paper.Path(@PATH1)
		@path.strokeColor = new paper.Color(1,0,0)
		@path.strokeWidth = 5
		@path.fullySelected = true
		@layer.addChild(@path)
		@position = 0.0

		console.log @path.segments[0]

		@path2 = new paper.Path(@PATH2)
		@path2.strokeColor = new paper.Color(0,1,0)
		@path2.strokeWidth = 2
		@path2.fullySelected = true

		#イベント設定
		paper.view.onFrame = @onFrame
		@$window.on('resize',@onResize)
		@onResize()
		return

	onFrame: () =>
		TWEEN.update()
		@context.clearRect(0,0,@stageWidth,@stageHeight)

		@position += 0.0001
		if @position > 1 then @position = 1

		for segument, i in @path.segments
			@changeSegument segument, i

		paper.view.update(true)
		return

	changeSegument: (segument, i, beforePath = @PATH1, aftrerPath = @PATH2 )->
		segument.point.x = beforePath[i].point.x + (aftrerPath[i].point.x - beforePath[i].point.x) * @position
		segument.point.y = beforePath[i].point.y + (aftrerPath[i].point.y - beforePath[i].point.y) * @position
		segument.handleIn.x = beforePath[i].handleIn.x + (aftrerPath[i].handleIn.x - beforePath[i].handleIn.x) * @position
		segument.handleIn.y = beforePath[i].handleIn.y + (aftrerPath[i].handleIn.y - beforePath[i].handleIn.y) * @position
		segument.handleOut.x = beforePath[i].handleOut.x + (aftrerPath[i].handleOut.x - beforePath[i].handleOut.x) * @position
		segument.handleOut.y = beforePath[i].handleOut.y + (aftrerPath[i].handleOut.y - beforePath[i].handleOut.y) * @position
		return

	onResize: () =>
		@stageWidth = @$window.width()
		@stageHeight = @$window.height()
		@$canvas.attr('width',@stageWidth+'px')
		@$canvas.attr('height',@stageHeight+'px')
		@$canvas.css('width',@stageWidth+'px')
		@$canvas.css('height',@stageHeight+'px')
		return

#
# DOM READY
#
$(()->
	window.main = new Main()
)
