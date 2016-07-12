Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'

BASE = 0
STRETCH = 1
PULL = 2
PRESS = 3
DRIP_BEFORE = 4
DRIP_AFTER = 5
# 
# プリンシーンで使用するためのプリンビュークラス
# 
class PuddingView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Pudding
		@morph = 0
		# ベース
		base = Utils.getSvgChild @sceneConfig.SVG.Base, 0
		baseStretch = Utils.getSvgChild @sceneConfig.SVG.Stretch, 0
		basePull = Utils.getSvgChild @sceneConfig.SVG.Pull, 0
		basePress = Utils.getSvgChild @sceneConfig.SVG.Press, 0
		baseDripBefore = Utils.getSvgChild @sceneConfig.SVG.Stretch, 0
		baseDripAfter = Utils.getSvgChild @sceneConfig.SVG.Drip, 0
		@base = new MorphablePath [base, baseStretch, basePull, basePress, baseDripBefore, baseDripAfter]
		@base.fillColor = @sceneConfig.COLOR.BASE

		# キャラメル
		caramel = Utils.getSvgChild @sceneConfig.SVG.Base, 1
		caramelStretch = Utils.getSvgChild @sceneConfig.SVG.Stretch, 1
		caramelPull = Utils.getSvgChild @sceneConfig.SVG.Pull, 1
		caramelPress = Utils.getSvgChild @sceneConfig.SVG.Press, 1
		caramelDripBefore = Utils.getSvgChild @sceneConfig.SVG.Stretch, 1
		caramelDripAfter = Utils.getSvgChild @sceneConfig.SVG.Drip, 1
		@caramel = new MorphablePath [caramel, caramelStretch, caramelPull, caramelPress, caramelDripBefore, caramelDripAfter]
		@caramel.fillColor = @sceneConfig.COLOR.CARAMEL

		Utils.transformInit @
		@addChildren [@base, @caramel]
		@position.y = 20
		@visible = false

	# 
	# 非アクティブシーンになる時
	# 
	end: ->
		@position.y = 20
		@visible = false
		@morph = 0
		@update()
		return

	# 
	# 塗りの部分が落ちて揺れるアニメーション
	# @returns {Object}: 完了を返す
	# 
	fall: ->
		df = new $.Deferred
		@opacity = 0
		@visible = true

		# 落ちる
		TweenMax.to @position, .6, {
			y: 80
			ease: Elastic.easeOut
		}

		# モーフィング
		tl = new TimelineMax({
			onComplete: df.resolve
		})
		tl.to @, .12, {
			morph: STRETCH
			opacity: 1
			onUpdate: @update
			ease: Sine.easeOut
		}

		tl.to @, .1, {
			morph: PRESS
			onUpdate: @update
			ease: Sine.easeIn
		}

		tl.to @, .1, {
			morph: PULL
			onUpdate: @update
			ease: Sine.easeOut
		}

		tl.to @, .1, {
			morph: STRETCH
			onUpdate: @update
			ease: Sine.easeOut
		}

		return df.promise()

	# 
	# 垂れる
	# 
	drip: =>
		df = new $.Deferred()
		@update DRIP_BEFORE
		TweenMax.to @, 1, {
			morph: DRIP_AFTER - .5
			ease: Sine.easeInOut
			onUpdate: @update
		}
		setTimeout df.resolve, 550
		return df.promise()

	# 
	# アップデート
	# 
	update: (morph = @morph)=>
		@morph = morph
		@base.update @morph
		@caramel.update @morph
		return

module.exports = PuddingView