#
# Localizablesクラス
#

LOCALIZABLES = {
	'ja': {
		'This web page requires WebGL support.':'このページを表示するにはWebGLに対応したブラウザが必要です。',
		'The url is empty.':'URLが入力されていません',
		'The url and image file are both empty.':'URLおよび画像ファイルが入力されていません',
		'Invalid url.':'URLが正しくありません',
		'The url was not found.':'URLの画像にアクセスできませんでした',
		'No face was found.':'画像中に顔が検出されませんでした',
		'The face is not smiling. You can only upload a photo with smiling face(s).':'検出された顔が笑顔ではありません。笑顔の写真のみ登録できます。',
		'Unknown error.':'原因不明のエラーが発生しました',
		'Your page is ready.':'ページを生成しました。',
	}
}


class Localizables
	@lang: (navigator.browserLanguage || navigator.language || navigator.userLanguage).substr(0,2)

	@localize: (message) ->
		if LOCALIZABLES[@lang]?[message]? then message = LOCALIZABLES[@lang][message]
		return message

###
auth: Kimura
data: 2016/01/16
###

#
# SimpleEventDispatcherクラス
#

class SimpleEventDispatcher
	constructor: () ->
		@listeners = {}

	addEventListener: (name,callback,args=[]) ->
		if !@listeners? then @listeners = {}
		if !@listeners[name]? then @listeners[name] = []
		# TODO: 重複リスナーチェック
		@listeners[name].push( new SimpleEventListener(name,callback,args) )
		return

	removeEventListener: (name,callback) ->
		if !@listeners? || !@listeners[name]? then return
		if ( callback == null )
			@listeners[name] = []
			return
		while ( (i = @indexOfCallback(name,callback)) >= 0 )
			@listeners[name].splice(i,1)
		return

	dispatchEvent: (name,data={}) ->
		if !@listeners? || !@listeners[name]? then return
		event = new SimpleEvent(this,name,data)
		for listener in @listeners[name]
			listener.dispatchEvent(event)
		return

	indexOfCallback: (name,callback) ->
		for listener,i in @listeners?[name]
			if listener.callback == callback then return i
		return -1

class SimpleEvent
	constructor: (target,name,data={}) ->
		@target = target
		@name = name
		@data = data
		return


class SimpleEventListener
	constructor: (name,callback,args=null) ->
		@name = name
		@callback = callback
		@args = args
		return

	dispatchEvent: (event) ->
		if typeof(@callback) != 'function' then return
		if @args && @args.length > 0
			@callback.apply(null, @args)
		else
			@callback.apply(null, [event])
		return

###
auth: Kimura
data: 2016/01/16
###

#
# Touchクラス
#

class Touch extends SimpleEventDispatcher
	@DOWN	= "down"
	@MOVE	= "move"
	@UP		= "up"

	@sharedInstance = null
	@init: (target) ->
		@sharedInstance = new Touch(target)
		return

	constructor: (target) ->
		@$window = $(window)
		@$target = $(target)
		@$target.on('touchstart',@onDown)
		@$target.on('mousedown',@onDown)
		@downPoint = {x:0,y:0}
		@vector = {x:0,y:0}
		return

	onDown: (event) =>
		@$window.on('touchend',@onUp)
		@$window.on('touchmove',@onMove)
		@$window.on('mouseup',@onUp)
		@$window.on('mousemove',@onMove)
		@downPoint = {x:event.originalEvent.pageX,y:event.originalEvent.pageY}
		@dispatchEvent(Touch.DOWN)
		return

	onMove: (event) =>
		@vector.x = event.originalEvent.pageX - @downPoint.x
		@vector.y = event.originalEvent.pageY - @downPoint.y
		@dispatchEvent(Touch.MOVE)
		return

	onUp: (event) =>
		@$window.off('touchend',@onUp)
		@$window.off('touchmove',@onMove)
		@$window.off('mouseup',@onUp)
		@$window.off('mousemove',@onMove)
		@vector.x = event.originalEvent.pageX - @downPoint.x
		@vector.y = event.originalEvent.pageY - @downPoint.y
		@dispatchEvent(Touch.UP)

		return

###
auth: Kimura
data: 2016/05/20
###

