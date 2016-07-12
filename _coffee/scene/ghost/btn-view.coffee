require 'extension'
Btn = require 'btn'

# 
# おばけシーンで使用するためのボタンクラス
# 
class BtnView extends Btn
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

module.exports = BtnView