SimpleEventDispatcher = require 'event'

###
auth: Kimura
data: 2016/01/16
###

#
# Touchクラス
#

class Touch extends SimpleEventDispatcher
	@DOWN	= "down"
	@MOVE	= "move"
	@UP		= "up"

	@sharedInstance = null
	@init: (target) ->
		@sharedInstance = new Touch(target)
		return

	constructor: (target) ->
		@$window = $(window)
		@$target = $(target)
		
		@supportTouch = `'ontouchend' in document`
		@EVENT_TOUCHSTART = if (@supportTouch) then 'touchstart' else 'mousedown'
		@EVENT_TOUCHMOVE = if (@supportTouch) then 'touchmove' else 'mousemove'
		@EVENT_TOUCHEND = if (@supportTouch) then 'touchend' else 'mouseup'

		@$window.on(@EVENT_TOUCHSTART, @onDown)
		@downPoint = new paper.Point 0,0
		@point = new paper.Point 0,0
		@vector = new paper.Point 0,0
		return

	onDown: (event) =>
		@$window.on(@EVENT_TOUCHEND, @onUp)
		@$window.on(@EVENT_TOUCHMOVE, @onMove)
		position = @getPosition event
		@downPoint.x = @point.x = position.pageX
		@downPoint.y = @point.y = position.pageY
		@dispatchEvent(Touch.DOWN)
		return

	onMove: (event) =>
		position = @getPosition event
		@point.x = position.pageX
		@point.y = position.pageY
		@vector.x = position.pageX - @downPoint.x
		@vector.y = position.pageY - @downPoint.y
		@dispatchEvent(Touch.MOVE)
		return

	onUp: (event) =>
		@$window.off(@EVENT_TOUCHEND, @onUp)
		@$window.off(@EVENT_TOUCHMOVE, @onMove)
		
		@vector.x = @point.x - @downPoint.x
		@vector.y = @point.y - @downPoint.y
		@dispatchEvent(Touch.UP)
		return

	getPosition: (event)=>
		original = event.originalEvent
		if (typeof original.touches != 'undefined')
			return original.touches[0]
		return event

module.exports = Touch