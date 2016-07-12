require 'extension'
Utils = require 'utils'

# 
# 避けるシーンで使用するためのロゴグループクラス
# @param {Object} btn: ボタン
# @param {Object} base: 土台
# 
class LogoGroupView extends paper.Group
	constructor: (btn, base) ->
		@btn = btn
		@base = base
		super [btn, base]

		Utils.transformInit @

	# 
	# 移動
	# @param {number} toX: x座標の移動位置
	# 
	move: (toX)->
		if @moveTween? then @moveTween.kill()
		@moveTween = TweenMax.to @position, .25, {
			x: toX
			ease: Expo.easeOut
		}

		return

	# 
	# アクティブシーン終了時
	# 
	end:->
		@position = new paper.Point 0, 0
		return

module.exports = LogoGroupView