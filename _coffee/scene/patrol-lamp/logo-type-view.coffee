require 'extension'
Config				= require 'config'
Utils					= require 'utils'
LogoType			= require 'logo-type'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
# パトランプシーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@position.x = 0
		return

	# 
	# 移動
	# 
	move: =>
		# SE
		@sceneConfig = Config.PatrolLamp
		_se = Utils.getSE @sceneConfig.SOUND.SE2
		
		df = new $.Deferred()
		_x = ((PaperStage.instance.width / 2) + @bounds.width) * -1
		tl = new TimelineMax {
			onComplete: ->
				df.resolve()
				SoundManager.stop _se, 300
		}
		position = @position
		tl.to position, 1.5, {
			x: _x
			ease: Sine.easeIn
			onStart: -> SoundManager.play _se
			onComplete: => position.x = (PaperStage.instance.width / 2) + @bounds.width
		}
		tl.to position, 1, {
			x: 0
			ease: Sine.easeOut
		}
		return df.promise()

module.exports = LogoTypeView