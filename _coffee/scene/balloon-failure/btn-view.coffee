Config				= require 'config'
Utils					= require 'utils'
Btn						= require 'btn'
MorphablePath	= require 'morphable-path'
PaperStage		= require 'paper-stage'
INFRED = 3
# 
# 風船で使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.BalloonFailure
		@soft = 1
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		return

	# 
	# 膨らむ
	# 
	infred: ->
		df = new $.Deferred()

		TweenMax.to @position, 0.2, {
			y: 0
			ease: Circ.easeOut
		}
		TweenMax.to @, 1.1, {
			morph: INFRED
			ease: Circ.easeOut
			delay: 0.1
			onComplete: df.resolve
		}
		return df.promise()

	# 
	# 膨張（爆発寸前）
	# 
	expansion: =>
		TweenMax.to @, .10, {
			morph: INFRED + .05
			ease: Sine.easeIn
			onComplete: => @visible = false
		}
		return

	# 
	# はえてくる
	# 
	grow: =>
		df = new $.Deferred()
		@morph = 1
		@position.set 0, 22
		TweenMax.to @position, .4, {
			delay: .3
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