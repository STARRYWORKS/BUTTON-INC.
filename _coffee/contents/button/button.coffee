Utils			= require 'utils'
Touch			= require 'touch'
Config		= require './config'
BtnView		= require './btn-view'
Base			= require 'base'
LogoType	= require 'logo-type'

# 
# フッターロゴ
# 
class Button
	constructor: () ->
		@$canvas = $("#Button")
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')
		@isDown = false
		# タッチイベントイニシャライズ
		Touch.init(@canvas)

		# ボタン作成
		@init()

		# イベント登録
		Touch.sharedInstance.addEventListener(Touch.DOWN, @onDown)
		Touch.sharedInstance.addEventListener(Touch.UP, @onUp)

		# update
		paper.view.onFrame = @onUpdate

	# 
	# イニシャライズ
	# 
	init: ->
		paper.setup(@canvas)
		# ルートレイヤ設定
		@stage = paper.project.activeLayer
		Utils.transformInit @stage

		# コンテナー作成
		@container = new paper.Group()
		Utils.transformInit @container
		@stage.addChild @container

		# ボタンセット
		@btn = new BtnView()
		# @btn.soft = 1
		@base = new Base()
		@btnGroup = new paper.Group [@btn,@base]
		Utils.transformInit @btnGroup
		@logoType = new LogoType()
		@container.addChildren [@btnGroup, @logoType]
		@container.position.x = 8 #中央配置対応

		# コンテナのスケール設定
		_offset = .025
		@stageScale = @$canvas.width() / @container.bounds.width - _offset
		@stage.scaling.set @stageScale, @stageScale
		@stage.position.set @$canvas.width() / 2, @$canvas.height() / 2

		return


	# 
	# メインupdate
	# 
	onUpdate: =>
		TWEEN.update()
		paper.view.update(true)
		if @isDown
			@btnGroup.position.x = Math.cos(new Date().getTime() * 0.05) * 2
	# 
	# マウス/タッチ ダウン
	# 
	onDown: (event) =>
		touch = event.target
		point = touch.point
		if @hitTest(point)
			@isDown = true
			@btn.down()
		return

	# 
	# マウス/タッチ アップ
	# 
	onUp: (event) =>
		if !@isDown then return
		@isDown = false
		@btnGroup.position.set 0, 0
		touch = event.target
		point = touch.point
		hit = @hitTest(point)
		@btn.up(hit)
		return

	# 
	# クリック範囲チェック
	# @param {Object} point: クリック位置
	# 
	hitTest: (point)->
		minX = @$canvas.offset().left
		maxX = minX + @$canvas.width()
		minY = @$canvas.offset().top
		maxY = minY + @$canvas.height()
		hit = if minX <= point.x && maxX >= point.x && minY <= point.y && maxY >= point.y then true else false
		return hit

		
	
module.exports = Button