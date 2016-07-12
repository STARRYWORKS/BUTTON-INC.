require 'extension'
LogoType = require 'logo-type'
Config = require 'config'
Utils = require 'utils'

# 
# 落下シーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		# @pathes[2] # B
		# @pathes[3] # U
		# @pathes[4] # T
		# @pathes[5] # T
		# @pathes[0] # O
		# @pathes[1] # N
		# @pathes[6] # I
		# @pathes[9] # N
		# @pathes[7] # C
		# @pathes[8] # .
		@left = new paper.Group([@pathes[2], @pathes[3], @pathes[4], @pathes[5], @pathes[0]])
		@right = new paper.Group([@pathes[1], @pathes[6], @pathes[9], @pathes[7], @pathes[8]])
		Utils.transformInit [@left,@right]
		@addChildren [@left, @right]
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@left.position.x = 0
		@right.position.x = 0
		return

	# 
	# 
	# 
	effect: ->
		tlLeft = new TimelineMax()
		tlRight = new TimelineMax()
		_leftPosition = @left.position
		_rightPosition = @right.position

		# 左
		tlLeft.to _leftPosition, .2, {
			x: -100
			ease: Expo.easeOut
		}
		tlLeft.to _leftPosition, .3, {
			x: 0
			ease: Expo.easeIn
		}

		# 右
		tlRight.to _rightPosition, .2, {
			x: 100
			ease: Expo.easeOut
		}
		tlRight.to _rightPosition, .3, {
			x: 0
			ease: Expo.easeIn
		}
		return

module.exports = LogoTypeView