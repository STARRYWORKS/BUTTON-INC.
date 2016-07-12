LogoType = require 'logo-type'
PaperStage = require 'paper-stage'

# 
# ロケットシーンで使用するためのロゴグループクラス
# 
class LogoTypeView extends LogoType
	#
	# イニシャライズ
	#
	_onInit: ->
		return

	# 
	# アクティブシーン終了時
	# 
	end:->
		@position.y = 0
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


module.exports = LogoTypeView