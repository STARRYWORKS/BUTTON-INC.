Config	= require 'config'
Utils		= require 'utils'

# 
# 風船で使用するための爆発効果クラス
# 
class BangView extends paper.Group
	constructor: ->
		super()
		@sceneConfig = Config.BalloonFailure
		@bang = @importSVG @sceneConfig.SVG.Bang
		Utils.transformInit @bang
		@visible = false

	# 
	# 非アクティブシーンになる時
	# 
	end: ->
		@visible = false
		return

	# 
	# 
	# 
	show: =>
		df = new $.Deferred()
		@scaling.set .25, .25
		tl = new TimelineMax {
			onComplete: df.resolve
		}

		scaling = @scaling
		tl.to scaling, .1, {
			x: 1.5
			y: 1.5
			delay: .1
			ease: Elastic.easeOut
			onStart: => @visible = true
		}
		tl.to scaling, .05, {
			x: .5
			y: .5
			ease: Expo.easeOut
			onComplete: => @visible = false
		}
		return df.promise()

module.exports = BangView