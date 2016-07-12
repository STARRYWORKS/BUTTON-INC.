Config								= require 'config'
PaperStage						= require 'paper-stage'
CustomStroke	= require 'custom-stroke'

###
auth: Kimura
data: 2016/05/20
###
ESCAPE = "Escape"

class Main
	constructor: () ->
		@dpr = if window.devicePixelRatio == undefined then 1 else window.devicePixelRatio
		@$window = $(window)
		@$canvas = $("#" + Config.Canvas.paper)
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')

		# paper.js 設定
		@paper = new PaperStage(@$canvas,@dpr)

		# イベント設定
		@$window.on('resize', @onResize).trigger('resize')


		@container = new paper.Group()
		@paper.stage.addChild @container

		# ベース
		@baseSVG = @container.importSVG Config.SVG.BASE
		@baseSVG.remove()

		# 骨格の線
		@bone = @baseSVG.children[1]
		@bone.strokeWidth = 0.25
		@bone.strokeColor = new paper.Color 255,0,0,1
		@bone.fillColor = new paper.Color 0,0,0,0
		@container.addChild @bone

		# custom stroke
		@stroke = new CustomStroke @bone, 5.5, [
			[0.5,		0.5]
			[0,			0]
			[2.75,	0]
			[2.75,	0]
			[0,			0]
			[0.5,		0.5]
		]
		@stroke.strokeWidth = 0
		@stroke.fillColor = new paper.Color 0,0,0,0.1
		@stroke.selected = true
		@stroke.fullySelected = true
		@container.addChild @stroke

		@container.scale(2)

		paper.view.update(true)
		return

	# 
	# リサイズ処理
	# 
	onResize: =>
		# ステージサイズ設定
		@stageWidth = @$window.width()
		@stageHeight = @$window.height()
		
		# paperリサイズ
		@paper.resize(@stageWidth, @stageHeight)

		return

	
#
# DOM READY
#
$(()->
	window.main = new Main()
)


