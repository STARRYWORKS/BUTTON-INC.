Base = require 'base'
PaperStage		= require 'paper-stage'
SHOT = 2

# 
# ロケットシーンで使用するための土台クラス
# 
class BaseView extends Base
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		return

	# 
	# エフェクト
	# 
	scroll: =>
		position = @position
		TweenMax.to position, 2.7, {
			y: PaperStage.instance.height * 0.7
			ease: Expo.easeIn
		}
		return

module.exports = BaseView