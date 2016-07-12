Config	= require 'config'
Base			= require 'base'

CENTER	= 'center'
LEFT		= 'left'
RIGHT		= 'right'

# 
# 避けるシーンで使用するための土台クラス
# 
class BaseView extends Base
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
		return

	# 
	# モーフィングアップデート
	# 
	morphingUpdate: (morph = @morph)=>
		@morph = morph
		if @_morph == @morph then return
		@boneStroke.update @morph
		@stroke.update()
		@fill.update @morph
		@_morph = @morph
		return

module.exports = BaseView