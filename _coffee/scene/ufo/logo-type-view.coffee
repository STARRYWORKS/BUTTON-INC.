Config				= require 'config'
Utils					= require 'utils'
LogoType			= require 'logo-type'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
#  UFOシーンで使用するためのロゴグループクラス
# 
class LogoTypeView extends LogoType
	#
	# イニシャライズ
	#
	_onInit: ->
		for path, i in @pathes
			path.basePos = 
				x: path.position.x
				y: path.position.y
		return

	# 
	# アクティブシーン終了時
	# 
	end:->
		@opacity = 1
		for path, i in @pathes
			path.position.x = path.basePos.x
			path.position.y = path.basePos.y
		return

	# 
	# 文字が下がる
	# 
	fly: =>
		_y = @position.y + 75
		TweenMax.to @position, .75, {
			y: _y
			ease: Cubic.easeOut
		}

	# 
	# 文字がUFOに吸い込まれる
	# 
	suck: =>
		# SE
		@sceneConfig = Config.Ufo
		_se = Utils.getSE @sceneConfig.SOUND.SE2
		SoundManager.play _se

		# Tween
		_delay = 0
		for path, i in @pathes
			position = path.position

			tl = new TimelineMax()
			tl.to position, 0.15, {
				x : -5
				delay: _delay
				ease : Cubic.easeOut
			}
			tl.to position, 0.25, {
				y : -100
				ease : Cubic.easeIn
			}
			_delay += 0.1

		# 全部隠れたら非表示
		setTimeout ()=>
			@opacity = 0
			# SE
			SoundManager.stop _se
		, (_delay + 0.5) * 1000
		
		return

	#
	# 
	# 
	fall: =>
		df = $.Deferred()
		@position.y = 0
		@opacity = 1
		delay = .4
		$.each @pathes, (i, path)->
			path.position.x = path.basePos.x
			path.position.y = PaperStage.instance.height * -0.6
			delay += .020
			TweenMax.to path.position, .35, {
				y: path.basePos.y
				delay: delay
				ease: Bounce.easeOut
			}

		setTimeout df.resolve, (delay+0.1) * 1000

		return df.promise()

module.exports = LogoTypeView