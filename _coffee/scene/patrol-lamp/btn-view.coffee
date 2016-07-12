Btn			= require 'btn'
Config	= require 'config'
Utils		= require 'utils'
# 
# パトランプシーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 
	# 
	_onInit: ->
		@sceneConfig = Config.PatrolLamp
		return
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		return

	# 
	# パトランプ化
	# 
	change: =>
		df = new $.Deferred()
		
		# Tween
		@fill.fillColor = @sceneConfig.COLOR.BTN
		TweenMax.to @position, .1, {
			y:0
			ease: Back.easeOut
		}
		TweenMax.to @, .1, {
			morph: 1
			ease: Back.easeOut
			onUpdate: @morphingUpdate
			onComplete: df.resolve
		}
		return df.promise()
	# 
	# 非表示
	# 
	hide: =>
		@visible = false
		return

	# 
	# はえてくる
	# 
	grow: =>
		df = new $.Deferred()
		@morph = 1
		@morphingUpdate()
		@position.set 0, 22
		TweenMax.to @position, .5, {
			delay: .2
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