Config				= require 'config'
Utils					= require 'utils'
Btn						= require 'btn'
SoundManager	= require 'sound-manager'

# 
# UFOシーンで使用するためのボタンクラス
# 
class BtnView extends Btn

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		return

	# 
	# 変形
	# 
	change: ()->
		df = $.Deferred()

		# SE
		@sceneConfig = Config.Ufo
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se
		
		# Tween
		position = @position

		# 変形
		TweenMax.to @, .25, {
			morph: 3
			ease: Expo.easeOut
		}

		# ポジション
		TweenMax.to position, .25, {
			y: 0
			ease: Expo.easeOut
		}

		return df.resolve().promise()

	# 
	# モーフィングアップデート
	# 
	morphingUpdate: =>
		if @_morph == @morph then return
		@stroke.update @morph
		@fill.update @morph
		@_morph = @morph
		return

module.exports = BtnView