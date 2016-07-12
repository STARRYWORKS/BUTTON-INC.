require 'extension'
Config						= require 'config'
Utils							= require 'utils'
SceneBase					= require 'scene-base'
Btn								= require 'btn'
Base							= require 'base'
LogoType					= require 'logo-type'
CardboardBoxView	= require './cardboard-box-view'
SoundManager			= require 'sound-manager'

# 
# エレベーターシーンクラス
# 
class Delivery extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Delivery
		@btn = new Btn()
		@base = new Base()
		@logoType = new LogoType()
		@cardboardBox = new CardboardBoxView()
		@container.addChildren [@btn, @base, @logoType, @cardboardBox]
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@container.position.x = 0
		@btn.position.y = 0
		@base.position.y = 0
		@cardboardBox.start()
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@cardboardBox.end()
		@removeChildren()
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
	# エフェクト
	#
	_onEffect: ->
		# SE 挨拶
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se

		# ダンボールアニメーション
		# 挨拶を終わるまで待つ
		Utils.wait 350
			.then =>
				# ボタン落とす
				TweenMax.to @btn.position, .3 ,{
					y: @paper.height * 0.7
					ease: Cubic.easeOut
					delay: .55
				}
				TweenMax.to @base.position, .3 ,{
					y: @paper.height * 0.7
					ease: Cubic.easeOut
					delay: .55
				}
			# ダンボール運ばれる
			.then @cardboardBox.effect
			.then @swap
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return

module.exports = Delivery