require 'extension'
Btn					= require 'btn'
Config			= require 'config'
PaperStage	= require 'paper-stage'
# 
# 落下シーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# アップデート歪みを戻す
	# 
	morphing: ->
		@fill.update 1
		@stroke.update 1
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		return

	# 
	# エフェクト
	# @returns {Object} 完了を返す
	# 
	effect: ->
		_y = PaperStage.instance.height * 0.7

		# 落ちる
		TweenMax.to @position, 0.25, {
			y: _y
		}
		return

module.exports = BtnView