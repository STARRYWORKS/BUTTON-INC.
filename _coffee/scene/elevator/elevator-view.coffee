Config				= require 'config'
Utils					= require 'utils'
PaperStage		= require 'paper-stage'
SoundManager	= require 'sound-manager'

# 
# エレベーターシーンで使用するためのエレベータークラス
# 
class ElevatorView extends paper.Group
	constructor: () ->
		super()
		@sceneConfig = Config.Elevator
		@$window = $(window)

		# インポート
		@openSVG = @importSVG @sceneConfig.SVG.Open
		
		# 起点の再設定
		Utils.transformInit [@, @openSVG]
		Utils.transformInit @openSVG.children

		#扉
		@rightDoor = @openSVG.children[0]
		@leftDoor = @openSVG.children[1]

		# エレベーターサイズが足りなかった場合の上下マスク
		@upMask = new paper.Group()
		@downMask = new paper.Group()
		Utils.transformInit [@upMask, @downMask]
		@upMask.visible = false
		@downMask.visible = false
		@insertChildren 0, [@upMask, @downMask]

		@baseWidth = @bounds.width
		@baseHeight = @bounds.height

		# 開閉稼働領域
		@moveDistance = 60

		@visible = false

	# 
	# アクティブシーン開始時
	# 
	start: ->
		# イベント登録
		@$window.on 'resize.ElevatorView', @onResize
			.trigger 'resize.ElevatorView'

		return

	# 
	# アクティブシーン終了時
	# 
	end:->
		@$window.off 'resize.ElevatorView'
		@visible = false
		# リセット
		@upMask.removeChildren()
		@downMask.removeChildren()


		return

	# 
	# エレベーター表示
	# @param {Object} 完了を返す
	# 
	show: ->
		df = $.Deferred()
		@visible = true
		return df.resolve().promise()

	# 
	# エレベーター開く
	# @param {Object} 完了を返す
	# 
	open: =>
		df = $.Deferred()
		# SE
		_se = Utils.getSE @seList.SE3
		SoundManager.play _se
		
		# Tween
		_rdX = @rightDoor.position.x + @moveDistance
		_ldX = @leftDoor.position.x - @moveDistance
		_delay = .5
		TweenMax.to @rightDoor.position, .4, {
			x: _rdX
			delay: _delay
			ease: Cubic.easeOut
			# onStart: =>
			# 	_se = Utils.getSE @seList.SE1
			# 	SoundManager.play _se
			onComplete: df.resolve
		}
		TweenMax.to @leftDoor.position, .4, {
			x: _ldX
			ease: Cubic.easeOut
			delay: _delay
		}

		return df.promise()

	# 
	# エレベーター閉じる
	# @param {Object} 完了を返す
	# 
	close: =>
		df = $.Deferred()

		#SE 閉まる音
		_se = Utils.getSE @seList.SE1
		SoundManager.play _se

		# Tween
		_rdX = @rightDoor.position.x - @moveDistance
		_ldX = @leftDoor.position.x + @moveDistance
		
		TweenMax.to @rightDoor.position, .3, {
			x: _rdX
			ease: Cubic.easeOut
			onComplete: df.resolve
		}
		TweenMax.to @leftDoor.position, .3, {
			x: _ldX
			ease: Cubic.easeOut
		}
		
		return df.promise()

	# 
	# リサイズ処理
	# 
	onResize: =>
		# 子要素削除
		@upMask.removeChildren()
		@downMask.removeChildren()

		_height = PaperStage.instance.height
		
		@upMask.visible = true
		_h = (_height / 2) + @bounds.y
		_y = @bounds.y - _h
		_size = new paper.Size @bounds.width, _h
		_point = new paper.Point @bounds.x, _y
		_shape = new paper.Shape.Rectangle _point, _size
		_shape.fillColor = "#FFFFFF"
		Utils.transformInit _shape
		@upMask.addChild _shape
		
		@downMask.visible = true
		_y = @bounds.height + @bounds.y
		_h = (_height / 2) - _y
		_size = new paper.Size @bounds.width, _h
		_point = new paper.Point @bounds.x, _y
		_shape = new paper.Shape.Rectangle _point, _size
		_shape.fillColor = "#FFFFFF"
		Utils.transformInit _shape
		@downMask.addChild _shape

		return

module.exports = ElevatorView