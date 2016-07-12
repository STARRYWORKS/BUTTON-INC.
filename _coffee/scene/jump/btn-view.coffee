Config	= require 'config'
Btn			= require 'btn'


# 
# ジャンプシーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# アップデート(上書き)
	# 
	update: (adjustment = 0)=>
		if @press < -1 then @press = -1
		else if @press > 2 then @press = 2

		press = @press * 0.75 + @pressOffset * 0.25
		
		# y座標
		y = press
		if y < 0 then y = 0
		else if y > 1 then y = 1

		# 押し加減調整
		y = y * (1 - @pressWeight)

		@position.y = TWEEN.Easing.Sinusoidal.InOut(y) * 20  + (2 * adjustment)
		
		if @press < 0
			@morph = @press + 1
			@stroke.update @morph
			@fill.update @morph

		else if @press > 1
			# 柔らかさ調整
			@morph = 1 + ((@press - 1) * @soft)
			@stroke.update @morph
			@fill.update @morph

		@_onUpdate()
		

module.exports = BtnView