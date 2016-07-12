Gnav = require './Gnav'
Utils = require 'utils'

# 
# グロナビ
# @param {jquery object} $wrap: ナビのラッパ
# @param {jquery object} $trigger: ナビ展開用トリガ
# @param {jquery object} $hideContents: ナビ展開時に隠す要素
# 
class GnavTop extends Gnav
	#
	# コンストラクタ
	#
	constructor: (@$wrap, @$trigger, @$hideContents) ->
		super(@$wrap, @$trigger, @$hideContents)
		@$wrap.show().velocity({ translateY: '100%' }, { duration: 0 })
		return

	#
	# ナビ展開
	#
	_open: ->
		@wrapHeight = @_setHight()
		@scrollTop = $(window).scrollTop()
		@$wrap.velocity({ translateY: '100%' }, { duration: 0 })
		@$wrap.show()
		@$wrap.velocity({ translateY: '0' }, { duration: @duration, complete: @_onCompletedOpening})
		@$trigger.velocity({ translateY: -@wrapHeight + 95 }, { duration: @duration })
		@$hideContents.velocity({ translateY: -@wrapHeight }, { duration: @duration })
		@$trigger.addClass('close')
		@isOpen = true

	#
	# ナビ展開アニメーション後
	#
	_onCompletedOpening: =>
		@$hideContents.hide()
		$('body,html').off( @scrollEvent, @_onScroll )
		@$wrap.css({ position: 'absolute' })

	#
	# ナビ収束
	#
	_close: ->
		@$hideContents.show()
		@wrapHeight = @_setHight()
		@$wrap.velocity({ translateY: '0' }, { duration: 0 })
		@$wrap.show()
		@$wrap.css({ position: 'fixed' })
		$(window).scrollTop(@scrollTop)
		@$wrap.velocity({ translateY: '100%' }, { duration: @duration, complete: @_onCompletedClosing })
		@$trigger.velocity({ translateY: 0 }, { duration: @duration })
		@$hideContents.velocity({ translateY: 0 }, { duration: @duration })
		@$trigger.removeClass('close')
		@isOpen = false

	#
	# ナビ収束アニメーション後
	#
	_onCompletedClosing: =>
		$('body,html').off( @scrollEvent, @_onScroll )

	_onResize: =>
		clearTimeout(@_timer)
		@_timer = setTimeout(=>
			@wrapHeight = @_setHight()
			if @isOpen
				@$trigger.velocity({ translateY: -@wrapHeight + 95 }, { duration: 0 })

			if Utils.ua.fb || Utils.ua.tw then @$wrap.css({'height': @wrapHeight})
		, 100)

module.exports = GnavTop