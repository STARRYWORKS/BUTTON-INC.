# 
# デバッグ用オプション
# 
class DatOption
	constructor: ()->
		@anchor = false
		@flexibility = 1
		@speed = 0.01
		@amplitude = 1
		@numWaves = 10
		@fixEnds = true
		return

# 
# デバッグ用コンソールクラス
# @param {Array} fulidables: 対象オブジェクト
# 
class DatGUI extends dat.GUI
	@ID = 'DatGUI'
	constructor: (fulidables) ->
		super()
		@datOption = new DatOption()
		@domElement.id = DatGUI.ID
		@fulidables = fulidables
		$("##{DatGUI.ID}").css({"padding-top": 50})

		console.log fulidables

		@add(@datOption, 'flexibility', 0, 1).onChange ()=>
			@fulidables[0].flexibility = @datOption.flexibility
			for fulidable in @fulidables
				fulidable.flexibility = @datOption.flexibility

		@add(@datOption, 'speed', 0.001, 0.05).onChange ()=>
			for fulidable in @fulidables
				fulidable.speed = @datOption.speed

		@add(@datOption, 'amplitude', 0, 10).onChange ()=>
			for fulidable in @fulidables
				fulidable.amplitude = @datOption.amplitude

		@add(@datOption, 'numWaves', 0, 30).onChange ()=>
			for fulidable in @fulidables
				fulidable.numWaves = @datOption.numWaves

		@add(@datOption, 'fixEnds').onChange ()=>
			for fulidable in @fulidables
				fulidable.fixEnds = @datOption.fixEnds

module.exports = DatGUI