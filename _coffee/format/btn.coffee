Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'

# 
# ボタンオブジェクト
# @param {Object} path: パスデータ
# @param {Number} morph: モーフィングの初期位置(デフォルト:1)
# 
class Btn extends paper.Group

	constructor: (pathes, morph = 1) ->
		super()

		Utils.transformInit @
		@morph = morph

		@PressSVG = @importSVG Config.SVG.PRESS
		@PressSVG.remove()
		@Press = @PressSVG.children[0]

		@baseSVG = @importSVG Config.SVG.BASE
		@baseSVG.remove()
		@base = @baseSVG.children[0]

		@pullSVG = @importSVG Config.SVG.PULL
		@pullSVG.remove()
		@pull = @pullSVG.children[0]

		@pathes = []

		# 引数でパスがあれば上書きなければベーシック
		if pathes?
			for path in pathes
				@pathes.push path
		else
			@pathes = [
				@pull.clone()
				@base.clone()
				@Press.clone()
			]

		# 線
		@stroke = new MorphablePath @pathes, @morph
		@stroke.fillColor = new paper.Color(0,0,0,0)
		@stroke.strokeColor = Config.COLOR.BTN_PATH
		@stroke.strokeWidth = Config.LINE_WIDTH
		@addChild @stroke

		# 塗
		@fill = new MorphablePath @pathes, @morph
		@fill.fillColor = Config.COLOR.BTN_FILL
		@fill.strokeWidth = 0
		@insertChild(0, @fill)

		@pressOffset = 0
		@press = 0

		# ボタンの押下の押し加減(val:1 ~ 0)
		@pressWeight = 0

		# ボタンの押下の柔らかさ(val:1 ~ 0)
		@soft = 0.4

		@init()

		return

	# 
	# イニシャライズ
	# 
	init: ->
		@_onInit()
		return

	# 
	# アップデート
	# 
	update: =>
		if @press < -1 then @press = -1
		else if @press > 2 then @press = 2

		press = @press * 0.75 + @pressOffset * 0.25
		
		# y座標
		y = press
		if y < 0 then y = 0
		else if y > 1 then y = 1

		# 押し加減調整
		y = y * (1 - @pressWeight)

		@position.y = TWEEN.Easing.Sinusoidal.InOut(y) * 20
		
		if @press < 0
			@morph = @press + 1
			@stroke.update @morph
			@fill.update @morph

		else if @press > 1
			# 柔らかさ調整
			@morph = 1 + ((@press - 1) * @soft)
			@stroke.update @morph
			@fill.update @morph

		@_onUpdate()
		return

	# 
	# マウスを押した時
	# 
	down: =>
		@downTween = new TWEEN.Tween(@)
			.to({'pressOffset': 1}, 150)
			.easing(TWEEN.Easing.Expo.Out)
			.start()

		@_onDown()
		return
	
	# 
	# マウスを離した時
	# 
	up: =>
		@tween = new TWEEN.Tween(@)
			.to({'press': 0, 'pressOffset': 0}, 100)
			.onUpdate( =>
				@update()
			)
			.easing(TWEEN.Easing.Back.Out)
			.start()

		@_onUp()
		return

	# 
	# リセット
	# @param {Number} morph: モーフィング位置
	# 
	reset: (morph = 1)->
		@visible = true
		@morph = morph
		@press = 0
		@pressOffset = 0
		@position.set 0, 0
		
		@stroke.visible = true
		@stroke.opacity = 1
		@stroke.position.set 0, 0
		@stroke.update @morph
		@stroke.strokeColor = Config.COLOR.BTN_PATH

		@fill.visible = true
		@fill.opacity = 1
		@fill.position.set 0, 0
		@fill.update @morph
		@fill.fillColor = Config.COLOR.BTN_FILL
		return


#*******************************
# サブクラスで実装すべきメソッド
#*******************************
	# 
	# 
	# 
	_onInit: ->
		return

	# 
	# 
	# 
	_onUpdate: ->
		return

	# 
	# 
	# 
	_onDown: ->
		return

	# 
	# 
	# 
	_onUp: ->
		return

module.exports = Btn
