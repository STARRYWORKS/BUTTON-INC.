Config								= require 'config'
PaperStage						= require 'paper-stage'
MorpahblePath					= require 'morphable-path'
Easing								= require './easeing'
###
auth: Kimura
data: 2016/05/20
###

class Main
	constructor: () ->
		@$window = $(window)
		@$canvas = $("#" + Config.Canvas.paper)
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')	
		@valArr = []
		@svgArr = []
		@pathArr = []
		@tweenArr = []

		# paper.js 設定
		@paper = new PaperStage(@$canvas)

		# イベント設定
		@$window.on('resize', @onResize).trigger('resize')

		# update
		paper.view.onFrame = @onUpdate
		# test
		$("#SVG1").on("blur", @onBlur)
		$(".js-play").on("click", @onPlay)
		$(".js-stop").on("click", @onStop)

	onBlur: (event)=>
		val = $(event.target).val()
		if !val? then return
		svg = @paper.stage.importSVG val
		return

	onPlay: =>
		# ステージの要素削除
		@paper.stage.removeChildren()

		@valArr = []
		@svgArr = []
		@pathArr = []
		@tweenArr = []
		@type = parseInt($("#Type").val())
		
		# 入力値チェック
		$("textarea").each((index,elm)=>
			if $(elm).val() == ""
				return false
			@valArr.push $(elm).val()
		)

		# 最低2個入っていないと終了
		if @valArr.length < 2 then return false

		# svg情報配列に保存
		for val, i in @valArr
			@svgArr.push @paper.stage.importSVG val
			@svgArr[i].remove()

		# SVG1のpathを基準にMorphablePathを設定
		for child,i in @svgArr[0].children
			pathArr = []
			for svg in @svgArr
				pathArr.push svg.children[i]

			@pathArr.push new MorpahblePath pathArr
			@pathArr[i].stroleWidth = 1
			@pathArr[i].strokeColor = "#000000"
			@paper.stage.addChild @pathArr[i]

		# tween設定
		for i in [0...@svgArr.length-1]
			$param = $(".ajust-box").eq(i)
			_easeing1 = $param.find("#Svg#{i+1}Easing1").val()
			_easeing2 = $param.find("#Svg#{i+1}Easing2").val()
			_d = if $param.find("input").val() != "" then parseFloat($param.find("input").val()) else 1
			_e = Easing[_easeing1 + "." + _easeing2]

			for path,j in @pathArr
				if i == 0 
					tl =  new TimelineMax({
						repeat : if @type == 1 then 0 else -1
						yoyo   : if @type == 3 then true else false
					})
					@tweenArr.push tl


				@tweenArr[j].to path, _d / 1000, {
					morph: i + 1
					ease: _e
				}
				# if i == 0
				# 	@tweenArr[j].to path, _d / 1000, {
				# 		morph: 1
				# 		ease: _e
				# 	}
				# else if i == 1
				# 	@tweenArr[j].to path, _d / 1000, {
				# 		morph: 2
				# 		ease: _e
				# 	}
				# else if i == 2
				# 	@tweenArr[j].to path, _d / 1000, {
				# 		morph: 3
				# 		ease: _e
				# 	}

		return false

	# 
	# 
	# 
	onStop:=>
		if @tweenArr.length > 0
			for tween in @tweenArr
				if tween.paused()
					tween.play()
					$(".js-stop a").text("STOP")
				else
					tween.pause()
					$(".js-stop a").text("RESTART")
		return

	# 
	# メインupdate
	# 
	onUpdate: =>
		TWEEN.update()
		@paper.update()
	
		@context.clearRect(0,0,@stageWidth,@stageHeight)
		paper.view.update(true)

		@ctxScale = 1
		@drawBasePosition(@paper.stage)

		if @pathArr.length > 0
			for path in @pathArr
				path.update()

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


