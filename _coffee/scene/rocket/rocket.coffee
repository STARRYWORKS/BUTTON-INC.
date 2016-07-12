require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
BaseView				= require './base-view'
Base						= require 'base'
RocketGroupView	= require './rocket-group-view'
LogoTypeView		= require './logo-type-view'
SmokeView				= require './smoke-view'
FireView				= require './fire-view'
CountdownView		= require './countdown-view'
SoundManager		= require 'sound-manager'

# 
# エレベーターシーンクラス
# 
class Rocket extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Rocket

		@btn = new BtnView()
		@base = new BaseView()

		@fire = new FireView()
		@smoke = new SmokeView()

		@rocket = new RocketGroupView @btn, @fire
		@logoType = new LogoTypeView()
		@countdown = new CountdownView()
		@container.addChildren [@rocket, @base, @logoType, @smoke, @countdown]

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
		# @rocket.insertBelow @base
		@logoType.end()
		@rocket.end()
		@fire.end()
		@btn.end()
		@base.end()
		@smoke.end()
		@countdown.end()

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
		if  @mode == SceneBase.Mode.Standby 
			@btn?.up()
		return

	#
	# エフェクト
	#
	_onEffect: ->
		# 変形
		@btn.change()
		@rocket.change()
		# @rocket.insertAbove @base
		# カウントダウン
		@countdown.effect()
			# ボタンモーフィング
			# .then @btn.morphing
			.then @smoke.show
			# 炎
			.then @fire.effect
			# 土台下がる
			.then @smoke.scroll
			# 土台下がる
			.then @base.scroll
			# ロゴタイプ下がる
			.then @logoType.scroll
			# ロゴスクロールの最後の方で上がっていく
			.then @rocket.goOut
			#シーン移行
			.then @swap
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		# 次のシーンの移動
		@nextContainer.position.y = @paper.height
		@addChild @nextContainer
		TweenMax.to @nextContainer.position, .6, {
			y: 0
			ease: Expo.easeInOut
			onComplete: @end
		}
		return

module.exports = Rocket