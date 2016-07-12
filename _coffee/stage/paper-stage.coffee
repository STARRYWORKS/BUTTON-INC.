Config	= require 'config'
Utils		= require 'utils'

# 
# paper.js用Canvasクラス
# @param {Object} canvas: paper.js描画用canvas
# 
class PaperStage
	@instance: null # どこからでもアクセスできるように
	@HIDE: 1
	@SHOW: 2
	@SHOW_ALL: 3
	constructor: ($canvas) ->
		@$canvas = $canvas
		@canvas = @$canvas.get(0)
		@anchorShowStatus = PaperStage.HIDE
		paper.setup(@canvas)

		# ルートレイヤ設定
		@stage = paper.project.activeLayer

		Utils.transformInit @stage

		PaperStage.instance = @

	# 
	# リサイズ
	# 
	resize: (width, height)->
		@_width = width
		@_height = height
		@dpr = if window.devicePixelRatio == undefined then 1 else window.devicePixelRatio
		
		# Canvasサイズ設定
		if UA.career != UA.IPHONE && UA.career != UA.IPAD
			paper.view.setViewSize(@_width / @dpr, @_height / @dpr)
			@$canvas.css(
				width: @_width
				height: @_height
			)
			@$canvas.attr	(
				width: @_width
				height: @_height
			)
		else
			paper.view.setViewSize(@_width, @_height)

		# ボタンスケール設定
		@scale = ( (if @_width < @_height then @_width else @_height) / Config.BASE_STAGE_WIDTH )
		if @scale > 2 then @scale = 2

		@stage.matrix = new paper.Matrix()
		@stage.scale(@scale, @scale)

		# ボタン位置設定
		_x = @_width / 2
		_y = @_height / 2

		# スケーリングされた大きさ
		@width = width / @scale
		@height = height / @scale

		@stage.position = new paper.Point(_x, _y)
		return

	# 
	# アップデート
	# 
	update: ()->
		switch parseInt(@anchorShowStatus)
			when PaperStage.HIDE
				@stage.selected = false
				@stage.fullySelected = false

			when PaperStage.SHOW
				@stage.fullySelected = false
				@stage.selected = true

			when PaperStage.SHOW_ALL
				@stage.selected = false
				@stage.fullySelected = true

		return

module.exports = PaperStage