SVG = '<svg id="" xmlns="http://www.w3.org/2000/svg" width="145" height="61" viewBox="">
  <defs>
    <style>
      .cls-1 {
        fill: none;
        stroke: black;
        stroke-linejoin: miter;
        stroke-width: 5.5px;
      }
    </style>
  </defs>
  <title>button-svg</title>
  <g>
    <path class="cls-1" d="M30,45.5l1.1751-31.3373A9.1833,9.1833,0,0,1,40.1688,5.5C49.8475,5,57.5,5,72.5,5s22.6525,0,32.3312.5a9.1833,9.1833,0,0,1,8.9937,8.6627L115,45.5" transform="translate(0 -4.75)"/>
  </g>
  <g>
    <polyline class="cls-1" points="0 60.75 15 60.75 20 40.75 125 40.75 130 60.75 145 60.75"/>
  </g>
</svg>
'
LINE_WIDTH = 5.5

#
# ボタンオブジェクト
# @param {Object} group: パスデータ
#
class Btn extends paper.Group
	constructor: (group) ->
		super(group.children)
		@stroke = @children[0]
		# 塗りを作成
		@fill = @stroke.clone()
		@fill.strokeWidth = 0
		@fill.fillColor = '#fdf663'
		@fill.closed = true
		@insertChild(0,@fill)
		@basePosition = @position
		@leftBottomSegmentPosition = @stroke.segments[0].point.subtract(@basePosition)
		@leftTopSegmentPosition = @stroke.segments[1].point.subtract(@basePosition)
		@leftSegmentPosition = @stroke.segments[2].point.subtract(@basePosition)
		@topSegmentPosition = @stroke.segments[3].point.subtract(@basePosition)
		@rightTopSegmentPosition = @stroke.segments[4].point.subtract(@basePosition)
		@rightSegmentPosition = @stroke.segments[5].point.subtract(@basePosition)
		@rightBottomSegmentPosition = @stroke.segments[6].point.subtract(@basePosition)
		@press = 0
		@stroke.setFullySelected(true)
		@addAnchor()
		return

	setPress: (press) ->
		@press = press
#		@update()

	update: () =>
		if @press < -1 then @press = -1
		else if @press > 2 then @press = 2
		# y座標
		y = @press
		if y < 0 then y = 0
		else if y > 1 then y = 1
		@position.y = @basePosition.y + TWEEN.Easing.Sinusoidal.InOut(y) * 20
		# 押しすぎ
		if @press > 1
			p = @press - 1
			# 下に凹む
			@stroke.segments[3].point.y = @position.y + @topSegmentPosition.y + p * 2

			# 横に膨らむ
			# 左上 水平-2 垂直-2
			@stroke.segments[1].point.x = @position.x + @leftTopSegmentPosition.x + p * -2
			@stroke.segments[1].point.y = @position.y + @leftTopSegmentPosition.y + p * -2

			@stroke.segments[2].point.x = @position.x + @leftSegmentPosition.x + p * -2
			@stroke.segments[2].point.y = @position.y + @leftSegmentPosition.y + p * -2

			# 左下 水平-2
			# @stroke.segments[0].point.x = @position.x + @leftBottomSegmentPosition.x + p * -2


			# 右上 水平2 垂直-2
			@stroke.segments[4].point.x = @position.x + @rightTopSegmentPosition.x + p * 2
			@stroke.segments[4].point.y = @position.y + @rightTopSegmentPosition.y + p * -2

			@stroke.segments[5].point.x = @position.x + @rightSegmentPosition.x + p * 2
			@stroke.segments[5].point.y = @position.y + @rightSegmentPosition.y + p * -2

			# 右下 水平2
			# @stroke.segments[6].point.x = @position.x + @rightBottomSegmentPosition.x + p * 2

			@position.x = @basePosition.x

# 引っ張りすぎ
		else if @press < 0
			p = @press
			@stroke.segments[3].point.y = @position.y + @topSegmentPosition.y + p * 0.5
			@position.x = @basePosition.x + Math.sin(new Date().getTime() * 0.03) * 0.5
			@position.y = @basePosition.y + p * 2.75
		else
#			@stroke.segments[3].point.y = @position.y + @topSegmentPosition.y
#
#			@stroke.segments[1].point.x = @position.x + @leftTopSegmentPosition.x
#			@stroke.segments[1].point.y = @position.y + @leftTopSegmentPosition.y
#
#			@stroke.segments[2].point.x = @position.x + @leftSegmentPosition.x
#			@stroke.segments[2].point.y = @position.y + @leftSegmentPosition.y
#
#			@stroke.segments[4].point.X = @position.X + @rightTopSegmentPosition.X
#			@stroke.segments[4].point.y = @position.y + @rightTopSegmentPosition.y
#
#			@stroke.segments[5].point.x = @position.x + @rightSegmentPosition.x
#			@stroke.segments[5].point.y = @position.y + @rightSegmentPosition.y
#
			@position.x = @basePosition.x

		return


	release: () ->
		@tween = new TWEEN.Tween(@)
		.to({'press': 0}, 100)
		.easing(TWEEN.Easing.Back.Out)
		.start()
		return
