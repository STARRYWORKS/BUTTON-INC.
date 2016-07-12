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
class Fall extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Fall
		@btn = new BtnView()
		@base = new Base()
		@logoType = new LogoTypeView()

		@container.addChildren [@btn, @base, @logoType]

		# 次シーンの土台、ロゴタイプ削除
		@nextContainer.removeChildren(1)
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
	# 
	# 
	_onTouchUp: ->
		@btn.morphing()
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
		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se

		# 落ちる
		@btn.effect()
		# 避ける
		@logoType.effect()

		# 次のシーンの移動
		@nextContainer.position.y = -@paper.height * .5
		@insertChild 0, @nextContainer
		TweenMax.to @nextContainer.position, .3, {
			delay: .4
			y: 0
			ease: Bounce.easeOut
			onComplete: @swap
		}
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return

module.exports = Fall