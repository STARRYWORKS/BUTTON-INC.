Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
MorphablePath	= require 'morphable-path'

# 
# ロケットシーンで使用するためのロケットの煙クラス
# @param {Object} scene
# 
class SmokeView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Rocket
		Utils.transformInit @
		
		@smoke = []
		@smoke.push @importSVG @sceneConfig.SVG.Smoke1
		@smoke.push @importSVG @sceneConfig.SVG.Smoke2
		@smoke.push @importSVG @sceneConfig.SVG.Smoke3
		@smoke.push @importSVG @sceneConfig.SVG.Smoke4
		@smoke.push @importSVG @sceneConfig.SVG.Smoke5
		@smoke.push @importSVG @sceneConfig.SVG.Smoke6
		$.each @smoke, (i, _smoke)->
			_smoke.visible = false
			_smoke.opacity = 0
			$.each _smoke.children, (j, path)=>
				path.baseX = path.position.x
				path.baseY = path.position.y
			return
		@sequence = 0
		
	# 
	# 煙表示
	# 
	show: ()=>
		$.each @smoke, (i, _smoke)=>
			if @sequence != i
				# 消すのは前半のけむりだけ
				if @sequence < 4
					TweenMax.to _smoke, .05, {
						delay: .25
						opacity: 0
						onComplete: ->
							_smoke.visible = false
					}
			else
				TweenMax.to _smoke, .05, {
					opacity: 1
					onStart: ->
						_smoke.visible = true
						_smoke.opacity = 0
				}
				$.each _smoke.children, (j, path)=>
					test = if j % 2 == 0 then 1 else -1
					startedTime = new Date().getTime()
					# _scale = Math.random()*(.8 - .4) + .4
					# path.scaling.set _scale, _scale
					path.tween?.kill()
					path.opacity = 0
					path.position.x = path.baseX
					path.position.y = path.baseY
					path.tween = TweenMax.to path.scaling, .3, {
						x: 1
						y: 1
						repeat: -1
						yoyo: true
						delay: j * .05
						onStart: =>
							path.opacity = 1
						onUpdate: =>
							time = new Date().getTime() - startedTime
							offset = 1+(time/2000)
							path.position.x = (path.baseX * offset) + (Math.sin(time * 0.05 ) * test)
							path.position.y = path.baseY + offset * 10
					}
					return
			return

		@sequence += 1
		if @sequence < @smoke.length then @timeID = setTimeout @show, 280
		else @hide()
		return

	# 
	# 非表示
	# 
	hide: ->
		TweenMax.to @, 0, {
			opacity: 0
			delay: 1.5
			onComplete: =>
				$.each @smoke, (i, _smoke)=>
					_smoke.visible = false
					_smoke.opacity = 0
					$.each _smoke.children, (j, path)=>
						path.scaling.set 1, 1
						path.tween?.kill()
					return
				return
		}
		return

	# 
	# エフェクト
	# 
	scroll: =>
		position = @position
		TweenMax.to position, 2.7, {
			y: PaperStage.instance.height * 0.7
			ease: Expo.easeIn
		}
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@position.set 0, 0
		@sequence = 0
		@opacity = 1
		return


module.exports = SmokeView