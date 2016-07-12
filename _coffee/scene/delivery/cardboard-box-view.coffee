Config				= require 'config'
Utils					= require 'utils'
MorphablePath	= require 'morphable-path'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
# 宅配シーンで使用するためのダンボールクラス
# 
class CardboardBoxView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Delivery

		@visible = false
		Utils.transformInit @

		@box1 = new paper.Group()
		@box2 = new paper.Group()
		@box3 = new paper.Group()
		@box4 = new paper.Group()
		Utils.transformInit [@box1, @box2, @box3, @box4]
		@addChildren [@box1, @box2, @box3, @box4]

		box1_1 = Utils.getSvgChild @sceneConfig.SVG.Box1_1, -1
		box2_1 = Utils.getSvgChild @sceneConfig.SVG.Box2_1, -1
		box2_2 = Utils.getSvgChild @sceneConfig.SVG.Box2_2, -1
		box2_3 = Utils.getSvgChild @sceneConfig.SVG.Box2_3, -1
		box3_1 = Utils.getSvgChild @sceneConfig.SVG.Box3_1, -1
		box3_2 = Utils.getSvgChild @sceneConfig.SVG.Box3_2, -1
		box4_1 = Utils.getSvgChild @sceneConfig.SVG.Box4_1, -1
		box4_2 = Utils.getSvgChild @sceneConfig.SVG.Box4_2, -1
		
		# box1
		for path, i in box1_1
			Utils.transformInit path
			path.strokeWidth = Config.LINE_WIDTH
			path.strokeColor = @sceneConfig.COLOR.BOX_PATH
			path.fillColor = @sceneConfig.COLOR.BOX_FILL
			if i > 2 then path.fillColor = @sceneConfig.COLOR.TAPE_FILL

		@box1.addChildren box1_1

		# box2
		for path, i in box2_1
			_path = new MorphablePath [path, box2_2[i], box2_3[i]]
			_path.strokeWidth = Config.LINE_WIDTH
			_path.strokeColor = @sceneConfig.COLOR.BOX_PATH
			_path.fillColor = @sceneConfig.COLOR.BOX_FILL
			if i > 4 then _path.fillColor = @sceneConfig.COLOR.TAPE_FILL
			_path.visible = false
			@box2.addChild _path

		# box3
		for path, i in box3_1
			_path = new MorphablePath [path, box3_2[i]]
			_path.strokeWidth = Config.LINE_WIDTH
			_path.strokeColor = @sceneConfig.COLOR.BOX_PATH
			_path.fillColor = @sceneConfig.COLOR.BOX_FILL
			_path.fillColor = @sceneConfig.COLOR.BOX_FILL
			if i == 4 || i == 5 then _path.fillColor = @sceneConfig.COLOR.TAPE_FILL
			_path.visible = false
			@box3.addChild _path

		# box4
		for path, i in box4_1
			_path = new MorphablePath [path, box4_2[i]], 0
			_path.strokeWidth = Config.LINE_WIDTH
			_path.strokeColor = @sceneConfig.COLOR.BOX_PATH
			_path.fillColor = @sceneConfig.COLOR.BOX_FILL
			if i == 5 || i == 6 then _path.fillColor = @sceneConfig.COLOR.TAPE_FILL
			else if i == 1 then _path.fillColor = Config.COLOR.BTN_FILL
			else if i == 2 || i == 3 then _path.fillColor = Config.COLOR.BASE_FILL
			_path.visible = false
			@box4.addChild _path

	# 
	# アクティブシーンになる時
	# 
	start: ->
		$(window).on 'resize.Delivery', @onResize
		@isEffected = false
		@position.y -= PaperStage.instance.height * 0.6
		@visible = true
		return

	# 
	# 非アクティブシーンになる時
	# 
	end: ->
		$(window).off 'resize.Delivery'
		@visible = false
		@opacity = 1

		@box1.visible = true

		for path in @box2.children
			path.update 0
			path.visible = false

		for path in @box3.children
			path.update 0
			path.visible = false

		for path in @box4.children
			path.update 0
			path.visible = false
		return

	# 
	# エフェクト
	# @returns {Object} 完了を返す
	# 
	effect: =>
		df = new $.Deferred()
		tl = new TimelineMax()
		@isEffected = true

		# ダンボール送られてくる
		tl.to @position, .45, {
			y: 0
			delay: .1
			ease: Expo.easeIn
			onComplete: =>
				# SE ダンボール音
				_se = Utils.getSE @sceneConfig.SOUND.SE2
				SoundManager.play _se
		}

		delay = 1.0
		@box1.visible = true
		@box2.visible = true
		@box3.visible = true
		@box4.visible = true
		# box1非表示 → box2表示 → モーフィング → 非表示
		$.each @box2.children, (i, path)=>
			path.visible = false
			TweenMax.to path, .25 ,{
				morph: 2
				onUpdate: path.update
				ease: Expo.easeInOut
				delay: delay
				onStart: =>
					if @box1.visible then @box1.visible = false
					path.visible = true
			}

		# box3表示 → モーフィング → 非表示
		$.each @box3.children, (i, path)=>
			path.visible = false
			TweenMax.to path, .25 ,{
				morph: 1
				onUpdate: path.update
				ease: Expo.easeInOut
				delay: delay + .2
				onStart: =>
					if @box2.visible then @box2.visible = false
					path.visible = true
			}

		# box4表示 → モーフィング
		$.each @box4.children, (i, path)=>
			path.visible = false
			TweenMax.to path, .25 ,{
				morph: 1
				onUpdate: path.update
				ease: Expo.easeIn
				delay: delay + .45
				onStart: =>
					if @box3.visible then @box3.visible = false
					path.visible = true
			}

		# ダンボールが消えるアニメーション
		tl.to @, 0, {
			opacity: 0
			delay: delay + .3
			onComplete: df.resolve
		}

		return df.promise()


	# 
	# リサイズ処理
	# 
	onResize: =>
		if @isEffected then return
		@position.y -= PaperStage.instance.height * 0.6
		
		return


module.exports = CardboardBoxView