require 'extension'
LogoType		= require 'logo-type'
Utils				= require 'utils'
Config			= require 'config'
PaperStage	= require 'paper-stage'
# 
# 爆発シーンで使用するためのロゴタイプクラス
# 
class LogoTypeView extends LogoType
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->

		# パス設定
		for path in @pathes
			path.savePos = path.position
			path.remove()

		@logoTypeGroup = new paper.Group()
		Utils.transformInit @logoTypeGroup
		@addChild @logoTypeGroup
		@logoTypeGroup.addChildren @pathes

		# 警告画像
		@raster = new paper.Raster '/images/play/explosion-bg.png'
		@raster.onLoad = @rasterOnLoad
		@raster.remove()

		@warning = new paper.Group()
		Utils.transformInit @warning
		@addChild @warning
		@warning.visible = false

		return

	# 
	# 画像読み込み完了時
	# 
	rasterOnLoad: =>
		@raster.scaling.set 0.5, 0.5

		@warningTypes = []
		for path,i in @logoTypeGroup.children
			group = new paper.Group([path.clone(), @raster.clone()])
			Utils.transformInit group
			group.clipped = true
			@warning.addChild group

		return

	#
	#
	#
	warningUpdate: ->
		for group in @warning.children
			if group.children[1].position.x > 59 then group.children[1].position.x = 0
			group.children[1].position.x += 0.5
	# 
	# 警告カラー表示
	# 
	warningShow: ->
		@logoTypeGroup.visible = false
		@warning.visible = true
		@warningUpdate()
		return

	# 
	# 警告カラー非表示
	# 
	warningHide: ->
		@logoTypeGroup.visible = true
		@warning.visible = false
		for group in @warning.children
			group.children[1].position.x = 0
		return

	# 
	# リセット
	# 
	end: ->
		for path in @logoTypeGroup.children
			path.matrix = new paper.Matrix()
			path.rotate 0
			path.scaling.set 1, 1
			path.position = path.savePos

		return

	# 
	# 爆発
	# @param {Number}: シーンの横幅
	# 
	explosion: (width)=>
		
		# Tween
		@offsetPoint = new paper.Point -5, -20
		distance = PaperStage.instance.width / width * 1.3
		for path in @logoTypeGroup.children
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


module.exports = LogoTypeView