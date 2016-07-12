require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
BaseView				= require './base-view'
LogoTypeView		= require './logo-type-view'
LogoGroupView		= require './logo-group-view'
SoundManager		= require 'sound-manager'

CENTER					= 'center'
LEFT						= 'left'
RIGHT						= 'right'
SE_LIST = [
	"escape-se2"
	"escape-se3"
	"escape-se4"
	"escape-se5_1"
	"escape-se5_2"
]

# 
# 避けるシーンクラス
# 
class Escape extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Escape
		# ボタンモーフィング用
		btn = Utils.getSvgChild Config.SVG.BASE, 0
		btnLeft = Utils.getSvgChild @sceneConfig.SVG.Left, 0
		btnRight = Utils.getSvgChild @sceneConfig.SVG.Right, 0

		# 土台モーフィング用
		base = Utils.getSvgChild Config.SVG.BASE, 1
		baseLeft = Utils.getSvgChild @sceneConfig.SVG.Left, 1
		baseRight = Utils.getSvgChild @sceneConfig.SVG.Right, 1
		
		@btn = new BtnView [btnLeft, btn, btnRight], 1
		@base = new BaseView [baseLeft, base, baseRight], 1
		@logoGroup = new LogoGroupView @btn, @base
		@logoType = new LogoTypeView()
		@container.addChildren [@logoGroup, @logoType]
		@escapePosition = CENTER
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		# SE設定
		@seList = Utils.getSElist @sceneConfig.SOUND
		@container.position.x = 0
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@escapePosition = CENTER
		@removeChildren()
		@logoGroup.end()
		@logoType.end()
		@btn.end()
		@base.end()
		
		return

	# 
	# マウス/タッチ アップ
	# 
	_onTouchUp: ->
		@movObject()

	# 
	# マウス/タッチ ダウン
	# 
	_onTouchDown: ->
		@movObject()
		return

	# 
	# マウス/タッチ ムーブ
	# 
	_onTouchMove: ->
		@movObject()
		return

	# 
	# アップデート
	# 
	_onUpdate: ->
		# ぶるぶる
		if @mode == SceneBase.Mode.Touching
			p = @press / 2
			if p < 0 then p = 0
			else if p > 1 then p = 1
			p = TWEEN.Easing.Expo.InOut(p)
			x = Math.sin(new Date().getTime() * 0.08) * 0.5 * p
			if @escapePosition == LEFT 
				x -= @paper.width * 0.025 * p
				morph = 0.25 - (p * 0.25)
			else if @escapePosition == RIGHT 
				x += @paper.width * 0.025 * p
				morph = 1.75 + (p * 0.25)
			@container.position.x = x
			# モーフィング
			@btn.morphingUpdate? morph
			@base.morphingUpdate? morph
		else if @mode == SceneBase.Mode.Standby
			# モーフィング
			@btn.morphingUpdate? 1
			@base.morphingUpdate? 1
		else
			@btn.morphingUpdate?()
			@base.morphingUpdate?()

		return

	# 
	# ボタンの移動
	# 
	movObject: ->
		if @mode == SceneBase.Mode.Standby && @press < 1
			pos = CENTER
		else
			if @escapePosition == CENTER
				pos = if @point.x > @paper.width * @paper.scale * 0.5 then LEFT else RIGHT
			else
				if @point.x > @paper.width * @paper.scale * 0.6
					pos = LEFT
				else if @point.x < @paper.width * @paper.scale * 0.4
					pos = RIGHT
				else
					pos = @escapePosition

		if pos == @escapePosition then return
		@escapePosition = pos

		if @escapePosition == LEFT
			toX = @paper.width * -0.45
		else if @escapePosition == RIGHT
			toX = @paper.width * 0.45
		else
			toX = 0

		if @escapePosition == CENTER
			# SE
			_se = Utils.getSE @seList.SE2
			SoundManager.play _se
		else
			# SE
			_se = Utils.getSE @seList.SE1
			SoundManager.play _se
		

		# 移動
		@logoGroup.move toX
		@logoType.move toX

		return

	# 
	# ボタンが押し切られた時
	# 
	_onEffect: ->
		@swap()
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		if @escapePosition == LEFT
			_toX = @paper.width * 1.5
			@nextContainer.position.x = -@paper.width
		else
			_toX = @paper.width * -1.5
			@nextContainer.position.x = @paper.width


		# SE
		setTimeout =>
			_se = Utils.getSE @seList.SE3
			SoundManager.play _se
		,350

		# アクティブシーンの移動
		TweenMax.to @container.position, .4, {
			x: _toX
			ease: Back.easeIn
		}

		# モーフィング
		@btn.swap()
		@base.swap()


		# 次のシーンの移動
		@addChild @nextContainer
		TweenMax.to @nextContainer.position, .6, {
			x: 0
			delay: .6
			ease: Expo.easeInOut
			onComplete: @end
		}

		return

module.exports = Escape