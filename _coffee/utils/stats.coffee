# 
# Stats表示用クラス
# 
class StatsView
	constructor: () ->
		@stats = new Stats()
		@stats.showPanel( 0 ) # 0: fps, 1: ms, 2: mb, 3+: custom
		@$stats = $(@stats.dom)
		document.body.appendChild( @stats.dom )
		@$stats.css({
			"top": "auto"
			"left": "auto"
			"right": 20
			"bottom": 20
		})

	update: ->
		@stats.begin()
		# monitored code goes here
		@stats.end()
		return

module.exports = StatsView