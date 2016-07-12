Btn = require 'btn'
FluidablePath	= require 'fluidable-path'

# 
# つぶれるシーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 
	# 
	_onInit: ->
		@soft = 1
		@fluidStroke = new FluidablePath @stroke
		@fluidStroke.strokeWidth = @stroke.strokeWidth
		@fluidStroke.strokeColor = @stroke.strokeColor
		@fluidStroke.fillColor = @fill.fillColor
		@fluidStroke.speed = 0.015
		@fluidStroke.amplitude = 1

		@addChild @fluidStroke

		@stroke.remove()
		@fill.remove()
		return

	#
	#
	#
	_onUpdate: ->
		@fluidStroke.setPath @stroke
		flexibility = @press - 1
		if flexibility < 0 then flexibility = 0
		else if flexibility > 1 then flexibility = 1
		@fluidStroke.flexibility = flexibility

	# 
	# 表示
	# 
	show: ->
		@visible = true
		return

	# 
	# 非表示
	# 
	hide: ->
		@visible = false
		return

module.exports = BtnView