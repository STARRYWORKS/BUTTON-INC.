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
		@wrapHeight		= @$wrap.height()
		@scrollEvent	= 'wheel mousewheel DOMMouseScroll touchmove.noScroll'
		@scrollTop		= $(window).scrollTop()
		@duration			= 100

		@$wrap.velocity({ translateY: -@wrapHeight }, { duration: 0 })

		@$trigger.on( 'click', @_onClickTrigger )

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
		console.log 'open'
		@wrapHeight = @$wrap.height()
		@scrollTop = $(window).scrollTop()
		@$wrap.velocity({ translateY: -@wrapHeight }, { duration: 0 })
		@$wrap.show()
		@$wrap.velocity({ translateY: '0' }, { duration: @duration, complete: @_onCompletedOpening})
		@$hideContents.velocity({ translateY: @wrapHeight }, { duration: @duration })
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
		console.log 'close'
		@$hideContents.show()
		@wrapHeight = @$wrap.height()
		@$wrap.velocity({ translateY: '0' }, { duration: 0 })
		@$wrap.show()
		@$wrap.css({ position: 'fixed' })
		$(window).scrollTop(@scrollTop)
		@$wrap.velocity({ translateY: -@wrapHeight }, { duration: @duration, complete: @_onCompletedClosing })
		@$hideContents.velocity({ translateY: 0 }, { duration: @duration })
		@isOpen = false

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
