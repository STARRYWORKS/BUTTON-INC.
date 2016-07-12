require 'extension'
Config				= require 'config'
Utils					= require 'utils'
SceneBase			= require 'scene-base'
CustomStroke	= require 'custom-stroke'

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
		@bone.selected = true
		@bone.fullySelected = true


		@answer = @bone.clone()
		@answer.strokeWidth = 5.5
		@answer.strokeColor = new paper.Color 0,0,0,0.05
		@answer.fillColor = new paper.Color 0,0,0,0
		@container.addChild @answer

		# custom stroke
		@stroke = new CustomStroke @bone, 5.5, [
			[0.5,		0.5]
			[0,			0]
			[2.75,	0]
			[2.75,	0]
			[0,			0]
			[0.5,		0.5]
		]
		@stroke.strokeWidth = 0
		@stroke.fillColor = new paper.Color 0,0,0,1
		@container.addChild @stroke
		@stroke.selected = true
		@stroke.fullySelected = true
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