require 'extension'
Config				= require 'config'
Utils					= require 'utils'
SceneBase			= require 'scene-base'
Btn						= require 'btn'
BtnView				= require './btn-view'
BaseView			= require './base-view'
LogoTypeView	= require './logo-type-view'
# WarnigView		= require './warning-view'
SoundManager	= require 'sound-manager'

# 
# プリンシーンクラス
# 
class Explosion extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Explosion
		btnPull = Utils.getSvgChild Config.SVG.PULL
		btn = Utils.getSvgChild Config.SVG.BASE
		btnPress = Utils.getSvgChild Config.SVG.PRESS
		btnInflated = Utils.getSvgChild @sceneConfig.SVG.Inflated

		@btn = new BtnView [btnPull, btn, btnPress, btnInflated]
		@btn.soft = 0
		@base = new BaseView()
		@logoType = new LogoTypeView()
		@container.addChildren [@btn, @base, @logoType]

		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		# SE
		@seSiren = Utils.getSE @sceneConfig.SOUND.SE1
		@seOn = Utils.getSE @sceneConfig.SOUND.SE2
		@container.position.x = 0
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		# SE Loop Stop
		@container.visible = true
		@removeChildren()
		@btn.end()
		@base.end()
		@logoType.end()

		return


	#
	# モードが変わったとき
	#
	_onModeChange: ->
		if @mode == SceneBase.Mode.Touching #タッチ中
			# @bgWarning?.show()
			@logoType.warningShow()
			SoundManager.play @seSiren, 0, true

		else if @mode == SceneBase.Mode.Standby #スタンバイ中
			@logoType.warningHide()
			SoundManager.stop @seSiren, 300

		else if @mode == SceneBase.Mode.Effect
			@logoType.warningHide()

	#
	# 更新時
	#
	_onUpdate: ->
		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby 
			@btn.press = @press
			@btn.update()
		if @mode == SceneBase.Mode.Touching #タッチ中
			@logoType.warningUpdate()
		return

	# 
	# マウス/タッチ ダウン
	# 
	_onTouchMove: ->
		@pressed = false


	# 
	# マウス/タッチ ムーブ
	# 
	_onTouchMove: ->
		if !@pressed
			if @press >= 1
				# ボタン押し込んだ時にカチっ
				SoundManager.play @seOn
				@pressed = true
		else if @press < 1
			@pressed = false


	# 
	# マウス/タッチ アップ
	# 
	_onTouchUp: ->
		if @mode == SceneBase.Mode.Standby
			@btn.up()
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
		# 膨れる
		@btn.inflated()
			# 警告音止める
			.then => SoundManager.stop @seSiren
			# ロゴタイプ爆発
			.then => @logoType.explosion @bounds.width
			# 土台爆発
			.then => @base.explosion @bounds.width
			# ボタン爆発
			.then => @btn.explosion @bounds.width
			# 次シーン
			.then @swap

		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		# アクティブシーンの移動
		@container.visible = false
		
		# 次のシーンの移動
		@nextContainer.position.y = @paper.height
		@addChild @nextContainer
		TweenMax.to @nextContainer.position, .6, {
			y: 0
			ease: Expo.easeInOut
			onComplete: @end
		}
		return

module.exports = Explosion