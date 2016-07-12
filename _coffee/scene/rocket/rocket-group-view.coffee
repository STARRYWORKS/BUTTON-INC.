require 'extension'
Config	= require 'config'
Utils		= require 'utils'

# 
# ロケットシーンで使用するためのロケットグループクラス
# @param {Object} btn: ボタン
# @param {Object} base: 土台
# @param {Object} fire: 炎
# 
class RocketGroupView extends paper.Group
	constructor: (btn, fire) ->
		@sceneConfig = Config.Rocket
		@btn = btn
		@fire = fire
		super [@btn, @fire]

		Utils.transformInit @

		@parts1 = @importSVG @sceneConfig.SVG.Parts1
		Utils.transformInit @parts1
		for parts in @parts1.children
			Utils.transformInit parts, false
			parts.visible = false

		@parts2 = @importSVG @sceneConfig.SVG.Parts2
		Utils.transformInit @parts2
		for parts in @parts2.children
			Utils.transformInit parts, false
			parts.visible = false

		@parts3 = @importSVG @sceneConfig.SVG.Parts3
		Utils.transformInit @parts3
		for parts in @parts3.children
			Utils.transformInit parts, false
			parts.visible = false

		@parts3.insertBelow @btn

	# 
	# アクティブシーン終了時
	# 
	end:->
		@position = new paper.Point 0, 0
		for parts in @parts1.children
			parts.scaling.set 1, 1
			parts.visible = false

		@position = new paper.Point 0, 0
		for parts in @parts2.children
			parts.scaling.set 1, 1
			parts.visible = false

		for parts in @parts3.children
			parts.scaling.set 1, 1
			parts.visible = false
		return

	change: ->
		_delay = .5

		for parts, i in @parts1.children
			parts.scaling.set 0.01, 0.01
			parts.visible = true
			_ease = if i == 0 then Back.easeOut else Expo.easeOut
			TweenMax.to parts.scaling, .25, {
				x: 1
				y: 1
				ease: _ease
			}

		for parts, i in @parts2.children
			parts.scaling.set 0.01, 0.01
			parts.visible = true
			_ease = if i == 0 then Back.easeOut else Expo.easeOut
			TweenMax.to parts.scaling, .25, {
				x: 1
				y: 1
				ease: _ease
				delay: _delay
			}

		for parts, i in @parts3.children
			parts.scaling.set 0.01, 0.01
			parts.visible = true
			TweenMax.to parts.scaling, .25, {
				x: 1
				y: 1
				ease: Back.easeOut
				delay: _delay + .5
			}
		return

	# 
	# エフェクト
	# @returns {Object} 完了を返す
	# 
	goOut: =>
		df = new $.Deferred()
		position = @position
		tl = new TimelineMax()
		# 発射時の横揺れ
		tl.to position, 0.1, {x: 3, ease: Expo.easeInOut}
		.to position, 0.1, {x: -3, ease: Expo.easeInOut}
		.to position, 0.1, {x: 3, ease: Expo.easeInOut}
		.to position, 0.1, {x: -3, ease: Expo.easeInOut}
		.to position, 0.1, {x: 3, ease: Expo.easeInOut}
		.to position, 0.1, {x: -3, ease: Expo.easeInOut}
		.to position, 0.09, {x: 3, ease: Expo.easeInOut}
		.to position, 0.09, {x: -3, ease: Expo.easeInOut}
		.to position, 0.09, {x: 3, ease: Expo.easeInOut}
		.to position, 0.09, {x: -3, ease: Expo.easeInOut}
		.to position, 0.09, {x: 3, ease: Expo.easeInOut}
		.to position, 0.09, {x: -3, ease: Expo.easeInOut}
		.to position, 0.09, {x: 2, ease: Expo.easeInOut}
		.to position, 0.09, {x: -2, ease: Expo.easeInOut}
		.to position, 0.09, {x: 2, ease: Expo.easeInOut}
		.to position, 0.09, {x: -2, ease: Expo.easeInOut}
		.to position, 0.09, {x: 2, ease: Expo.easeInOut}
		.to position, 0.09, {x: -2, ease: Expo.easeInOut}
		.to position, 0.09, {x: 1, ease: Expo.easeInOut}
		.to position, 0.09, {x: -1, ease: Expo.easeInOut}
		.to position, 0.09, {x: 1, ease: Expo.easeInOut}
		.to position, 0.09, {x: -1, ease: Expo.easeInOut}
		.to position, 0.09, {x: 1, ease: Expo.easeInOut}
		.to position, 0.09, {x: -1, ease: Expo.easeInOut}
		.to position, 0.09, {x: 1, ease: Expo.easeInOut}
		.to position, 0.09, {x: 0, ease: Expo.easeInOut}
		
		# 背景スクロール最後のほうで飛んで行く
		TweenMax.to position, 1.0, {
			y: $(window).height() * -1
			delay: 3
			onComplete: df.resolve
		}
		return df.promise()

module.exports = RocketGroupView