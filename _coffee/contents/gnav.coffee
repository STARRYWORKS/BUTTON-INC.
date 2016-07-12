Utils = require 'utils'

# 
# グロナビ
# @param {jquery object} $wrap: ナビのラッパ
# @param {jquery object} $trigger: ナビ展開用トリガ
# @param {jquery object} $hideContents: ナビ展開時に隠す要素
# 
class Gnav
	#
	# コンストラクタ
	#
	constructor: (@$wrap, @$trigger, @$hideContents) ->
		@isOpen				= false
		@wrapHeight		= @_setHight()
		@scrollEvent	= 'wheel mousewheel DOMMouseScroll touchmove.noScroll'
		@scrollTop		= $(window).scrollTop()
		@duration			= 300

		@$wrap.show().velocity({ translateY: "-100%" }, {duration: 0})

		@$trigger.on( 'click', @_onClickTrigger )
		$(window).on( 'resize', @_onResize ).

		return

	#
	# トリガクリック時
	#
	_onClickTrigger: (e) =>
		$('body,html').on( @scrollEvent, @_onScroll )
		@$wrap.css({ position: 'fixed' })
		if @isOpen then @_close() else @_open()

	#
	# ナビ展開
	#
	_open: ->
		@wrapHeight = @_setHight()
		@scrollTop = $(window).scrollTop()
		@$wrap.velocity({ translateY: '-100%' }, { duration: 0 })
		@$wrap.show()
		@$wrap.velocity({ translateY: '0' }, { duration: @duration, complete: @_onCompletedOpening})
		@$trigger.velocity({ translateY: @wrapHeight - 80 }, { duration: @duration })
		@$hideContents.velocity({ translateY: @wrapHeight }, { duration: @duration })
		@$trigger.addClass('close')
		@isOpen = true
		if Utils.ua.fb || Utils.ua.tw
			$('body,html').scrollTop(0)
			$(window).on 'touchmove.noScroll', (e)-> e.preventDefault()

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
		@$wrap.velocity({ translateY: '-100%' }, { duration: @duration, complete: @_onCompletedClosing })
		@$trigger.velocity({ translateY: 0 }, { duration: @duration })
		@$hideContents.velocity({ translateY: 0 }, { duration: @duration })
		@$trigger.removeClass('close')
		@isOpen = false
		if Utils.ua.fb || Utils.ua.tw then $(window).off 'touchmove.noScroll'

	#
	# ナビ収束アニメーション後
	#
	_onCompletedClosing: =>
		$('body,html').off( @scrollEvent, @_onScroll )

	#
	# スクロールキャンセル
	#
	_onScroll: (e) =>
		return false

	#
	# リサイズ時
	#
	_onResize: =>
		clearTimeout(@_timer)
		@_timer = setTimeout(=>
			@wrapHeight = @_setHight()
			if @isOpen
				@$trigger.velocity({ translateY: @wrapHeight - 80 }, { duration: 0 })

			if Utils.ua.fb || Utils.ua.tw
				@$wrap.css({'height': @wrapHeight})
		, 100)

	# 
	# 高さ取得
	# @returns {Number}: 画面の高さ(Twitter, Facebook アプリ内ブラウザの時は - 100px)
	# 
	_setHight: ->
		return _height = if !Utils.ua.fb && !Utils.ua.tw then $(window).height() else $(window).height() - 100

module.exports = Gnav