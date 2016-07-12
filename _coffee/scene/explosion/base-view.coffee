require 'extension'
Config			= require 'config'
Utils				= require 'utils'
Base				= require 'base'
PaperStage	= require 'paper-stage'
# 
# 爆発シーンで使用するためのベースクラス
# 
class BaseView extends Base
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Explosion

		# 爆発
		@explosionGroup = new paper.Group()
		@explosionGroup.visible = false
		Utils.transformInit @explosionGroup

		_svg = @importSVG @sceneConfig.SVG.ExplosionBaseBefore
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
	# 爆発
	# @param {Number}: シーンの横幅
	# 
	explosion: (width)=>
		@fill.visible = false
		@stroke.visible = false

		# Tween
		@offsetPoint = new paper.Point -5, -20
		distance = PaperStage.instance.width / width * 1.6
		@explosionGroup.visible = true
		for path in @explosionGroup.children
			_p = new paper.Point path.position.x, path.position.y
			_point = _p.subtract @offsetPoint

			rad = _point.angleInRadians
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


		return 


module.exports = BaseView