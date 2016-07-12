Config								= require 'config'
SimpleEventDispatcher	= require 'event'
PaperStage						= require 'paper-stage'
SoundManager					= require 'sound-manager'
Scene									= require './scene'
DatGUI								= require './dat'

###
auth: Kimura
data: 2016/05/20
###

class Main
	constructor: () ->
		@dpr = if window.devicePixelRatio == undefined then 1 else window.devicePixelRatio
		@$window = $(window)
		$("#Canvas").append('<canvas id="'+Config.Canvas.paper+'">')
		@$canvas = $("#" + Config.Canvas.paper)
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')
		@isFirstScene = true

		# paper.js 設定
		@paper = new PaperStage(@$canvas,@dpr)

		# イベント設定
		@$window.on('resize', @onResize).trigger('resize')
		
		# デバッグ用コンソール


		# シーン設定
		@scenes = 
			"Scene"			: new Scene @gotoNextScene

		@dat = new DatGUI([@scenes['Scene'].fluid])
		@scenesLen = Object.keys(@scenes).length
		@sceneIndex = -1
		@gotoNextScene()

		# update
		paper.view.onFrame = @onUpdate

		return

	# 
	# アクティブシーンの変更
	# 
	gotoNextScene: ()=>

		if location.hash == "" #ランダム
			@sceneIndex = Math.floor(Math.random() * @scenesLen)

		else if location.hash == "#all" #順番
			@sceneIndex += 1
			@sceneIndex %= @scenesLen

		else if location.hash != "" #選択
			@isFirstScene = false
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
				@isFirstScene = false
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
		@paper.update()
		@currentScene?.update()

		paper.view.update(true)

		return

	# 
	# リサイズ処理
	# 
	onResize: =>
		# ステージサイズ設定
		@stageWidth = @$window.width()
		@stageHeight = @$window.height()
		
		# paperリサイズ
		@paper.resize(@stageWidth, @stageHeight)

		return

	
#
# DOM READY
#
$(()->
	window.main = new Main()
)