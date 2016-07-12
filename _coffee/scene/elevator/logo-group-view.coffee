require 'extension'
Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
# エレベーターシーンで使用するためのロゴグループクラス
# @param {Object} btn: ボタン
# @param {Object} base: 土台
# 
class LogoGroupView extends paper.Group
	constructor: (btn, base) ->
		@sceneConfig = Config.Elevator
		@btn = btn
		@base = base
		super [btn, base]

		Utils.transformInit @
		

	# 
	# アクティブシーン終了時
	# 
	end:->
		@position.y = 0
		return

	# 
	# 下がる
	# @param {Object} 完了を返す
	# 
	goDown: =>
		df = $.Deferred()

		# SE 動く落ち
		_se = Utils.getSE @seList.SE2
		SoundManager.play _se, 0, true
		
		_height = PaperStage.instance.height

		_height = PaperStage.instance.height
		_startY = -120
		_endY = 120

		position = @position
		tl = new TimelineMax({
			onComplete: =>
				df.resolve()
				# SE Stop
				SoundManager.stop _se
		})
		tl.to position, .7, {
			y: _endY
			ease: Cubic.easeIn
			onComplete: => position.y = _startY
		}
		tl.to position, .6, {
			y: _endY
			repeat: 1
			onComplete: => position.y = _startY
		}
		tl.to position, .7, {
			y: 0
			ease: Cubic.easeOut
			onStart: => @btn.fill.fillColor = Config.COLOR.BTN_FILL
		}

		return df.promise()

module.exports = LogoGroupView