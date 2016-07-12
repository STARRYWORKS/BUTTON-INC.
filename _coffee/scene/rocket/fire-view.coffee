Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'

# 
# ロケットシーンで使用するためのロケットの炎クラス
# @param {Object} scene
# 
class FireView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Rocket
		Utils.transformInit @
		
		fire1 = Utils.getSvgChild @sceneConfig.SVG.Fire1, -1
		fire2 = Utils.getSvgChild @sceneConfig.SVG.Fire2, -1

		# モーフィング設定
		@pathes = []
		for child,i in fire1
			@pathes.push new MorphablePath [child,fire2[i]]
			@pathes[i].strokeWidth = Config.LINE_WIDTH
			@pathes[i].strokeColor = @sceneConfig.COLOR.FIRE_STROKE
			@pathes[i].fillColor = if i < 3 then @sceneConfig.COLOR.FIRE_OUT else @sceneConfig.COLOR.FIRE_IN
			@pathes[i].visible = false
			@addChild @pathes[i]

		@tweenArr = []
		@visible = false

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@visible = false
		for tween, i in @tweenArr
			tween.pause()
			@children[i].visible = false
		return

	# 
	# アニメーション
	# 
	effect: =>
		@visible = true
		if @tweenArr.length < 1
			for path in @pathes
				tween = TweenMax.to path, .3, {
					morph: 1
					onUpdate: path.update
					repeat: -1
					yoyo: true
				}
				@tweenArr.push tween
		else
			for tween in @tweenArr
				tween.play()

		$.each @pathes, (i, path)=>
			_delay = if i == 0 || i == 3 then 1500 else 2100
			setTimeout ->
				path.visible = true
			, _delay
			return

		# 炎の位置調整
		@position.y -= 35
		TweenMax.to @position, 0.75, {
			y: 0
			delay: 1.8
		}
		return

module.exports = FireView