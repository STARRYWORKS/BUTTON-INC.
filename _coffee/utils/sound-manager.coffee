Config	= require 'config'
Utils		= require 'utils'

#
# SoundManagerクラス
#
class SoundManager
	@sharedInstance: null

	@init: =>
		@isInitialized = false
		@isSecretLoaded = false
		@instances = {}
		@getDefaultJson()
		return

	# 
	# default.json読み込み
	# 
	@getDefaultJson: ->
		# サウンド json 読み込み
		$.ajax({
			type : 'GET'
			url : Config.SoundJson.default
			dataType: 'json'
		})
		.done(@onLoadJson)
		.fail(@onFailJson)
		return

	# 
	# secret.json読み込み
	# 
	@getSecretJson: ->
		@isSecretLoaded = true
		$.ajax({
			type : 'GET'
			url : Config.SoundJson.secret
			dataType: 'json'
		})
		.done(@initSound)
		.fail(@onFailJson)
		return


	# 
	# json読み込み時
	# @param {Object} json: オーディオスプライト情報JSON
	# 
	@onLoadJson: (json)=>
		# 音鳴らすために最初のタッチエンドでSoundManagerのinitをコールする
		if /iPhone|iPad|iPod/i.test(navigator.userAgent)
			$(window).on 'touchstart.SoundManager', ()=> @initSound json
		else
			@initSound json

		return

	# 
	# json取得失敗
	# 
	@onFailJson: ()=>
		throw "jsonの読み込みに失敗しました。"
		return

	# 
	# スプライト設定
	# @param {Object} json: オーディオスプライト情報JSON
	# 
	@initSound: (json)=>
		$(window).off 'touchstart.SoundManager'

		createjs.Sound.initializeDefaultPlugins()
		if /iPhone|iPad|iPod/i.test(navigator.userAgent)
			createjs.WebAudioPlugin.playEmptySound()

		sounds = [json]
		assetPath = ''
		createjs.Sound.alternateExtensions = ['mp3']
		createjs.Sound.on('fileload', @onLoadResource)
		createjs.Sound.registerSounds(sounds, assetPath)

		return

	# 
	# スプライトファイル読み込み時
	# 
	@onLoadResource: =>
		@isInitialized = true

		# シークレット用json読み込み
		if !@isSecretLoaded then @getSecretJson()

		# TODO一旦やめる
		# $(window)
		# 	.on 'focus', @onWindowFocus
		# 	.on 'blur', @onWindowBlur
		# 	.on 'pageshow', @onWindowFocus
		# 	.on 'pagehide', @onWindowBlur

		return

	# 
	# 再生
	# @param {String} id: 再生するスプライトID
	# @param {floor} duration: フェードイン時間(ms)
	# @param {Boolean} isLooped: ループフラグ
	# @param {Object} onPlay: 再生終了時のコールバック
	# @param {Object} onEnd: 再生開始時のコールバック
	# 
	@play: (id, duration, isLooped, onEnd, onPlay)->
		if !@isInitialized then return
		if typeof id == "undefined" then return
		if @instances[id]? then return

		params = {}
		if isLooped then params.loop = -1

		instance = createjs.Sound.play(id,params)
		@instances[id] = instance
		instance.isPlaying = true

		# フェードイン
		if duration?
			if instance.tween? then instance.tween.stop()
			instance.volume = 0
			instance.fadeVolume = 0
			instance.tween = new TWEEN.Tween(instance)
				.easing( TWEEN.Easing.Cubic.InOut )
				.to({fadeVolume:1},duration)
				.onUpdate ->
					instance.setVolume(instance.fadeVolume)
				.start()

		# IDクリア処理
		instance.addEventListener 'complete', ()=>
			@instances[id] = null
			return

		# イベント追加
		if onEnd? then instance.addEventListener 'complete', onEnd
		if onPlay? then instance.addEventListener 'succeeded', onPlay

		return

	# 
	# 停止
	# @param {String} id: 再生するスプライトID
	# @param {floor} duration: フェードイン時間(ms)
	# 
	@stop: (id,duration = 100)=>
		if !@isInitialized then return
		if typeof id == "undefined" then return
		instance = @instances[id]
		if !instance? then return
		if !instance.isPlaying then return

		instance.removeAllEventListeners()
		instance.isPlaying = false

		# フェードアウト
		if duration?
			if instance.tween? then instance.tween.stop()
			instance.fadeVolume = 1
			instance.tween = new TWEEN.Tween(instance)
				.easing( TWEEN.Easing.Cubic.InOut )
				.to({fadeVolume:0},duration)
				.onUpdate ->
					instance.setVolume(instance.fadeVolume)
				.onComplete ->
					instance.position = 0
					instance.stop()
				.start()
		else
			instance.position = 0
			instance.stop()

		@instances[id] = null
		return

	# 
	# ミュート
	# 
	@mute: ->
		createjs.Sound.setMute(true)
		return

	# 
	# ミュート解除
	# 
	@unmute: ->
		createjs.Sound.setMute(false)
		return

	# 
	# ウィンドウが非アクティブになった時
	# 
	@onWindowBlur: (event) =>
		@mute()
		return

	# 
	# ウィンドウがアクティブになった時
	# 
	@onWindowFocus: (event) =>
		@unmute()
		return

module.exports = SoundManager
