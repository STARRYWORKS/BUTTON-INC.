require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
Base						= require 'base'
LogoType				= require 'logo-type'
BangView				= require './bang-view'
SoundManager		= require 'sound-manager'

# 
# エレベーターシーンクラス
# 
class BalloonFailure extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.BalloonFailure
		pull = Utils.getSvgChild Config.SVG.PULL
		base = Utils.getSvgChild Config.SVG.BASE
		press = Utils.getSvgChild Config.SVG.PRESS
		infred = Utils.getSvgChild @sceneConfig.SVG.Inflate

		@btn = new BtnView [pull, base, press, infred]
		@base = new Base()
		@logoType = new LogoType()
		@bang = new BangView()
		@container.addChildren [@btn, @base, @logoType, @bang]
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
		@btn.end()
		@bang.end()
		@removeChildren()
		return

	#
	# 更新時
	#
	_onUpdate: ->
		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby
			@btn.update()
		else if @mode == SceneBase.Mode.Effect
			@btn.morphingUpdate()
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

	#
	# エフェクト
	#
	_onEffect: ->
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se
		# 膨らむ
		@btn.infred()
			# 破裂
			.then @btn.expansion
			# 破裂効果
			.then @bang.show
			# はえてくる
			.then @btn.grow
			# 終了
			.then @swap
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return

module.exports = BalloonFailure