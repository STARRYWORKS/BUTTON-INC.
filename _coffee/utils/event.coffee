###
auth: Kimura
data: 2016/01/16
###

#
# SimpleEventDispatcherクラス
#

class SimpleEventDispatcher
	constructor: () ->
		@listeners = {}
	
	addEventListener: (name,callback,args=[]) ->
		if !@listeners? then @listeners = {}
		if !@listeners[name]? then @listeners[name] = []
		# TODO: 重複リスナーチェック
		@listeners[name].push( new SimpleEventListener(name,callback,args) )
		return

	removeEventListener: (name,callback) ->
		if !@listeners? || !@listeners[name]? then return
		if ( callback == null )
			@listeners[name] = []
			return
		while ( (i = @indexOfCallback(name,callback)) >= 0 )
			@listeners[name].splice(i,1)
		return

	dispatchEvent: (name,data={}) ->
		if !@listeners? || !@listeners[name]? then return
		event = new SimpleEvent(this,name,data)
		for listener in @listeners[name]
			listener.dispatchEvent(event)
		return

	indexOfCallback: (name,callback) ->
		for listener,i in @listeners?[name]
			if listener.callback == callback then return i
		return -1

class SimpleEvent
	constructor: (target,name,data={}) ->
		@target = target
		@name = name
		@data = data
		return


class SimpleEventListener
	constructor: (name,callback,args=null) ->
		@name = name
		@callback = callback
		@args = args
		return

	dispatchEvent: (event) ->
		if typeof(@callback) != 'function' then return
		if @args && @args.length > 0
			@callback.apply(null, @args)
		else
			@callback.apply(null, [event])
		return

module.exports = SimpleEventDispatcher