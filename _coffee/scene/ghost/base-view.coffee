require 'extension'
Base = require 'base'

# 
# おばけシーンで使用するためのベースクラス
# 
class BaseView extends Base
	# 
	# 表示
	#
	show:=>
		@visible = true
		return

	# 
	# 非表示
	# 
	hide:->
		@visible = false
		return

module.exports = BaseView