Config				= require './config'
Utils					= require 'utils'
Btn						= require 'btn'
# 
# ボタンビュー
# 
class BtnView extends Btn
	# 
	# 下がる
	# 
	down: ->
		TweenMax.to @position, .175, {
			y: 20
			ease: Expo.easeOut
		}

		TweenMax.to @, .1, {
			morph: 1.75
			delay: .05
			ease: Expo.easeOut
			onUpdate: =>
				@fill.update @morph
				@stroke.update @morph
		}
		return

	# 
	# 上がる
	# @param {Boolean} hit: クリック範囲内かどうか
	# 
	up: (hit)->
		TweenMax.to @position, .1, {
			y: 0
			ease: Expo.easeIn
		}

		TweenMax.to @, .1, {
			morph: 1
			delay: .05
			ease: Expo.easeIn
			onUpdate: =>
				@fill.update @morph
				@stroke.update @morph
		}

		if hit
			setTimeout ->
				location.href = "/"
			, 300

		return


module.exports = BtnView