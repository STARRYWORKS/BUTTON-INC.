Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'
SoundManager	= require 'sound-manager'

# 
# つぶれるシーンで使用する潰れたボタンクラス
# 
class BtnSquashView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Squash

		@before = Utils.getSvgChild @sceneConfig.SVG.Before, -1
		@halfway = Utils.getSvgChild @sceneConfig.SVG.Halfway, -1
		@after = Utils.getSvgChild @sceneConfig.SVG.After, -1

		# モーフィング設定
		@pathArr = []
		for path, i in @before
			@pathArr.push new MorphablePath([@before[i], @halfway[i], @after[i]])
			@pathArr[i].fillColor = Config.COLOR.BTN_FILL
			@pathArr[i].strokeColor = Config.COLOR.BTN_PATH
			@pathArr[i].strokeWidth = Config.LINE_WIDTH

		@addChildren @pathArr
		@visible = false

	# 
	# 非アクティブシーンになる時
	# 
	end: ->
		@visible = false
		@position.set 0, 0
		for path, i in @pathArr
			path.morph = 0
			path.update path.morph
		return

	# 
	# つぶれるアニメーション
	# @returns {Object}: 完了を返す
	# 
	effect: ->
		df = $.Deferred()
		@visible = true

		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE2
		SoundManager.play _se
		
		# Tween
		for path, i in @pathArr
			tl = new TimelineMax()

			tl.to path, .2, {
				morph: 1
				onUpdate: path.update
				ease: Expo.easeOut
			}
			tl.to path, .8 , {
				morph: 2
				delay: .2
				onUpdate: path.update
				ease: Cubic.easeIn
			}

		# 全体的に落とす
		@position.set 0, 0
		TweenMax.to @position, .8, {
			y: 10
			delay: .2
			ease: Cubic.easeIn
		}

		setTimeout df.resolve, 900
		return df.promise()

module.exports = BtnSquashView
