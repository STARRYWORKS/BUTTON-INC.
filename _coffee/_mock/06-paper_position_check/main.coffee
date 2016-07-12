#
# Mainクラス
#
class Main
	constructor: () ->
		@$canvas = $('#MainCanvas')
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')
		@$window = $(window)

		# キャンバス指定
		paper.setup(@canvas)
		

		@pathRed = new paper.Path([100, 0], [100, 100])
		@pathRed.pivot = new paper.Point(0,0)
		@pathRed.position = {x:100, y:100}
		@pathRed.strokeColor = 'red'


		console.log "\n before ---------"
		console.log "@pathRed.position", @pathRed.position

		@pathBlack = new paper.Path([0, 0], [100, 100])
		@pathBlack.pivot = new paper.Point(0,0)
		@pathBlack.position = {x:50, y:50}
		@pathBlack.strokeColor = 'black'
		@pathGreen = new paper.Path([0, 100], [100, 0])
		@pathGreen.pivot = new paper.Point(0,0)
		@pathGreen.position = {x:50, y:50}
		@pathGreen.strokeColor = 'green'
		
		@group = new paper.Group({
			children: [@pathBlack, @pathGreen]
		})
		@group.transformContent = false
		@group.pivot = new paper.Point(0,0)
		@group.position = {x:200, y:200}

		@group.addChild @pathRed

		console.log "@group.position", @group.position

		@rootLayer = paper.project.activeLayer

		console.log "\n after ---------"
		console.log "@pathRed.position", @pathRed.position
		console.log "@group.position", @group.position

		# @rootLayer.addChild(@pathRed)
		@rootLayer.addChild(@group)
		# @stageLayer = new Layer()
		# @stageLayer.position = {x:100, y:100}

		@pathBlue = new paper.Path([50, 50], [150, 50])
		@pathBlue.pivot = new paper.Point(0,0)
		@pathBlue.strokeColor = 'blue'
		@pathBlue.position = new paper.Point(20,20)

		@rootLayer.transformContent = false
		@rootLayer.pivot = new paper.Point(0,0)
		@rootLayer.position = new paper.Point(300,300)

		console.log "\n after add ---------"
		console.log "@pathBlue.position", @pathBlue.position

		console.log "\n ---------"
		console.log "paper.project", paper.project
		console.log "@rootLayer.children", @rootLayer.children
		console.log "@rootLayer.position", @rootLayer.position

		setTimeout(=>
			console.log "setTimeout"
			@pathGray = new paper.Path([100, 0], [100, 100])
			@pathGray.pivot = new paper.Point(10,10)
			@pathGray.strokeColor = 'gray'
			@rootLayer.addChild @pathGray

			console.log '@pathGray.position:'+@pathGray.position
			console.log '@pathGray.matrix:'+@pathGray.matrix
			console.log '@pathGray.globalMatrix:'+@pathGray.globalMatrix

		,2000)

		@layer = new paper.Layer()
		@layer.transformContent = false
		@layer.pivot = new paper.Point(0,0)
		@layer.position = new paper.Point(400,50)
		@layer.addChild @pathBlue

		@rootLayer.addChild @layer

		#イベント設定
		paper.view.onFrame = @onFrame
		@$window.on('resize',@onResize)
		@onResize()

		return

	onFrame: () =>
		TWEEN.update()
		# @pathRed.position.y += 0.5
		# @pathRed.segments[0].point.y += 0.5
		# @rootLayer.position.y += 0.5
		# @rootLayer.position.x += 0.1

		@context.clearRect(0,0,@stageWidth,@stageHeight)
		paper.view.update(true)

		@ctxScale = 1
		@drawBasePosition(@rootLayer)
		return

	drawBasePosition: (obj) ->
		# 基準点を描画
		x = obj.position.x
		y = obj.position.y
		color = '#00ffff' #ブルー
		if obj instanceof paper.Layer then color = '#ff88ff' # Layerはピンク
		else if obj instanceof paper.Group then color = '#88ff88' # グループはグリーン
		@drawLine({x:x-5, y:y}, {x:10, y:0}, color )
		@drawLine({x:x, y:y-5}, {x:0, y:10}, color )
		@context.save()
		obj.matrix.applyToContext(@context)
		# グループやLayerの場合は子オブジェクトを処理する
		if obj instanceof paper.Layer || obj instanceof paper.Group
			for child in obj.children
				@drawBasePosition(child)
		@context.restore()

	# 
	# 
	# 
	drawLine: (from,to,color) ->
		@context.beginPath()
		@context.moveTo(from.x,from.y)
		@context.lineTo(from.x+to.x,from.y+to.y)
		@context.strokeStyle = color
		@context.lineWidth = 1 / @ctxScale
		# @context.lineWidth = 10
		@context.closePath()
		@context.stroke()
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
