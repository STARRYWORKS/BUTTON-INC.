Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
MorphablePath	= require 'morphable-path'

# 
# パトランプで使用する車クラス
# @param {Array} objcets: ボタンと土台
# 
class CarView extends paper.Group
	constructor: (objcets) ->
		super()
		@isMoving = false
		@sceneConfig = Config.PatrolLamp
		Utils.transformInit @

		# ランプ設定
		@lamp = @importSVG @sceneConfig.SVG.Lamp
		Utils.transformInit @lamp, false
		@lamp.visible = false
		
		# タイヤ設定
		@tireLeft = @importSVG @sceneConfig.SVG.TireLeft
		Utils.transformInit @tireLeft, false
		@tireLeft.visible = false
		
		@tireRight = @importSVG @sceneConfig.SVG.TireRight
		Utils.transformInit @tireRight, false
		@tireRight.visible = false

		# ライト
		light1 = Utils.getSvgChild @sceneConfig.SVG.Light1
		light2 = Utils.getSvgChild @sceneConfig.SVG.Light2
		@light = new MorphablePath [light1, light2], 0
		@light.fillColor = @sceneConfig.COLOR.LIGHT
		@light.visible = false
		
		# Btn
		@btn = objcets[0]
		@addChild @btn

		# ライト
		@addChild @light

		# ランプ
		@addChild @lamp

		# 土台
		@base = objcets[1]
		@addChild @base

		# タイヤ
		@addChildren [@tireLeft, @tireRight]

		
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@position.set 0,0
		@isMoving = false

		@tireLeft.scaling.set 1,1
		@tireRight.scaling.set 1,1
		@tireLeft.visible = false
		@tireRight.visible = false

		@lamp.scaling.set 1,1
		@lamp.visible = false

		@light.visible = false
		@lightTween.pause()

		return

	# 
	# タイヤ、ランプ表示
	# 
	change:=>
		df = new $.Deferred()
		tl = new TimelineMax({
			onComplete: df.resolve
		})
		
		TweenMax.to @position, .1, {
			y: -14
			ease: Back.easeOut
		}
		
		
		# ランプ表示
		@lamp.scaling.set 0.1, 0.1
		tl.to @lamp.scaling, .1, {
			x: 1
			y: 1
			ease: Back.easeOut
			onStart: => @lamp.visible = true
		}
		# タイヤ表示
		@tireLeft.scaling.set 0.1, 0.1
		tl.to @tireLeft.scaling, .1, {
			x: 1
			y: 1
			ease: Back.easeOut
			onStart: => @tireLeft.visible = true
		}
		@tireRight.scaling.set 0.1, 0.1
		tl.to @tireRight.scaling, .1, {
			x: 1
			y: 1
			ease: Back.easeOut
			onStart: => @tireRight.visible = true
		}
		return df.promise()

	# 
	# 
	# 
	changeReset: =>
		
		
		@tireLeft.visible = false
		@tireRight.visible = false
		@lamp.visible = false
		@light.visible = false
		@lightTween.pause()
		@btn.fill.fillColor = Config.COLOR.BTN_FILL

	# 
	# 定位置に戻す
	# 
	down:=>
		df = new $.Deferred()
		TweenMax.to @position, .2, {
			y: 0
			ease: Bounce.easeOut
			onComplete: df.resolve
		}
		return df.promise()

	# 
	# ライトと音
	# 
	siren: =>
		@isMoving = true

		# ライト
		@light.visible = true
		if !@lightTween?
			@lightTween = TweenMax.to @light, .6, {
				morph: 1
				repeat: -1
				onUpdate: @light.update
			}
		@lightTween.play()

		return

	# 
	# アップデート
	# 
	update: ->
		if !@isMoving then return
		@tireLeft.rotate 5
		@tireRight.rotate 5
		return

module.exports = CarView
