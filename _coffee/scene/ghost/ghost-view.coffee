require 'extension'
Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
MorphablePath	= require 'morphable-path'
SoundManager	= require 'sound-manager'

EYES = 3
LEFT_EYE = 2
RIGHT_EYE = 3

# 
# おばけシーンで使用するためのボタンクラス
# 
class GhostView extends paper.Group
	constructor: ->
		super()
		@sceneConfig = Config.Ghost
		@tweenArr = []

		Utils.transformInit @ # 起点設定

		# 体
		@body = new paper.Group()
		@body.opacity = 0
		@body.visible = false
		@addChild @body
		Utils.transformInit @body

		# SVGインポート
		body1 = Utils.getSvgChild @sceneConfig.SVG.Ghost1, -1
		body2 = Utils.getSvgChild @sceneConfig.SVG.Ghost2, -1
		body3 = Utils.getSvgChild @sceneConfig.SVG.Ghost3, -1

		# @body1 = new paper.Group()
		# @body2 = new paper.Group()
		# @body3 = new paper.Group()
		# @body2.visible = false
		# @body3.visible = false
		# @body.addChildren [@body1, @body2, @body3]
		# Utils.transformInit [@body1, @body2, @body3]

		# モーフィング設定
		for path,i in body1
			_body = new MorphablePath [path, body2[i], body3[i]]
			_body.strokeCap = 'round'
			_body.strokeWidth = Config.LINE_WIDTH
			_body.strokeColor = @sceneConfig.COLOR.STROKE
			_body.fillColor = @sceneConfig.COLOR.FILL
			if i == 3 || i == 4 then _body.strokeWidth = 4
			if i == 5 || i == 6 then _body.strokeWidth = 5.6

			# path.strokeCap = 'round'
			# path.strokeWidth = Config.LINE_WIDTH
			# path.strokeColor = @sceneConfig.COLOR.STROKE
			# path.fillColor = @sceneConfig.COLOR.FILL
			# if i == 3 || i == 4 then path.strokeWidth = 4
			# if i == 5 || i == 6 then path.strokeWidth = 5.6
			
			# body2[i].strokeCap = 'round'
			# body2[i].strokeWidth = Config.LINE_WIDTH
			# body2[i].strokeColor = @sceneConfig.COLOR.STROKE
			# body2[i].fillColor = @sceneConfig.COLOR.FILL
			# if i == 3 || i == 4 then body2[i].strokeWidth = 4
			# if i == 5 || i == 6 then body2[i].strokeWidth = 5.6

			# body3[i].strokeCap = 'round'
			# body3[i].strokeWidth = Config.LINE_WIDTH
			# body3[i].strokeColor = @sceneConfig.COLOR.STROKE
			# body3[i].fillColor = @sceneConfig.COLOR.FILL
			# if i == 3 || i == 4 then body3[i].strokeWidth = 4
			# if i == 5 || i == 6 then body3[i].strokeWidth = 5.6

			# 体のモーフィングtweenの設定
			@body.addChild _body

		# @body1.addChildren body1
		# @body2.addChildren body2
		# @body3.addChildren body3

		# 目
		@eye = @importSVG @sceneConfig.SVG.Eye
		@eye.opacity = 0
		@eye.visible = false
		Utils.transformInit @eye

		for eye in @eye.children
			Utils.transformInit eye
			eye.basePos = eye.position


	# 
	# アクティブシーン終了時
	# 
	end: ->
		@opacity = 1
		@position.set 0, 0
		@scaling.set 1, 1

		@body.opacity = 0
		@body.visible = false
		
		# clearInterval @timeID
		
		@eye.visible = false
		@eye.opacity = 0

		$.each @body.children, (i, _body) =>
			@tweenArr[i]?.kill()
			_body.morph = 0
			_body.update _body.morph

		return

	# 
	# 目表示
	# @returns {Object} 完了を返す
	# 
	eyeShow: (duration = 0)->
		df = new $.Deferred()

		@eye.visible = true
		leftEye = @eye.children[LEFT_EYE].position
		rightEye = @eye.children[RIGHT_EYE].position
		tlRgiht = new TimelineMax()
		tlLeft = new TimelineMax({
			onComplete: df.resolve
		})

		# 表示
		duration = duration / 1000
		TweenMax.to @eye, duration, {
			opacity: 1
			ease: Quint.easeInOut
		}

		# きょろきょろ 左
		tlLeft.to leftEye, 0.2, {
			x: leftEye.x + 8
			delay: duration
			ease: Quint.easeInOut
		}
		tlLeft.to leftEye, 0.2, {
			x: leftEye.x
			ease: Quint.easeInOut
		}
		
		# 右
		tlRgiht.to rightEye, 0.2, {
			x: rightEye.x + 8
			delay: duration
			ease: Quint.easeInOut
		}
		tlRgiht.to rightEye, 0.2, {
			x: rightEye.x
			ease: Quint.easeInOut
		}
		
		return df.promise()

	# 
	# 全体表示
	# 
	allShow: (duration = 0)->
		duration = duration / 1000
		df = new $.Deferred()

		@body.visible = true

		TweenMax.to @body, duration, {
			opacity: 1
			ease: Quint.easeInOut
			onComplete: df.resolve
		}

		return df.promise()

	# 
	# 飛んで行く
	# 
	floating: =>
		df = new $.Deferred()

		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE2
		SoundManager.play _se, 0, true

		
		# _i = 1
		# @eye.visible = false
		# @timeID = setInterval =>
		# 	@body1.visible = false
		# 	@body2.visible = false
		# 	@body3.visible = false
		# 	if _i % 3 == 0 then @body1.visible = true
		# 	if _i % 3 == 1 then @body2.visible = true
		# 	if _i % 3 == 2 then @body3.visible = true
		# 	_i += 1
		# , 130

		#
		position = @position
		tl = new TimelineMax({
			onComplete: ()->
				df.resolve()
				SoundManager.stop _se, 300
		})

		tl.to position, 1.25, {
			x: -60,
			y: -60
			ease: Sine.easeInOut
			onStart: @bodyMorphingTween
			onComplete: =>
				@scaling.set -1, 1
		}

		tl.to position, 1.25, {
			x: 60,
			y: -120
			onStart: @bodyMorphingTween
			ease: Sine.easeInOut
		}

		TweenMax.to @, 1.0, {
			opacity: 0
			delay: 1.5
			ease: Sine.easeIn
		}
		
		return df.promise()

	# 
	# 
	# 
	bodyMorphingTween: =>
		$.each @body.children, (i, _body) =>
			@tweenArr[i]?.kill()
			_body.morph = 0
			_body.update _body.morph

			tween = TweenMax.to _body, 1.5, {
				morph: 2
				onUpdate: _body.update
				ease: Sine.easeInOut
			}
			if @tweenArr[i]?
				@tweenArr[i] = tween
			else
				@tweenArr.push tween

module.exports = GhostView