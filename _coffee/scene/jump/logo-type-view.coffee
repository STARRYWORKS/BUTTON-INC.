require 'extension'
LogoType = require 'logo-type'

# 
# ジャンプシーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	#
	# イニシャライズ
	#
	_onInit: ->
		@baseHeight = []
		for child in @children
			@baseHeight.push child.bounds.height
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@press = 0
		for child, i in @children
			child.matrix = new paper.Matrix()
			child.scale(1,1)
			child.position.y = child.position.y + ((@baseHeight[i] - child.bounds.height) / 2)
		return

	#
	# 更新時
	#
	_onUpdate: ->
		# ボタン押された時に平体をかける
		press = @press / 2
		if press < 0 then press = 0
		if press > 1 then press = 1

		@scaleRatio = 1 - TWEEN.Easing.Sine.In(press) * 0.03 - press * 0.05
		@setChildrensScaleY(@scaleRatio)
		return


	# 
	# 平体から通常状態に戻すアニメーション
	# 
	effect: ->
		bound = []
		@scaleRatio *= 0.2
		@setChildrensScaleY(@scaleRatio)
		diffScale = 1 - @scaleRatio

		new TWEEN.Tween null
			.to null, 600
			.easing TWEEN.Easing.Elastic.Out
			.onUpdate (v)=>
				@setChildrensScaleY(@scaleRatio + (diffScale * v))
			.start()

		return

	#
	# 平体
	#
	setChildrensScaleY: (scale) ->
		for child, i in @children
			child.matrix = new paper.Matrix()
			child.scale 1, scale
			child.position.y = child.position.y + ((@baseHeight[i] - child.bounds.height) / 2)

	
module.exports = LogoTypeView