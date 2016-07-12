Config = require 'config'
Localizables = require './../../utils/localizables'
PaperStage = require 'paper-stage'
Btn = require 'btn'
Base = require 'base'
LogoType = require 'logo-type'


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

		
		# ボタン
		@btn = new Btn()
		@paper.stage.addChild @btn

		# 土台
		@base = new Base()
		@paper.stage.addChild @base

		

		# イベント設定
		@$window.on('resize', @onResize).trigger('resize')
		@btn.morph = 0
		TweenMax.to @btn, .5, {
			morph: 2
			repeat: -1
			yoyo: true
			onUpdate: =>
				@btn.stroke.update @btn.morph
				@btn.fill.update @btn.morph
		}

		# update
		paper.view.onFrame = @onUpdate


	# 
	# メインupdate
	# 
	onUpdate: =>
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

