require 'extension'
Config				= require 'config'
Utils					= require 'utils'
SceneBase			= require 'scene-base'
BtnView				= require './btn-view'
BaseView			= require './base-view'
LogoType			= require 'logo-type'
LogoGroupView	= require './logo-group-view'
LogoTypeView	= require './logo-type-view'
SoundManager	= require 'sound-manager'

# 
# ジャンプシーンクラス
# 
class Jump extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Jump
		base = Utils.getSvgChild Config.SVG.BASE, 1
		basePress = Utils.getSvgChild @sceneConfig.SVG.BasePress

		@btn = new BtnView()
		@btn.soft = 1
		@base = new BaseView [base, basePress]
		@logoType = new LogoTypeView()
		@logoGroup = new LogoGroupView(@btn, @base)
		@container.addChildren [@logoGroup, @logoType]
		@isSePlaying = false
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		# SE
		@sePress = Utils.getSE @sceneConfig.SOUND.SE1
		@seNoPress = Utils.getSE @sceneConfig.SOUND.SE2

		@container.position.x = 0
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@removeChildren()
		@base.end()
		@logoGroup.end()
		@logoType.end()
		return

	#
	# モードが変わったとき
	#
	_onModeChange: ->
		if @mode == SceneBase.Mode.Touching #タッチ中
			SoundManager.play @sePress, 0, true
			@isSePlaying = true

		else if @mode == SceneBase.Mode.Standby #スタンバイ中
			if @isSePlaying then SoundManager.play @seNoPress
			@isSePlaying = false
			SoundManager.stop @sePress

		else if @mode == SceneBase.Mode.Effect
			@isSePlaying = false
			SoundManager.stop @sePress

		return

	#
	# 更新時
	#
	_onUpdate: ->

		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching
			
			# 左右に揺らす
			press = @press / 2
			if press < 0 then press = 0
			if press > 1 then press = 1
			press = TWEEN.Easing.Sine.In(press)

			now = new Date().getTime()
			@position.x = @basePosX + Math.sin(now * 0.025) * press * 1
		else
			@position.x = @basePosX

		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby
			@base.update()
			@btn?.update @base.morph
			@logoType?.update()

		return


	#
	# エフェクト
	#
	_onEffect: ->
		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE3
		SoundManager.play _se

		# ロゴ飛んで行く
		@logoGroup.effect(@press, @vector).then @swap

		# ロゴタイプ平体戻る
		@logoType.effect()

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

module.exports = Jump