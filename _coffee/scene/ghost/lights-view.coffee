require 'extension'
Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
# おばけシーンで使用するための消灯クラス
# 
class LightsVeiw extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Ghost
		@$window = $(window)
		@opacity = 0

	# 
	# アクティブシーン開始時
	# 
	start: ->
		# イベント登録
		@$window.on('resize.LightsVeiw', @onResize).trigger 'resize.LightsVeiw'
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		@removeChildren()
		@opacity = 0
		@$window.off 'resize.LightsVeiw'
		
	# 
	# ステージを暗くする
	# @param {Number} duration: フェードアウトの秒数 (ms)
	# @returns {Object} 完了を返す
	# 
	off: (duration = 0)->
		df = new $.Deferred()

		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se

		# Tween
		_d = duration / 1000
		TweenMax.to @, _d, {
			opacity: 1
			ease: Expo.easeOut
			onComplete: df.resolve
		}
		return df.promise()

	# 
	# ステージを通常に戻す
	# @param {Number} duration: フェードアウトの秒数 (ms)
	# @returns {Object} 完了を返す
	# 
	on: (duration = 0)->
		df = new $.Deferred()
		_d = duration / 1000
		TweenMax.to @, _d, {
			opacity: 0
			ease: Expo.easeOut
			onComplete: df.resolve
		}
		return df.promise()

	# 
	# リサイズ処理
	# 
	onResize: =>
		@removeChildren()
		_size =  new paper.Size PaperStage.instance.width, PaperStage.instance.height
		# 画面中央対応のため x軸-8移動
		_point = new paper.Point (_size.width / -2) - 8, _size.height / -2
		_shape = new paper.Shape.Rectangle _point, _size
		_shape.fillColor = @sceneConfig.COLOR.BG
		Utils.transformInit _shape
		@addChild _shape
		return

module.exports = LightsVeiw