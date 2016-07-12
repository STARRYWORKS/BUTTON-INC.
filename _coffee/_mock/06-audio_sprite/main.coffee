Config = require 'config'
SoundManager = require './sound-manager'


class Main
	constructor: () ->
		# サウンドイニシャライズ
		setTimeout SoundManager.init, 500
		# createjs.Sound.initializeDefaultPlugins()
		# assetsPath = ""
		# sounds = [
		# 	{
		# 	  "src": "/sound/default.ogg",
		# 	  "data": {
		# 	    "audioSprite": [
		# 	      {
		# 	        "id": "BaloonFailed_0",
		# 	        "startTime": 0,
		# 	        "duration": 1732.5170068027212
		# 	      }
		# 	    ]
		# 	  }
		# 	}
		# ]
		# createjs.Sound.alternateExtensions = ["mp3"]
		# createjs.Sound.on("fileload", @loadSound)
		# createjs.Sound.registerSounds(sounds, assetsPath)
		
		$(".play").on "click", @onPlay
		$(".loop").on "click", @onLoop
		$(".fadein").on "click", @onFadeIn
		$(".stop").on "click", @onStop
		$(".fadeout").on "click", @onFadeOut
		@update()
		return

	# loadSound: ->
	# 	console.log "@loadSound"
	# 	return

	onPlay: =>
		console.log "play"
		console.log "createjs.Sound.volume:",createjs.Sound.volume
		console.log "createjs.Sound:",createjs.Sound
		SoundManager.play 'BaloonFailed_0'
		# createjs.Sound.volume = 1
		# createjs.Sound.play 'BaloonFailed_0'
		return false

	onLoop: =>
		console.log "loop"
		SoundManager.play 'BaloonFailed_0', null, true
		return false

	onFadeIn: =>
		console.log "fadeIn"
		SoundManager.play 'BaloonFailed_0', 2000, true
		return false

	onStop: =>
		SoundManager.stop 'BaloonFailed_0', null
		return false

	onFadeOut: =>
		SoundManager.stop 'BaloonFailed_0', 2000
		return false

	update:()=>
		requestAnimationFrame(@update)
		TWEEN.update()
		return



#
# DOM READY
#
$(()->
	setTimeout(()->
		window.main = new Main()
	, 1000)
)


