require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
BtnSquashView		= require './btn-squash-view'
Base						= require 'base'
LogoType				= require 'logo-type'
SoundManager		= require 'sound-manager'

# 
# つぶれるシーンクラス
# 
class Squash extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Squash
		pull = Utils.getSvgChild Config.SVG.PULL
		base = Utils.getSvgChild Config.SVG.BASE
		press = Utils.getSvgChild @sceneConfig.SVG.Press
		@btn = new BtnView [pull, base, press]
		@btnSquash = new BtnSquashView()
		@base = new Base()
		@logoType = new LogoType()
		@container.addChildren [@btn, @base, @logoType, @btnSquash]
		@isSePlaying = false
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@se = Utils.getSE @sceneConfig.SOUND.SE1
		@container.position.set 0,0
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@removeChildren()
		@btn.show()
		@btnSquash.end()
		return

	#
	# 更新時
	#
	_onUpdate: ->
		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby 
			@btn.update()

		if @mode == SceneBase.Mode.Touching && @press >= 1 && !@isSePlaying #タッチ中
			# SE
			@isSePlaying = true
			SoundManager.play @se, 0, true
		else if ( @mode != SceneBase.Mode.Touching || @press < 1 ) && @isSePlaying
			@isSePlaying = false
			SoundManager.stop @se
		return

	# 
	# スタンバイ時
	# 
	_onStandby: ->
		@btn.up()
		return

	#
	# エフェクト
	#
	_onEffect: ->
		@btn.hide()
		@btnSquash.effect().then @swap
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		# アクティブシーンの移動
		TweenMax.to @container.position, .6, {
			y: @paper.height
			ease: Expo.easeInOut
			onComplete: @end
		}
		
		# 次のシーンの移動
		@nextContainer.position.y = -@paper.height
		@addChild @nextContainer
		TweenMax.to @nextContainer.position, .6, {
			y: 0
			ease: Expo.easeInOut
		}
		return

module.exports = Squash