Config								= require 'config'
Utils									= require 'utils'
SimpleEventDispatcher	= require 'event'
PaperStage						= require 'paper-stage'
SoundManager					= require 'sound-manager'
Touch									= require 'touch'
Localizables					= require './utils/localizables'
# DatGUI								= require './utils/dat'
# StatsView							= require './utils/stats'
LoaderView						= require './loader/loader-view'
Pudding								= require './scene/pudding/pudding'
Jump									= require './scene/jump/jump'
Explosion							= require './scene/explosion/explosion'
Ghost									= require './scene/ghost/ghost'
Elevator							= require './scene/elevator/elevator'
Escape								= require './scene/escape/escape'
Delivery							= require './scene/delivery/delivery'
Ufo										= require './scene/ufo/ufo'
Rocket								= require './scene/rocket/rocket'
PatrolLamp						= require './scene/patrol-lamp/patrol-lamp'
Squash								= require './scene/squash/squash'
Fall									= require './scene/fall/fall'
BalloonFailure				= require './scene/balloon-failure/balloon-failure'
BalloonAway						= require './scene/balloon-away/balloon-away'
Poo										= require './scene/poo/poo'
GnavTop								= require './contents/gnav-top'

###
auth: Kimura
data: 2016/05/20
###

NORMAL			= "normal"
UPSIDE_DOWN	= "upsidedown" 

