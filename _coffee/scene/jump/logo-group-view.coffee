require 'extension'

# 
# ジャンプシーンで使用するためのロゴグループクラス
# @param {Object} btn: ボタン
# @param {Object} base: 土台
# 
class LogoGroupView extends paper.Group
	constructor: (btn, base) ->
		@btn = btn
		@base = base
		super [btn, base]

		@transformContent = false
		@pivot = new paper.Point(0,0)

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@matrix = new paper.Matrix()
		@position.set(0, 0)
		@rotate 0
		@scale 1
		return


	# 
	# 飛んでくエフェクト
	# @param {Floor} press: 押された量
	# @param {Object} vector: 引っ張った移動量
	# @returns {Object}: 完了を返す
	# 
	effect: (press, vector)->
		df = new $.Deferred()
		
		@press = press
		
		# 引っ張った角度に180足して反対の方向に
		angle = vector.angle + 180
		
		# -180 〜 180の範囲に
		if angle < -180 then angle += 360
		else if angle > 180 then angle -= 360

		# 45度より水平にしない
		if angle < -135 then angle = -135
		else if angle > -45 then angle = -45

		# ジャンプの最高到達点
		topVector = new paper.Point({
			length: 175 # 距離は一定で
			angle: angle
		})

		# ジャンプの下降到達点
		downVector = new paper.Point({
			length: 200 # 距離は一定で
			angle: angle
		})
		downVector.y -= (downVector.y - topVector.y) * 2.5

		# トゥイーン用のダミーオブジェクト
		dummy = {
			scale: 1
			angle: 0
			x: @position.x
			y: @position.y
		}

		# Y座標のトゥイーン
		yTl = new TimelineMax()
		yTl.to dummy, .2, {　y:topVector.y, ease: Cubic.easeOut }
		yTl.to dummy, .3, { y:downVector.y, ease: Cubic.easeIn }

		# 角度のトゥイーン
		TweenMax.to dummy, .5, {
			angle: (angle + 90) * 1.5
			ease: Sine.easeInOut
		}

		# スケールとX座標のトゥイーン
		TweenMax.to dummy, .5, {
			scale: 0
			x: downVector.x
			ease: Sine.easeOut
			onComplete: df.resolve
			onUpdate: (v) =>
				@matrix.reset()
				@scale dummy.scale
				@rotate dummy.angle
				@position.x = dummy.x
				@position.y = dummy.y				
		}

		return df.promise()


module.exports = LogoGroupView