#
# アンカーポイントの追加
#
	addAnchor: ()->

		#0 と 1の間にアンカーを追加
		p1 = @stroke.segments[0].point
		p2 = @stroke.segments[1].point
		vector = p2.subtract(p1)
		vector.length = vector.length * 0.5
		p = p1.add(vector)
		@stroke.insert(1,p)

		console.log "======= btn =========="
		console.log "@btn.position", @position
		console.log "p1", p1
		console.log "p2", p2
		console.log "p", p

		return


#
# 土台オブジェクト
# @param {Object} group: パスデータ
#
class Base extends paper.Group
	constructor: (group) ->
		super(group.children)
		@stroke = @children[0]

		# 土台部分の塗りを作成
		@fill = @stroke.clone()
		@fill.strokeWidth = 0
		@fill.fillColor = '#e2eced'

		# 塗りに必要ない両端のポイントを削除
		@fill.segments.pop()
		@fill.segments.shift()
		@fill.closed = true

		# 線幅分だけ塗りを伸ばす
		vector = @fill.segments[0].point.subtract(@fill.segments[1].point)
		vector.length = LINE_WIDTH * 0.5
		@fill.segments[0].point = @fill.segments[0].point.add(vector)
		vector = @fill.segments[3].point.subtract(@fill.segments[2].point)
		vector.length = LINE_WIDTH * 0.5
		@fill.segments[3].point = @fill.segments[3].point.add(vector)

		@insertChild(0,@fill)

		console.log "======= Base =========="
		console.log "@base.position", @position

		return

#
# Mainクラス
#
class Main
	constructor: () ->
		@$canvas = $('#MainCanvas')
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')
		Touch.init(@canvas)
		@$window = $(window)

		# キャンバス指定
		paper.setup(@canvas)

		# フォーマットSVG読み込み
		paper.project.importSVG(SVG)
		container = paper.project.layers[0].children[0]
		container.fillColor = new paper.Color(0,255,0)
		# フォーマットを基に再定義
		console.log "======= container =========="
		console.log "@container.position", container.position

		@btn = new Btn(container.children[0])
		@base = new Base(container.children[1])

		@btnLayer = paper.project.layers[0]
		console.log "======= btnLayer =========="
		console.log "@btnLayer.position", @btnLayer.position
		@btnLayer.fillColor = new paper.Color(255,0,0)
		@btnLayer.removeChildren()
		@btnLayer.addChild(@btn)
		@btnLayer.addChild(@base)

		# console.log paper.project

		#イベント設定
		paper.view.onFrame = @onFrame
		@$window.on('resize',@onResize)
		@onResize()
		Touch.sharedInstance.addEventListener(Touch.DOWN, @onDown)
		Touch.sharedInstance.addEventListener(Touch.MOVE, @onMove)
		Touch.sharedInstance.addEventListener(Touch.UP, @onUp)
		return

	onDown: (event) =>
		return

	onMove: (event) =>
		touch = event.target
		@btn.setPress (touch.vector.y / @stageHeight) * 10
		return

	onUp: (event) =>
		@btn.release()
		return

	onFrame: () =>
		TWEEN.update()
#		@btn.update()
		@context.clearRect(0,0,@stageWidth,@stageHeight)
		paper.view.update(true)
		return

	onResize: () =>
		@stageWidth = @$window.width()
		@stageHeight = @$window.height()
		@$canvas.attr('width',@stageWidth+'px')
		@$canvas.attr('height',@stageHeight+'px')
		@$canvas.css('width',@stageWidth+'px')
		@$canvas.css('height',@stageHeight+'px')
		@btnLayer.matrix = new paper.Matrix()
		@btnLayer.position.x = @stageWidth * 0.5
		@btnLayer.position.y = @stageHeight * 0.5
		scale = ( ( if @stageWidth < @stageHeight then @stageWidth else @stageHeight) / 320 )
		if scale > 3 then scale = 3
		@btnLayer.scale(scale,scale)
		return


#
# DOM READY
#
$(()->
	window.main = new Main()
)
