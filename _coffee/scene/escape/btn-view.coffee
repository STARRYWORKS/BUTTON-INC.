Config	= require 'config'
Btn			= require 'btn'

CENTER	= 'center'
LEFT		= 'left'
RIGHT		= 'right'

# 
# 避けるシーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# リセット
	# 
	end: ->
		@reset 1
		return

	# 
	# シーン切替時
	# 
	swap: ->
		TweenMax.to @, .1, {
			morph: 1
			ease: Expo.easeIn
			delay: .23
		}

		TweenMax.to @position, .1, {
			y: 10
			ease: Expo.easeIn
			delay: .15
		}
		return

	# 
	# モーフィングアップデート
	# 
	morphingUpdate: (morph = @morph)=>
		@morph = morph
		if @_morph == @morph then return
		@stroke.update @morph
		@fill.update @morph
		@_morph = @morph
		return

module.exports = BtnView