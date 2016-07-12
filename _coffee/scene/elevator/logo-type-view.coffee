LogoType = require 'logo-type'

# 
#  エレベーターシーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType

	# 
	# 扉開く時ロゴ表示
	# 
	show: =>
		@visible = true
		return


	# 
	# 扉閉まる時ロゴ非表示
	# 
	hide: ->
		@visible = false
		return



module.exports = LogoTypeView