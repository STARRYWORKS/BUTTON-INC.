Btn = require 'btn'

# 
# プリンシーンで使用するためのボタンクラス
# 
class BtnView extends Btn

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		return

	# 
	# 塗りの部分が落ちて揺れるアニメーション
	# 
	fall: ->
		# 落ちる
		TweenMax.to @fill.position, .6, {
			y: 100
			ease: Elastic.easeOut
		}
		# モーフィング
		TweenMax.to @fill, .12, {
			morph: 3
			opacity: 0
			onUpdate: @fill.update
			ease: Elastic.easeOut
		}

		return

module.exports = BtnView