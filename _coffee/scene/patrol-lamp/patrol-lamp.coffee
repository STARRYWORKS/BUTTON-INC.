require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
Base						= require 'base'
LogoTypeView		= require './logo-type-view'
CarView					= require './car-view'
SoundManager		= require 'sound-manager'

# 
# パトランプシーンクラス
# 
class PatrolLamp extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@sceneConfig = Config.PatrolLamp
		
		@btn = new BtnView()
		@btn.soft = 0.2
		@base = new Base()
		@logoType = new LogoTypeView()
		@car = new CarView([@btn,@base])
		@container.addChildren [@car, @logoType]

		# 次シーンのロゴタイプ不要
		@nextContainer.removeChildren 2
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@container.position.x = 0
		@addChild @container

		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>
		@removeChildren()
		@btn.end()
		@car.end()
		@logoType.end()

		return

	#
	# 更新時
	#
	_onUpdate: ->
		# タッチ中もしくはスタンバイ中
		if @mode == SceneBase.Mode.Touching || @mode == SceneBase.Mode.Standby 
			@btn.update()

		@car.update()
		return

	# 
	# スタンバイ時
	# 
	_onStandby: ->
		@btn.up()
		return

	# 
	# マウス/タッチ アップ
	# 
	_onTouchUp: ->
		if @mode == SceneBase.Mode.Standby 
			@btn?.up()

	#
	# エフェクト
	#
	_onEffect: ->
		# SE
		_se = Utils.getSE @sceneConfig.SOUND.SE1
		Utils.wait(120).then -> SoundManager.play _se

		
		# 基に戻して赤くする
		@btn.change()
			# タイヤ,ランプ表示
			.then @car.change
			# 少し待つ
			.then => Utils.wait 200
			# ランプ回る
			.then @car.siren
			# ロゴ移動
			.then @logoType.move
			# ボタンに戻す
			.then @car.changeReset
			.then @btn.hide
			.then @car.down
			.then @btn.grow
			.then @swap
		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return
module.exports = PatrolLamp