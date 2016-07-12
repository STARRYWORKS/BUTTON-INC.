Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
# ロケットシーンで使用するためのカウントダウンクラス
# @param {Object} scene
# 
class CountDownView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Rocket
		Utils.transformInit @
		@count = []
		@count.push @importSVG @sceneConfig.SVG.Count3
		@count.push @importSVG @sceneConfig.SVG.Count2
		@count.push @importSVG @sceneConfig.SVG.Count1
		for count in @count
			Utils.transformInit count, false
			count.visible = false
			for path in count.children
				Utils.transformInit path
		

	# 
	# アクティブシーン開始時
	# 
	start: ->
		return

	# 
	# アクティブシーン終了時
	# 
	end: ->
		for count in @count
			count.visible = false
		return

	# 
	# エフェクト
	# @returns {Object} 完了を返す
	# 
	effect: ->
		df = new $.Deferred()
		_delay = 0
		_i = 3
		
		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		SoundManager.play _se

		# カウントダウン
		# for count in @count
		$.each @count, (i,count)->
			TweenMax.to count.scaling, .35, {
				delay:_delay / 1000
				onStart: -> count.visible = true
				onComplete: -> count.visible = false
			}
			_delay += 500
		
		setTimeout df.resolve , _delay
		return df.promise()

module.exports = CountDownView