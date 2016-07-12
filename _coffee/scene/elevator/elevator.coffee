require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
Btn							= require 'btn'
Base						= require 'base'
LogoGroupView		= require './logo-group-view'
LogoTypeView		= require './logo-type-view'
ElevatorView		= require './elevator-view'
SoundManager		= require 'sound-manager'

# 
# エレベーターシーンクラス
# 
class Elevator extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.Elevator
		@btn = new Btn()
		@btn.soft = 0.2
		@base = new Base()
		@logoGroup = new LogoGroupView @btn, @base
		@logoType = new LogoTypeView()
		@elevator = new ElevatorView()
		@container.addChildren [@logoGroup, @logoType, @elevator]
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@container.position.x = 0
		@addChild @container
		@elevator.start()
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@removeChildren()
		@logoGroup.end()
		@elevator.end()
		return

	#
	# 更新時
	#
	_onUpdate: ->
		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby 
			@btn.update()
		return

	# 
	# スタンバイ時
	# 
	_onStandby: ->
		@btn.up()
		return

	#
	# エフェクト
	#
	_onEffect: ->
		# SE設定
		seList = Utils.getSElist @sceneConfig.SOUND
		@elevator.seList = seList
		@logoGroup.seList = seList

		# ロゴタイプ非表示
		@logoType.hide()

		# エレベーター表示
		@elevator.show()
			#エレベータ閉じる
			.then @elevator.close
			# 少し待つ
			.then -> Utils.wait 300
			# ボタン上に下がる
			.then @logoGroup.goDown
			# エレベータ開く
			.then @elevator.open
			# エレベータ表示
			.then @logoType.show
			# 次シーンへの処理
			.then @swap

		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return

module.exports = Elevator