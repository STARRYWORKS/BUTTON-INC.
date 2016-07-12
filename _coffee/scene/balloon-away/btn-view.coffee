Config				= require 'config'
Utils					= require 'utils'
Btn						= require 'btn'
MorphablePath	= require 'morphable-path'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'
INFRED = 3
# 
# 風船で使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.BalloonAway
		@soft = 1
		handle1 = Utils.getSvgChild @sceneConfig.SVG.Handle1, -1
		handle2 = Utils.getSvgChild @sceneConfig.SVG.Handle2, -1
		handle3 = Utils.getSvgChild @sceneConfig.SVG.Handle3, -1
		handle4 = Utils.getSvgChild @sceneConfig.SVG.Handle4, -1
		@handle = new paper.Group()
		Utils.transformInit @handle
		@insertChild 0, @handle
		@handle.visible = false

		for path, i in handle1
			_handle = new MorphablePath [path, handle2[i], handle3[i], handle4[i]]
			_handle.strokeWidth = Config.LINE_WIDTH
			_handle.strokeColor = Config.COLOR.BTN_PATH
			_handle.strokeCap = 'round'
			if i == 1 then _handle.fillColor = Config.COLOR.BTN_FILL
			@handle.addChild _handle

		@handleTween = []
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		@handle.visible = false
		for tween in @handleTween
			tween.pause()
		return

	# 
	# 膨らむ
	# 
	infred: ->
		df = new $.Deferred()

		TweenMax.to @position, .2, {
			y: 0
			ease: Circ.easeOut
		}
		TweenMax.to @, .5, {
			morph: INFRED
			delay: .1
			ease: Back.easeOut
			onComplete: df.resolve
		}
		return df.promise()

	# 
	# 飛んで行く
	# 
	away: =>
		df = $.Deferred()

		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE2
		SoundManager.play _se

		@handle.visible = true

		if @handleTween.length > 0
			for tween in @handleTween
				tween.play()
		else
			for path in @handle.children
				tween = TweenMax.to path, 4, {
					morph: 3
					onUpdate: path.update
					repeat: -1
					yoyo: true
				}
				tween.play()
				@handleTween.push tween

		position = @position
		startedTime = new Date().getTime()
		TweenMax.to position, 1.5, {
			y: PaperStage.instance.height / -2 - (@bounds.height / 2)
			ease: Sine.easeIn
			onUpdate: =>
				time = new Date().getTime() - startedTime
				@position.x = Math.sin(time * 0.0035 ) * 30 * (time/3000)
			onComplete: df.resolve
		}
		
		return df.promise()
	# 
	# はえてくる
	# 
	grow: =>
		df = new $.Deferred()
		@handle.visible = false
		@morph = 1
		@morphingUpdate()
		@position.set 0, 22
		TweenMax.to @position, .4, {
			y: 0
			ease: Expo.easeOut
			onComplete: df.resolve
			onStart: => @visible = true

		}
		return df.promise()

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