class Main
	constructor: () ->
		@dpr = if window.devicePixelRatio == undefined then 1 else window.devicePixelRatio
		
		@$window = $(window)
		@$canvas = $("#" + Config.Canvas.paper)
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')
		@$humberger = $('.c-humberger').hide()
		# メニューボタン
		new GnavTop($('#GNav'), $('.c-humberger'), $('#Canvas'))

		# タッチイベントイニシャライズ
		Touch.init(@canvas)

		# サウンドイニシャライズ
		if UA.career != UA.SAFARI then SoundManager.init()
		else setTimeout SoundManager.init, 500 # Safari初回の起動時に音がならない為少しラグを設ける

		# paper.js 設定
		@paper = new PaperStage(@$canvas)

		# イベント設定
		@$window.on('resize', @onResize).trigger('resize')
		paper.view.onFrame = @onUpdate

		# デバッグ用コンソール
		# if UA.type == UA.PC then @dat = new DatGUI @
		# @statsView = new StatsView()

		if location.hash == ""
			@loaderView = new LoaderView()
			@loaderView.addEventListener(LoaderView.VIEW_SHOW, @sceneInit)
			@loaderView.addEventListener(LoaderView.VIEW_END, @touchInit)
		else
			@sceneInit()
			@touchInit()

		# イースターエッグ設定
		@direction = NORMAL
		if UA.type == UA.PC
			@execCount = 0
			cheet Config.KONAMI_COMMAND, @onPCEasteEggInit
		else
			@isDirectionChanged = false
			@$window.on "deviceorientation", @onSPEasteEggInit

		# Twitter, Facebook アプリ内ブラウザ対応
		if Utils.ua.fb || Utils.ua.tw then @$window.on 'touchmove.noScroll', (e)-> e.preventDefault()

	# 
	# ロードビュー終了後タッチ処理開始
	# 
	touchInit: =>
		Touch.sharedInstance.addEventListener(Touch.DOWN, @onDown)
		Touch.sharedInstance.addEventListener(Touch.MOVE, @onMove)
		Touch.sharedInstance.addEventListener(Touch.UP, @onUp)
		@$humberger.show()
		return

	# 
	# ロードビューのバックグラウンドでイニシャライズ
	# 
	sceneInit: =>
		# シーン設定
		@scenes = 
			"PatrolLamp"			: new PatrolLamp @gotoNextScene
			"Elevator"				: new Elevator @gotoNextScene
			"Delivery"				: new Delivery @gotoNextScene
			"Escape"					: new Escape @gotoNextScene
			"Explosion"				: new Explosion @gotoNextScene
			"Squash"					: new Squash @gotoNextScene
			"Jump"						: new Jump @gotoNextScene
			"Ufo"							: new Ufo @gotoNextScene
			"Rocket"					: new Rocket @gotoNextScene
			"Pudding"					: new Pudding @gotoNextScene
			"Ghost"						: new Ghost @gotoNextScene
			"Fall"						: new Fall @gotoNextScene
			"BalloonFailure"	: new BalloonFailure @gotoNextScene
			"BalloonAway"			: new BalloonAway @gotoNextScene
			"Poo"							: new Poo @gotoNextScene

		# 尺の長いのは出現回数少なく、短いのは多く、うんこは少なく
		@sceneFrequencies = 
			"PatrolLamp"			: 2
			"Elevator"				: 2
			"Delivery"				: 2
			"Escape"					: 4
			"Explosion"				: 2
			"Squash"					: 2
			"Jump"						: 4
			"Ufo"							: 2
			"Rocket"					: 2
			"Pudding"					: 4
			"Ghost"						: 2
			"Fall"						: 4
			"BalloonFailure"	: 2
			"BalloonAway"			: 2
			"Poo"							: 2

		@scenesLen = Object.keys(@scenes).length
		@sceneIndex = -1

		# ランダム用
		@randomSceenes = []
		for key, scene of @scenes
			for i in [0...@sceneFrequencies[key]]
				if i % 2 == 0
					@randomSceenes.push scene
				else
					@randomSceenes.unshift scene
		@shuffleArray @randomSceenes

		# 避けるシーンは最初にしない
		while @randomSceenes[0] == @scenes["Escape"]
			@randomSceenes.push @randomSceenes.shift()

		@gotoNextScene()

		return

	# 
	# 配列シャッフル
	# 
	shuffleArray: (array) ->
		m = array.length
		while m
			i = Math.floor(Math.random() * m--)
			t = array[m]
			array[m] = array[i]
			array[i] = t
		return array


	# 
	# アクティブシーンの変更
	# 
	gotoNextScene: ()=>

		if location.hash == "" #ランダム
			@sceneIndex++
			if @sceneIndex >= @randomSceenes.length
				@shuffleArray @randomSceenes
				@sceneIndex %= @randomSceenes.length
			@currentScene = @randomSceenes[@sceneIndex]
			@currentScene.start()
		else

			if location.hash == "#all" #順番
				@sceneIndex++
				@sceneIndex %= @scenesLen

			else if location.hash != "" #選択
				_key = location.hash.replace "#", ""
				_i = 0
				for key, scene of @scenes
					if key == _key 
						@sceneIndex = _i
						break
					_i += 1

			_i = 0

			for key, scene of @scenes
				if _i == @sceneIndex
					@currentScene = scene
					@currentScene.start()
					break
				_i += 1

		return

	# 
	# メインupdate
	# 
	onUpdate: =>
		TWEEN.update()
		# @paper.update()
		@currentScene?.update()

		@context.clearRect(0,0,@stageWidth,@stageHeight)
		paper.view.update(true)

		@ctxScale = 1
		@drawBasePosition(@paper.stage)
		@statsView?.update()
		return

	# 
	# マウス/タッチ ダウン
	# 
	onDown: (event) =>
		touch = event.target
		point = touch.point
		press = 0
		if @direction == UPSIDE_DOWN
			point.x = @$window.width() - point.x
		if !@hitTest(point) && !@$humberger.hasClass('close') then @currentScene.touchDown point, press
		return

	# 
	# マウス/タッチ ムーブ
	# 
	onMove: (event) =>
		touch = event.target
		point = touch.point
		vector = touch.vector
		if @direction == UPSIDE_DOWN 
			point.x = @$window.width() - point.x
			vector = vector.multiply(-1)
		press = (vector.y / @stageHeight) * 10
		if !@hitTest(point) && !@$humberger.hasClass('close') then @currentScene.touchMove vector, point, press
		return

	# 
	# マウス/タッチ アップ
	# 
	onUp: (event) =>
		touch = event.target
		point = touch.point
		vector = touch.vector
		if @direction == UPSIDE_DOWN
			point.x = @$window.width() - point.x
			vector = vector.multiply(-1)
		press = (vector.y / @stageHeight) * 10
		if !@hitTest(point) && !@$humberger.hasClass('close') then @currentScene.touchUp vector, point, press
		return

	# 
	# リサイズ処理
	# 
	onResize: =>
		# ステージサイズ設定
		@stageWidth = @$window.width()
		@stageHeight = @$window.height()

		# Twitter, Facebook アプリ内ブラウザ対応
		if Utils.ua.fb || Utils.ua.tw
			@stageHeight -= 100
			@$canvas.css(
				'height' :@stageHeight
			)
		
		# paperリサイズ
		@paper.resize(@stageWidth, @stageHeight)

		return

	# 
	# クリック範囲チェック
	# @param {Object} point: クリック位置
	# 
	hitTest: (point)->
		minX = @$humberger.offset().left
		maxX = minX + @$humberger.width()
		minY = @$humberger.offset().top
		maxY = minY + @$humberger.height()
		hit = if minX <= point.x && maxX >= point.x && minY <= point.y && maxY >= point.y then true else false
		return hit
	
	# 
	# イースターエッグPC設定
	# 
	onPCEasteEggInit: =>
		@execCount += 1
		
		if @execCount % 2 == 1
			# 隠しコマンド
			Utils.secretMode = true
			_r = 360
		else
			# 通常モード
			Utils.secretMode = false
			_r = 0

		if @paper.stage.tween? then @paper.stage.tween.kill()
		@paper.stage.tween = TweenMax.to @paper.stage, .3, {
			rotation: _r
			ease: Back.easeOut
		}

		return
	
	# 
	# イースターエッグSP設定
	# 
	onSPEasteEggInit: (evant)=>
		beta = evant.originalEvent.beta
		if Math.abs(-90-beta) < 60 && @direction == NORMAL
			# 隠しコマンド
			@direction = UPSIDE_DOWN
			Utils.secretMode = true
			# @paper.stage.rotation = 0
			if @paper.stage.tween? then @paper.stage.tween.kill()
			@paper.stage.tween = TweenMax.to @paper.stage, .3, {
				rotation: 180
				ease: Back.easeOut
			}
		else if Math.abs(-90-beta) >= 80 && @direction == UPSIDE_DOWN
			# 通常モード
			@direction = NORMAL
			Utils.secretMode = false
			# @paper.stage.rotation = 180
			if @paper.stage.tween? then @paper.stage.tween.kill()
			@paper.stage.tween = TweenMax.to @paper.stage, .3, {
				rotation: 0
				ease: Back.easeOut
			}

	# 
	# 
	# 
	drawBasePosition: (obj) ->
		# 基準点を描画
		x = obj.position.x
		y = obj.position.y
		color = '#00ffff' #ブルー
		if obj instanceof paper.Layer then color = '#ff88ff' # Layerはピンク
		else if obj instanceof paper.Group then color = '#88ff88' # グループはグリーン

		if @pivotShowAll || (@pivotShowLayer && obj instanceof paper.Layer) || (@pivotShowGroup && obj instanceof paper.Group) || (@pivotShowOther && !(obj instanceof paper.Layer) && !(obj instanceof paper.Group))
			@drawLine({x:x-5, y:y}, {x:10, y:0}, color )
			@drawLine({x:x, y:y-5}, {x:0, y:10}, color )

		@context.save()
		obj.matrix.applyToContext(@context)
		# グループやLayerの場合は子オブジェクトを処理する
		if obj instanceof paper.Layer || obj instanceof paper.Group
			for child in obj.children
				@drawBasePosition(child)

		@context.restore()
		return

	# 
	# 
	# 
	drawLine: (from,to,color) ->
		@context.beginPath()
		@context.moveTo(from.x,from.y)
		@context.lineTo(from.x+to.x,from.y+to.y)
		@context.strokeStyle = color
		@context.lineWidth = 1 / @ctxScale
		@context.closePath()
		@context.stroke()
		return

#
# DOM READY
#
$(()->
	window.main = new Main()
)


