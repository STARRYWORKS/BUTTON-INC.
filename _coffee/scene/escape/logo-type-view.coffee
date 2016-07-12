LogoType = require 'logo-type'

# 
#  避けるシーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	# 
	# アクティブシーン終了時
	# 
	end:->
		@position = new paper.Point 0, 0
		return

	# 
	# 移動
	# @param {number} toX: x座標の移動位置
	# 
	move: (toX)->
		if @moveTween? then @moveTween.kill()
		@moveTween = TweenMax.to @position, .275, {
			x: toX
			ease: Cubic.easeOut
		}
		return


module.exports = LogoTypeView