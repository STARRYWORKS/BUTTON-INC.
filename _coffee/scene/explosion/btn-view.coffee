Config				= require 'config'
Utils					= require 'utils'
Btn						= require 'btn'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

INFLATED = 3

# 
# 爆発シーンで使用するためのボタンクラス
# 
class BtnView extends Btn
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Explosion
		# 爆発
		@explosionGroup = new paper.Group()
		@explosionGroup.visible = false
		Utils.transformInit @explosionGroup

		_svg = @importSVG @sceneConfig.SVG.ExplosionBefore
		_svg.remove()
		@explosionGroup.addChildren _svg.children

		for path in @explosionGroup.children
			Utils.transformInit path, false
			path.savePos = path.position

		@addChild @explosionGroup
		
		return
	# 
	# リセット
	# 
	end: ->
		@reset()
		@explosionGroup.visible = false

		for path in @explosionGroup.children
			path.position = path.savePos

		return

	# 
	# 赤に変わる
	# 
	colorWarning: ->
		@fill.fillColor = Config.COLOR.BTN_FILL_RED
		return

	# 
	# 黄色に戻る
	# 
	colorNormal: ->
		@fill.fillColor = Config.COLOR.BTN_FILL
		return
	
	# 
	# 膨れる
	# 
	inflated: ->
		df = new $.Deferred
		TweenMax.to @position, 0.075, {
			y: 0
			ease: Sine.easeIn
		}
		TweenMax.to @, 0.075, {
			morph: INFLATED
			ease: Sine.easeIn
			onUpdate: @morphingUpdate
			onComplete: df.resolve
		}
		return df.promise()

	# 
	# 爆発
	# @param {Number}: シーンの横幅
	# 
	explosion: (width)=>
		df = new $.Deferred
		@fill.visible = false
		@stroke.visible = false

		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE3
		SoundManager.play _se
		
		# Tween
		@offsetPoint = new paper.Point -5, -20
		distance = PaperStage.instance.width / width * 2.0
		@explosionGroup.visible = true
		for path in @explosionGroup.children
			_p = new paper.Point path.position.x, path.position.y
			_point = _p.subtract @offsetPoint

			rad = _point.angleInRadians
			# ランダムに角度を変更
			rad += ( Math.random() * 0.5 - 0.25 ) * Math.PI
			length = _point.length
			_x = Math.cos(rad) * length * distance
			_y = Math.sin(rad) * length * distance

			_scale = Math.random() * .5 + .75
			_angle = Math.random() * 180 - 90
			
			position = path.position
			scaling = path.scaling
			
			path.rotate _angle
			TweenMax.to position, .6, {
				y: _y
				ease: Expo.easeOut
			}

			TweenMax.to position, .6, {
				x: _x
				ease: Expo.easeOut
			}

			TweenMax.to scaling, .6, {
				x: _scale
				y: _scale
				ease: Expo.easeOut
			}

		setTimeout df.resolve, 400
		return df.promise()

	# 
	# モーフィングアップデート
	# 
	morphingUpdate: =>
		if @_morph == @morph then return
		@stroke.update @morph
		@fill.update @morph
		@_morph = @morph
		return

module.exports = BtnView