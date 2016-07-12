require 'extension'
Config				= require 'config'
Utils					= require 'utils'
SoundManager	= require 'sound-manager'

# 
# UFOシーンで使用するためのロゴグループクラス
# @param {Object} btn: ボタン
# @param {Object} parts: 土台
# 
class UfoView extends paper.Group
	constructor: (btn, parts, baseBg) ->
		@sceneConfig = Config.Ufo
		@btn = btn
		@parts = parts
		@baseBg = baseBg
		super [btn, baseBg, parts]

		Utils.transformInit @

		# UFOパーツ
		@circles = new paper.Group()
		Utils.transformInit @circles
		parts = Utils.getSvgChild @sceneConfig.SVG.Circle, -1
		
		@circles.addChildren parts
		for path in @circles.children
			Utils.transformInit path
		@partsInit()

		# 光線
		_line = Utils.getSvgChild @sceneConfig.SVG.Line, -1
		@line = new paper.Group _line
		Utils.transformInit @line
		for child in @line.children
			Utils.transformInit child
		@lineInit()

		# UFOパーツ
		@insertChild 0, @circles

		# 光線
		@addChild @line

	# 
	# パーツイニシャライズ
	# 
	partsInit: ->
		for path, i in @circles.children
			path.strokeWidth = 0
			path.fillColor = Config.COLOR.BTN_FILL
			path.strokeWidth = Config.LINE_WIDTH
			path.strokeColor = Config.COLOR.BTN_PATH
			path.visible = false

		return

	# 
	# 光線イニシャライズ
	# 
	lineInit: ->
		for child,i in @line.children
			child.strokeWidth = Config.LINE_WIDTH
			child.strokeColor = Config.COLOR.BTN_PATH
			_length = child.length
			child.dashArray = [_length , _length]
			child.dashOffset = _length
		return


	# 
	# アクティブシーン終了時
	# 
	end:->
		@matrix = new paper.Matrix()
		@scaling.set 1, 1
		@position = new paper.Point 0, 0
		@partsInit()
		@lineInit()
		# @parts.visible = false
		@baseBg.visible = true
		return

	# 
	# 背景用土台非表示
	# 
	baseBgHide: ->
		@baseBg.visible = false
		return
		
	# 
	# UFOに変形（下の丸部分）
	# 
	change: =>
		$.each @circles.children, ()->
			path = @
			path.position.y = -20
			# 線を描く
			TweenMax.to path.position, .25, {
				y: 0
				delay: .2
				onStart: => path.visible = true
			}
		return

	# 
	# 浮く
	# 
	fly: =>
		df = new $.Deferred()
		position = @position
		@flyPosition = -25

		# 飛び立つ
		TweenMax.to position, .75, {
			y: @flyPosition
			ease: Cubic.easeOut
			onComplete: df.resolve
		}

		# 文字拐う時の光線
		for path in @line.children
			TweenMax.to path, .4, {
				dashOffset: path.length * 0.5
				repeat: -1
				yoyo: true
				ease: Sine.easeOut
				delay: .8
			}

			# tl = new TimelineMax({
			# 	repeat: -1
			# 	delay: .8
			# })

			# tl.to path, .6, {
			# 	dashOffset: 0
			# 	ease: Expo.easeOut
			# }
			# tl.to path, .6, {
			# 	dashOffset: path.length * 0.3
			# 	ease: Expo.easeIn
			# }
			
		return df.promise()

	# 
	# エフェクト
	# @returns {Object} 完了を返す
	# 
	float: =>
		df = new $.Deferred()
		position = @position
		scaling = @scaling
		tl = new TimelineMax()

		# ふわふわさせる
		tl.to position, 0.6, {
			y: @flyPosition + 5
			ease: Linear.easeNone
		}
		.to position, 0.6, {
			y: @flyPosition - 5
			ease: Linear.easeNone
		}
		.to position, 0.6, {
			y: @flyPosition + 5
			ease: Linear.easeNone
		}
		.to position, 0.6, {
			y: @flyPosition - 5
			ease: Linear.easeNone
			onComplete: => 
				# SE
				_se = Utils.getSE @sceneConfig.SOUND.SE3
				SoundManager.play _se
		}

		# 光線消す
		for path, i in @line.children
			TweenMax.to path, .2, {
				dashOffset: path.length
				delay: 1.5
			}

		# 飛んで行く
		tl.to position, 0.15, {
			y: -60
			x: -100
			delay: .05
			ease: Cubic.easeInOut
		}
		.to position, 0.15, {
			y: -120
			x: -100
			delay: .05
			ease: Cubic.easeInOut
		}
		.to position, 0.15, {
			y: -60
			x: 100
			delay: .05
			ease: Cubic.easeInOut
		}
		.to position, 0.15, {
			y: -80
			x: 0
			delay: .05
			ease: Cubic.easeInOut
		}
		.to position, 0.3, {
			y: -150
			x: 100
			ease: Cubic.easeInOut
		}

		# 最後小さくなって消えていく
		TweenMax.to scaling, .4, {
			x: 0
			y: 0
			delay: 3.1
			onComplete: ->
				df.resolve()
				SoundManager.stop "ufo-se3", 300
		}

		return df.promise()

module.exports = UfoView