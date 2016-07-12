require 'extension'
Config				= require 'config'
Utils					= require 'utils'
SceneBase			= require 'scene-base'
BtnView				= require './btn-view'
Base					= require 'base'
LogoTypeView	= require './logo-type-view'
PuddingView		= require './pudding-view'
SoundManager	= require 'sound-manager'

# 
# プリンシーンクラス
# 
class Pudding extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Pudding

		pull = Utils.getSvgChild Config.SVG.PULL
		base = Utils.getSvgChild Config.SVG.BASE
		press = Utils.getSvgChild Config.SVG.PRESS
		change = Utils.getSvgChild @sceneConfig.SVG.Stretch

		# @leftSVG = Utils.getSvgChild @sceneConfig.SVG.LEFT
		# @rightSVG = Utils.getSvgChild @sceneConfig.SVG.RIGHT
		
		@btn = new BtnView [pull, base, press, change]
		@btn.soft = 1
		@base = new Base()
		@logoType = new LogoTypeView()
		@pudding = new PuddingView()
		@container.addChildren [@btn, @pudding, @base, @logoType]

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
		@pudding.end()
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
		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se

		# 落ちながら非表示
		@btn.fall()

		# 落ちながら表示
		@pudding.fall()
			# 垂れる
			.then @pudding.drip
			.then @swap

		# プリンが落ちてきたタイミングてロゴも落とす
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

module.exports = Pudding