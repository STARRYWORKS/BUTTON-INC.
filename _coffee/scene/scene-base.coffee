Config			= require 'config'
Utils				= require 'utils'
Btn					= require 'btn'
Base				= require 'base'
LogoType		= require 'logo-type'
# PixiStage		= require 'pixi-stage'
PaperStage	= require 'paper-stage'
#
# SceneBaseクラス
# @param {Object} onEnd: シーン終了時コールバック
# 
class SceneBase extends paper.Group

	@Mode: {
		NotAdded	: 0
		Standby		: 1
		Touching	: 2
		Effect		: 3
		Swapping	: 4
	}

	constructor: (onEnd)->
		super()

		# 起点の設定
		Utils.transformInit @
		
		@paper = PaperStage.instance
		# @pixi = PixiStage.instance
		@onEnd = onEnd
		@press = 0
		@changeMode(SceneBase.Mode.NotAdded)
		
		@container = new paper.Group()
		@container.remove()

		@nextContainer = new paper.Group()
		@nextContainer.remove()

		# 起点の設定
		Utils.transformInit [@container, @nextContainer]
		@init()
		return

	#
	# init
	#
	init: ->
		# 次シーン用のオブジェクトとコンテナ設定
		btn = new Btn()
		base = new Base()
		logoType = new LogoType()
		@nextContainer.addChild btn
		@nextContainer.addChild base
		@nextContainer.addChild logoType

		@_onInit()
		return

	# 
	# アクティブシーンになる時
	# 
	start: ()->
		@position.x = @basePosX = 8 # ボタン中央配置微調整
		@press = 0
		@paper.stage.insertChild 0, @
		@_onStart()
		@changeMode(SceneBase.Mode.Standby)
		return

	# 
	# 非アクティブシーンになる時
	# 
	end: =>
		@press = 0
		@removeChildren()
		@remove()
		@changeMode(SceneBase.Mode.NotAdded)
		@_onEnd() #サブクラス用メソッド
		@onEnd?() #コール基で設定されたコールバックメソッド
		return

	# 
	# リサイズ
	# 
	resize : ->
		@_onResize()
		return

	#
	# アップデート
	#
	update : ->
		@_onUpdate()
		return

	# 
	# マウス/タッチ ダウン
	# 
	touchDown: (point, press) =>
		if @mode != SceneBase.Mode.Standby then return
		@changeMode(SceneBase.Mode.Touching)
		@point = point
		@press = press
		@_onTouchDown()
		return

	# 
	# マウス/タッチ ムーブ
	# 
	touchMove: (vector, point, press) =>
		if @mode != SceneBase.Mode.Touching then return
		@vector = vector
		@point = point
		@press = press
		@_onTouchMove()
		return

	# 
	# マウス/タッチ アップ
	# 
	touchUp: (vector, point, press) =>
		if @mode != SceneBase.Mode.Touching then return
		@vector = vector
		@point = point
		@press = press
		if @press >= 1
			@changeMode(SceneBase.Mode.Effect)
		else
			@changeMode(SceneBase.Mode.Standby)
		@_onTouchUp()

		return

	#
	#
	#
	swap: () =>
		@changeMode(SceneBase.Mode.Swapping)
		return
		
	#
	# シーンステータス管理
	# @param {Number} mode: シーン状態
	#
	changeMode: (mode) ->
		@mode = mode
		@_onModeChange(@mode)

		if @mode ==				SceneBase.Mode.NotAdded		then @_onNotAdded()
		else if @mode ==	SceneBase.Mode.Standby		then @_onStandby()
		else if @mode ==	SceneBase.Mode.Touching		then @_onTouching()
		else if @mode ==	SceneBase.Mode.Effect			then @_onEffect()
		else if @mode ==	SceneBase.Mode.Swapping		then @_onSwapping()
		return



#*******************************
# サブクラスで実装すべきメソッド
#*******************************

	# 
	# モード変更
	# 
	_onModeChange: (mode) ->
		return

	#
	#
	#
	_onStandby: () ->
		return

	#
	#
	#
	_onTouching: () ->
		return

	#
	#
	#
	_onEffect: () ->
		return

	#
	#
	#
	_onSwapping: () ->
		return

	#
	#
	#
	_onNotAdded: () ->
		return

	# 初期化・リサイズなど

	# 
	# 
	# 
	_onInit: ->
		return

	# 
	# 
	# 
	_onResize: ->
		return

	# 
	# 
	# 
	_onStart: (isAnimate)->
		return

	# 
	# 
	# 
	_onEnd:->
		return

	# 
	# 
	# 
	_onUpdate: ->
		return


	# タッチイベント

	# 
	# 
	# 
	_onTouchDown: ->
		@btn?.down()
		@base?.down()
		@logoType?.down()
		return

	# 
	# 
	# 
	_onTouchMove: ->
		@btn?.press = @press
		@base?.press = @press
		@logoType?.press = @press
		return

	# 
	# 
	# 
	_onTouchUp: ->
		@btn?.up()
		@base?.up()
		@logoType?.up()
		return

module.exports = SceneBase