require 'extension'
LogoType	= require 'logo-type'
Config		= require 'config'
Utils			= require 'utils'


# 
# おばけシーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Ghost
		@dashedLogo = @importSVG @sceneConfig.SVG.Dashed
		@dashedLogo.visible = false
		return

	# 
	# 破線にする
	# 
	dashed: ->
		@dashedLogo.visible = true

	# 
	# 線にする
	# 
	solid: =>
		@dashedLogo.visible = false
		return

module.exports = LogoTypeView