require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
BaseView				= require './base-view'
Base						= require 'base'
UfoView					= require './ufo-view'
LogoTypeView		= require './logo-type-view'
SoundManager		= require 'sound-manager'

# 
# エレベーターシーンクラス
# 
class Ufo extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Ufo
		# ボタン
		btnPull = Utils.getSvgChild Config.SVG.PULL
		btn = Utils.getSvgChild Config.SVG.BASE, 0
		btnPress = Utils.getSvgChild Config.SVG.PRESS
		btnUfo = Utils.getSvgChild @sceneConfig.SVG.Btn, 0

		@btn = new BtnView [btnPull, btn, btnPress, btnUfo]
		@parts = new BaseView()

		# UFOの土台のパスが違うため塗が足りていないため下に通常の土台を表示
		@baseBg = new Base()

		@ufo = new UfoView @btn, @parts, @baseBg
		@logoType = new LogoTypeView()
		@container.addChildren [@logoType, @ufo]

		# 最後にロゴ降らすため不要
		@nextContainer.removeChildren 2

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
		@logoType.end()
		@btn.end()
		@parts.end()
		@ufo.end()

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
	# マウス/タッチ アップ
	# 
	_onTouchUp: ->
		if @mode == SceneBase.Mode.Standby 
			@btn?.up()

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
		# 土台非表示
		@ufo.baseBgHide()

		# ボタン変形
		@btn.change()
			# 土台変形
			.then @parts.change
			# 残りパーツ表示
			.then @ufo.change
			# 視点を上に
			# .then @bg.up
			# 文字下に
			.then @logoType.fly
			# 飛ぶ
			.then @ufo.fly
			# 吸い込まれる
			.then @logoType.suck
			# 飛んで行く
			.then @ufo.float
			.then Utils.wait 200
			# ロゴ降ってくる
			.then @logoType.fall
			# 次の配置(ボタンのみ)上から落とす
			.then => 
				@nextContainer.position.y = -(@paper.height / 2)
				@addChild @nextContainer
				position = @nextContainer.position
				TweenMax.to position, .35, {
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

module.exports = Ufo