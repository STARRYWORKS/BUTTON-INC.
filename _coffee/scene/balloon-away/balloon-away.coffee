require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
Base						= require 'base'
LogoType				= require 'logo-type'
PaperStage			= require 'paper-stage'
SoundManager		= require 'sound-manager'

# 
# エレベーターシーンクラス
# 
class BalloonAway extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.BalloonAway
		pull = Utils.getSvgChild Config.SVG.PULL
		base = Utils.getSvgChild Config.SVG.BASE
		press = Utils.getSvgChild Config.SVG.PRESS
		infred = Utils.getSvgChild @sceneConfig.SVG.Inflate

		@btn = new BtnView [pull, base, press, infred]
		@btn.soft = 1
		@base = new Base()
		@logoType = new LogoType()
		@mask = new paper.Group()
		@container.addChildren [@btn, @mask, @base, @logoType]

		# mask設定
		_size = new paper.Size @container.bounds.width, @container.bounds.height
		_point = new paper.Point @container.bounds.x, @container.bounds.y + @btn.bounds.height 
		_shape = new paper.Shape.Rectangle _point, _size
		_shape.fillColor = "#FFFFFF"
		Utils.transformInit _shape
		@mask.addChild _shape

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
			.then => SoundManager.stop _se
			.then -> Utils.wait 100
			# 飛んで行く
			.then @btn.away
			# はえてくる
			.then @btn.grow
			.then @swap
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return

module.exports = BalloonAway