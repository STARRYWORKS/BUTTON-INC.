Config	= require 'config'
Utils		= require 'utils'

# 
# ロゴタイプオブジェクト
# @param {Object} path: パスデータ
# 
class LogoType extends paper.Group
	constructor: (pathes) ->
		super()
		@pathes = []

		Utils.transformInit @

		@logoTypeSVG = @importSVG Config.SVG.LOGO_TYPE
		@logoTypeSVG.remove()

		# パス設定
		for path in @logoTypeSVG.children
			Utils.transformInit path, false
			path.fillColor = Config.COLOR.LOGO_TYPE_FILL
			path.strokeWidth = 0
			@pathes.push path

		@addChildren @pathes

		@press = 0

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

module.exports = LogoType