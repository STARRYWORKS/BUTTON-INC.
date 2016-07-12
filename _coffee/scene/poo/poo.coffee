require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
Base						= require 'base'
LogoTypeView		= require './logo-type-view'
SoundManager		= require 'sound-manager'

# 
# 落下シーンクラス
# 
class Poo extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Poo
		@btn = new BtnView()
		@base = new Base()
		@logoType = new LogoTypeView()

		@container.addChildren [@btn, @base, @logoType]

		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@container.position.x = 0
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@removeChildren()
		@btn.end()
		@logoType.end()
		return

	#
	# 更新時
	#
	_onUpdate: ->
		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby 
			@btn.update()
		return

	# 
	# スタンバイ時
	# 
	_onStandby: ->
		@btn.up()
		return

	# 
	# マウス/タッチ アップ
	# 
	_onTouchUp: ->
		if @mode == SceneBase.Mode.Standby
			@btn?.up()
		return
	#
	# エフェクト
	#
	_onEffect: ->
		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se
		# 落ちる
		@logoType.effect()
		# 落ちる
		@btn.effect()
			.then @swap

		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		# アクティブシーンの移動
		TweenMax.to @container.position, .6, {
			x: @paper.width
			ease: Expo.easeInOut
			onComplete: @end
		}
		
		# 次のシーンの移動
		@nextContainer.position.x = -@paper.width
		@addChild @nextContainer
		TweenMax.to @nextContainer.position, .6, {
			x: 0
			ease: Expo.easeInOut
		}
		return


module.exports = Poo