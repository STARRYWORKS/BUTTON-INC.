Config = require 'config'
PaperStage = require 'paper-stage'

# 
# 爆発シーンで使用するための警告背景クラス
# 
class WarningView extends PIXI.Container
	constructor: ->
		super()
		@$window = $(window)
		@paperStage = PaperStage.instance.stage
		@padding = 40

		# 警告
		@tileTexture = new PIXI.Texture.fromFrame 'explosion-bg.jpg'
		@tile = new PIXI.extras.TilingSprite @tileTexture, @$window.width(), @$window.height()
		@tile.alpha = 0
		@addChild @tile

		return

	# 
	# アクティブシーン開始時
	# 
	start: ->
		@$window.on 'resize.WarningView', @onResize
			.trigger 'resize.WarningView'
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@tile.alpha = 0
		@$window.off 'resize.WarningView'
		return

	# 
	# 表示
	# 
	show: ->
		if @tile.alpha == 1
			@tile.tilePosition.x += 2
			return

		@tile.alpha = 1

		return

	# 
	# 非表示
	# 
	hide: ->
		if @tile.alpha == 0 then return
		@tile.alpha = 0
		return

	# 
	# リサイズ
	# 
	onResize: =>
		scale = PaperStage.instance.scale
		@tile.tileScale = new PIXI.Point(scale,scale)
		@tile.width = $(window).width()
		@tile.height = $(window).height()
		return

module.exports = WarningView