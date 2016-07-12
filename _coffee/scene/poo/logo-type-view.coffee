require 'extension'
LogoType = require 'logo-type'
Config = require 'config'
Utils = require 'utils'

# 
# 落下シーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@position.y = 0
		return

	# 
	# 
	# 
	effect: ->
		TweenMax.to @position, .15, {
			y: 120
			ease: Back.easeOut
		}
		return

module.exports = LogoTypeView