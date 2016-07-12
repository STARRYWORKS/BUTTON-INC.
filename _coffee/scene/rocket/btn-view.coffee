Btn						= require 'btn'
Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'
SHOT = 1

# 
# ロケットシーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Rocket
		_before = Utils.getSvgChild @sceneConfig.SVG.Before
		_after = Utils.getSvgChild @sceneConfig.SVG.After
		@rocket = new MorphablePath [_before, _after], 0
		@rocket.strokeWidth = Config.LINE_WIDTH
		@rocket.strokeColor = Config.COLOR.BTN_PATH
		@rocket.fillColor = Config.COLOR.BTN_FILL
		@rocket.visible = false
		@addChild @rocket

		return
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@reset()
		@rocket.visible = false
		@rocket.update 0
		return

	# 
	# モーフィング
	# 
	change: =>
		@fill.visible = false
		@stroke.visible = false
		@rocket.visible = true
		TweenMax.to @rocket, .25, {
			morph: SHOT
			ease: Back.easeOut
			onUpdate: @rocket.update
		}
		
		return


module.exports = BtnView