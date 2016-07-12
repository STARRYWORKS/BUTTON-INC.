Config								= require 'config'
Utils									= require 'utils'
SimpleEventDispatcher	= require 'event'
Touch									= require './../utils/touch'
PaperStage						= require 'paper-stage'

# 
# PLAYページローディングビュー
# 
class LoaderView extends SimpleEventDispatcher
	@VIEW_SHOW	: "VIEW_SHOW"
	@VIEW_END		: "VIEW_END"

	constructor: () ->
		super()
		@sceneConfig = Config.Loading
		@$window = $(window)
		@stage = PaperStage.instance.stage

		@view = new paper.Group()
		@view.visible = false
		Utils.transformInit @view
		@stage.addChild @view

		# 表示オブジェクトインポート
		@text = @view.importSVG @sceneConfig.SVG.Text
		@btnGroup = @view.importSVG @sceneConfig.SVG.Button
		@btn = @btnGroup.children[0]
		@load = @btnGroup.children[1]
		@play = @btnGroup.children[2]
		@load.visible = false
		

		# 背景に白を引く
		@mask = new paper.Group()
		Utils.transformInit @mask
		_size = new paper.Size @view.bounds.width, @view.bounds.height
		_point = new paper.Point @view.bounds.x, @view.bounds.y
		_shape = new paper.Shape.Rectangle _point, _size
		_shape.fillColor = @sceneConfig.COLOR.BG
		@mask.addChild _shape
		@view.insertChild 0, @mask

		@$window.on('resize.LoaderView', @onResize).trigger('resize.LoaderView')
		@show()


	# 
	# 表示
	# 
	show: =>
		@startAddEvent()
		@view.opacity = 0
		TweenMax.to @view, .2, {
			opacity: 1
			ease: Expo.easeOut
			onStart: => @view.visible = true
			onComplete: => @dispatchEvent(LoaderView.VIEW_SHOW)
		}

		return

	# 
	# イベント登録
	# 
	startAddEvent: =>
		@tl = new TimelineMax({
			repeat: -1
		})
		@tl.to @play, 0, {
			opacity: 0,
			ease: Expo.easeIn
			delay: 1.8
		}
		@tl.to @play, 0, {
			opacity: 1,
			ease: Expo.easeIn
			delay: .15
		}

		@supportTouch = `'ontouchend' in document`
		if UA.type == UA.PC
			@EVENT_TOUCHMOVE = if (@supportTouch) then 'touchmove.LoaderView' else 'mousemove.LoaderView'
			@EVENT_CLICK = 'click.LoaderView'

			@$window.on @EVENT_TOUCHMOVE, (event)=>
				if @hitTest(event)
					@btn.fillColor = @sceneConfig.COLOR.ENTER
					document.body.style.cursor = "pointer"
				else
					@btn.fillColor = @sceneConfig.COLOR.LEAVE
					document.body.style.cursor = "default"
				return

			@$window.on @EVENT_CLICK, (event)=>
				if @hitTest(event) 
					document.body.style.cursor = "default"
					@hide()
				return
			
		else
			@EVENT_TOUCHSTART = if (@supportTouch) then 'touchstart.LoaderView' else 'mousedown.LoaderView'
			@EVENT_TOUCHEND = if (@supportTouch) then 'touchend.LoaderView' else 'mouseup.LoaderView'
			@$window.on @EVENT_TOUCHSTART, => @btn.fillColor = @sceneConfig.COLOR.ENTER
			@$window.on @EVENT_TOUCHEND, => @hide()

		return
	# 
	# ヒットテスト
	# @param {Object} event: ポジション
	# @returns {Bool} : テスト結果
	# 
	hitTest: (event) ->
		option =
			segments: true
			stroke: true
			fill: true
			tolerance: 5
		
		point = 
			x: event.originalEvent.pageX
			y: event.originalEvent.pageY
		point = @view.globalToLocal(point)
		test = @btnGroup.hitTest point, option
		return test

	# 
	# ロードビュー非表示
	# 
	hide: =>
		@view.visible = false
		@view.removeChildren()
		@view.remove()
		if UA.type == UA.PC
			@$window.off @EVENT_TOUCHMOVE
			@$window.off @EVENT_CLICK
		else
			@$window.off @EVENT_TOUCHSTART
			@$window.off @EVENT_TOUCHEND
		
		@tl.pause()
		@tl.kill()
		@dispatchEvent(LoaderView.VIEW_END)

	# 
	# リサイズ処理
	# 
	onResize: =>
		# 画面中央短辺の7割に収める
		_width = PaperStage.instance.width
		_height = PaperStage.instance.height
		@view.scaling.set 1, 1

		if _width < _height
			_size = _width * .72
			_scale = _size / @view.bounds.width
			if @view.bounds.width * _scale >= 300
				_scale = 300 / @view.bounds.width
		else
			_size = _height * .72
			_scale = _size / @view.bounds.height
			if @view.bounds.height * _scale >= 330
				_scale = 330 / @view.bounds.height
		@view.scaling.set _scale, _scale

		return

module.exports = LoaderView