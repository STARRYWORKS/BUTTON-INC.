require 'extension'
Config					= require 'config'
Utils						= require 'utils'
SceneBase				= require 'scene-base'
BtnView					= require './btn-view'
BaseView				= require './base-view'
GhostView				= require './ghost-view'
LogoTypeView		= require './logo-type-view'
LightsVeiw			= require './lights-view'
SoundManager		= require 'sound-manager'

# 
# プリンシーンクラス
# 
class Ghost extends SceneBase
	# 
	# 親クラスのinitメソッドから呼ばれる
	# 
	_onInit: ->
		@lightsVeiw = new LightsVeiw()
		@btn = new BtnView()
		@base = new BaseView()
		@logoType = new LogoTypeView()
		@ghost = new GhostView()
		@container.addChildren [@lightsVeiw, @btn, @base, @logoType, @ghost]
		
		return

	# 
	# アクティブシーンになる時
	# 
	_onStart: ()->
		@container.position.x = 0
		@lightsVeiw.start()
		@addChild @container
		return

	# 
	# 非アクティブシーンになる時
	# 
	_onEnd: =>

		@removeChildren()
		@lightsVeiw.end()
		@ghost.end()
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
		# ボタン非表示
		@btn.hide()
		@base.hide()
		# ロゴタイプは破線にする
		@logoType.dashed()
		# 部屋暗く
		@lightsVeiw.off 500
			# 目表示
			.then () => (@ghost.eyeShow 300)
			# 全体表示
			.then () => (@ghost.allShow 300)
			# お化け鬼メーション
			.then @ghost.floating
			.then => Utils.wait 200
			# ボタン表示
			.then @btn.show
			.then @base.show
			.then @logoType.solid
			# 部屋明るく
			.then ()=> (@lightsVeiw.on 500)
			.then @swap

		return

	#
	# シーン移行
	#
	_onSwapping: () =>
		@end()
		return

module.exports = Ghost