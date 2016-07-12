Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'

# 
# UFOシーンで使用するための土台クラス
# 
class BaseView extends paper.Group
	constructor: ()->
		super()
		@sceneConfig = Config.Ufo
		
		Utils.transformInit @
		# 土台
		base = Utils.getSvgChild @sceneConfig.SVG.Base1
		baseUfo = Utils.getSvgChild @sceneConfig.SVG.Base2
		@base = new MorphablePath [base, baseUfo]
		@base.strokeWidth = Config.LINE_WIDTH
		@base.strokeColor = Config.COLOR.BASE_PATH
		@base.fillColor = Config.COLOR.BASE_FILL
		@addChild @base
		@base.visible = false

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@base.morph = 0
		@base.update @base.morph
		@base.closed = false
		@base.visible = false
		return

	# 
	# 変形
	# 
	change: ()=>
		@base.visible = true
		# パスクローズ
		@base.closed = true
		
		# Tween 変形
		TweenMax.to @base, .25, {
			morph: 1
			ease: Expo.easeOut
			onUpdate: @base.update
		}

		return


module.exports = BaseView