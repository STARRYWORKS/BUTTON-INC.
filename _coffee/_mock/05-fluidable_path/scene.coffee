require 'extension'
Config				= require 'config'
Utils					= require 'utils'
SceneBase			= require 'scene-base'
CustomStroke	= require 'custom-stroke'
FluidablePath	= require 'fluidable-path'

# 
# プリンシーンクラス
# 
class Scene extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->


		# ベース
		@baseSVG = @importSVG Config.SVG.BASE
		@baseSVG.remove()

		# 骨格の線
		@bone = @baseSVG.children[1]
		@bone.strokeWidth = 0.25
		@bone.strokeColor = '#ff0000'
		@bone.fillColor = new paper.Color 0,0,0,0
		@container.addChild @bone

		@fluid = new FluidablePath @bone
		@fluid.strokeWidth = 0.25
		@fluid.strokeColor = '#0000ff'
		@fluid.fillColor = new paper.Color 0,0,0,0
		@container.addChild @fluid
		@fluid.selected = true
		@fluid.fullySelected = true


		@scale(4)

		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@container.position.x = 0
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@removeChildren()
		return

	#
	# 更新時
	#
	_onUpdate: ->
		@fluid.update()
		return

	# 
	# スタンバイ時
	# 
	_onStandby: ->
		return

	#
	# エフェクト
	#
	_onEffect: ->
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		return

module.exports = Scene