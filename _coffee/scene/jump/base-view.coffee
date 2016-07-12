Config	= require 'config'
Base		= require 'base'

# 
# ジャンプシーンで使用するための土台クラス
# 
class BaseView extends Base
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@morph = 0
		@reset()
		return
	# 
	# 少し下がる
	# 
	_onUpdate:->
		if @press < 1 then @press = 1
		else if @press > 2 then @press = 2
		@morph = @press - 1
		@boneStroke.update @morph
		@stroke.update()
		@fill.update @morph

		return
module.exports = BaseView