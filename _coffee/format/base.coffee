Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'
CustomStroke	= require 'custom-stroke'

# 
# 土台オブジェクト
# @param {Object} pathes: パスデータ
# @param {Number} morph: モーフィングの初期位置(デフォルト:0)
# 
class Base extends paper.Group
	constructor: (pathes, morph = 0) ->
		super()

		Utils.transformInit @
		@morph = morph

		# ベース
		@baseSVG = @importSVG Config.SVG.BASE
		@baseSVG.remove()
		@base = @baseSVG.children[1]

		@pathes = []
		
		# 引数でパスがあれば上書きなければベーシック
		if pathes?
			for path in pathes
				@pathes.push path
		else
			@pathes = [
				@base
			]

		# 線設定
		@boneStroke = new MorphablePath @pathes, @morph
		@boneStroke.strokeWidth = 0.2
		@boneStroke.strokeColor = new paper.Color(255,0,0,1)
		@boneStroke.remove()

		# 角丸
		settings = [
			[1.0,		1.0]
			[0,			0]
			[2.75,	0]
			[2.75,	0]
			[0,			0]
			[1.0,		1.0]
		]
		@stroke = new CustomStroke @boneStroke, Config.LINE_WIDTH, settings
		@stroke.strokeWidth = 0
		@stroke.fillColor = new paper.Color 0,0,0,1
		@addChild @stroke
		# @addChild @boneStroke
		# @stroke.fullySelected = true

		# 塗り設定
		@fillPathes = []
		for path in @pathes
			_fill = path.clone()
			@fillInit _fill
			@fillPathes.push _fill

		@fill = new MorphablePath @fillPathes, @morph
		@fill.strokeWidth = 0
		@fill.fillColor = Config.COLOR.BASE_FILL
		@insertChild 0, @fill

		Utils.transformInit [@boneStroke, @fill, @stroke]
		

		@press = 0
		@init()

		return

	# 
	# 塗り用のパスのイニシャライズ
	# @param {Object} path: パス情報
	# 
	fillInit: (path)->
		# 塗りに必要ない両端のポイントを削除
		path.segments.pop()
		path.segments.shift()
		path.closed = true

		# 線幅分だけ塗りを伸ばす
		# 左
		vector = path.segments[0].point.subtract(path.segments[1].point)
		vector.length = Config.LINE_WIDTH * 0.5
		path.segments[0].point = path.segments[0].point.add(vector)
		
		# 右
		last = path.segments.length - 1
		vector = path.segments[last].point.subtract(path.segments[last - 1].point)
		vector.length = Config.LINE_WIDTH * 0.5
		path.segments[last].point = path.segments[last].point.add(vector)
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
		@_onUpdate()
		return

	# 
	# マウスを押した時
	# 
	down: =>
		@_onDown()
		return
	
	# 
	# マウスを離した時
	# 
	up: =>
		@_onUp()
		return

	# 
	# リセット
	# @param {Number} morph: モーフィング位置
	# 
	reset: (morph = 0)->
		@morph = morph
		@press = 0
		@position.set 0, 0
		
		@boneStroke.visible = true
		@boneStroke.opacity = 1
		@boneStroke.position.set 0, 0
		@boneStroke.update @morph
		@boneStroke.strokeColor = Config.COLOR.BASE_PATH

		@stroke.visible = true
		@stroke.fillColor = new paper.Color 0,0,0,1
		@stroke.update()

		@fill.visible = true
		@fill.opacity = 1
		@fill.position.set 0, 0
		@fill.update @morph
		@fill.fillColor = Config.COLOR.BASE_FILL

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

module.exports = Base