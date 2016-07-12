LogoType = require 'logo-type'

# 
# プリンシーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@position.y = 0
		return

	# 
	# プリンと一緒にロゴも落ちるアニメーション
	# 
	effect: ->
		TweenMax.to @position, .15, {
			y: 60
			ease: Back.easeOut
		}

		return

module.exports = LogoTypeView
