# 
# 高さを揃える
# 
class setHieght
	constructor: (target) ->
		@$target = $(target)
		@$window = $(window)
		@$window.on('resize.setHeight', @onResize).trigger('resize.setHeight')

	# 
	# リサイズ処理
	# 
	onResize: =>
		@$target.each((i, target)=>
			$target = $(target)
			$parent = $target.parent()
			_w = $parent.width()
			_h = _w / $target.attr("width") * $target.attr("height")
			$target.css
				"width": "100%"
				"height": _h
		)
		return

module.exports = setHieght
