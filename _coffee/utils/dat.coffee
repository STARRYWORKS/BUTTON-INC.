PaperStage = require '../stage/paper-stage'
# 
# デバッグ用オプション
# 
class DatOption
	constructor: ()->
		@all = false
		@layer = false
		@group = false
		@other = false
		@Ancor = PaperStage.HIDE
		return

# 
# デバッグ用コンソールクラス
# @param {Object} main: メインクラス
# 
class DatGUI extends dat.GUI
	@ID = 'DatGUI'
	constructor: (main) ->
		super()
		@main = main
		@paper = @main.paper
		@datOption = new DatOption()
		@domElement.id = DatGUI.ID
		$("##{DatGUI.ID}").css({"padding-top": 50})

		@pivotFolder = @addFolder('Pivot')
		@main.pivotShowAll = @datOption.all
		@pivotFolder.add(@datOption, 'all').onChange ()=>
			@main.pivotShowAll = @datOption.all
			return

		@main.pivotShowLayer = @datOption.layer
		@pivotFolder.add(@datOption, 'layer').onChange ()=>
			@main.pivotShowLayer = @datOption.layer
			return

		@main.pivotShowGroup = @datOption.group
		@pivotFolder.add(@datOption, 'group').onChange ()=>
			@main.pivotShowGroup = @datOption.group
			return

		@main.pivotShowOther = @datOption.other
		@pivotFolder.add(@datOption, 'other').onChange ()=>
			@main.pivotShowOther = @datOption.other
			return

		# @pivotFolder.open()
		
		@paper.anchorShowStatus = @datOption.Ancor
		@add(@datOption, 'Ancor',{'hide':PaperStage.HIDE, 'show':PaperStage.SHOW,'showFull':PaperStage.SHOW_ALL}).onChange ()=>
			@paper.anchorShowStatus = @datOption.Ancor
			return


module.exports = DatGUI