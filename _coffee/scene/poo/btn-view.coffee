require 'extension'
Btn						= require 'btn'
Config				= require 'config'
Utils					= require 'utils'
Config				= require 'config'
PaperStage		= require 'paper-stage'
MorphablePath	= require 'morphable-path'

# 
# 落下シーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Poo
		poo1 = Utils.getSvgChild @sceneConfig.SVG.Poo1, -1
		poo2 = Utils.getSvgChild @sceneConfig.SVG.Poo2, -1
		poo3 = Utils.getSvgChild @sceneConfig.SVG.Poo1, -1
		poo4 = Utils.getSvgChild @sceneConfig.SVG.Poo3, -1
		poo5 = Utils.getSvgChild @sceneConfig.SVG.Poo4, -1
		poo6 = Utils.getSvgChild @sceneConfig.SVG.Poo5, -1

		@poo = new paper.Group()
		@addChild @poo
		@poo.visible = false
		Utils.transformInit @poo

		for path, i in poo1
			poo = new MorphablePath [path, poo2[i], poo3[i], poo4[i], poo5[i], poo6[i]]
			poo.strokeCap = 'round'
			poo.strokeWidth = Config.LINE_WIDTH
			poo.strokeColor = Config.COLOR.BTN_PATH
			poo.fillColor = Config.COLOR.BTN_FILL
			@poo.addChild poo
		
		return
	
	# 
	# アクティブシーン終了時
	# 
	end: ->
		@poo.visible = false
		for path in @poo.children
			path.morph = 0
			path.update path.morph

		@reset()
		return

	# 
	# エフェクト
	# @returns {Object} 完了を返す
	# 
	effect: ->
		df = new $.Deferred()
		# 落ちる
		@position.y = 60
		TweenMax.to @position, .1, {
			y: 120
		}

		for path in @poo.children
			tl = new TimelineMax()
			tl.to path, .1, {
				morph: 1
				onUpdate: path.update
				ease: Expo.easeOut
			}
			tl.to path, .5, {
				morph: 5
				onUpdate: path.update
				ease: Sine.easeOut
			}


		setTimeout ()=>
			@poo.visible = true
			@fill.visible = false
			@stroke.visible = false
		, 30

		setTimeout df.resolve, 550
		return df.promise()

module.exports = BtnView