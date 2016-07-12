Utils = require 'utils'
# 
# シェイプトゥイーン用クラス
# @param {Object} pathes: 変形情報
# @param {Number} morph: 変形状態
#
class MorphablePath extends paper.Path
	constructor: (pathes, morph = 0)->
		@pathes = pathes
		@morph = morph

		Utils.transformInit @

		# パス起点設定
		for path in @pathes
			Utils.transformInit path

		# アンカーをコピー
		segments = []
		for segmant in @pathes[0].segments
			segments.push segmant.clone()

		# 作成
		super(segments)

		# アンカーポイントの数をチェック
		@checkVertices()

		# パスのクローズ状態を確認
		if @pathes[0].closed
			@closed = true
		@update()

		return

	# 
	# 全てのパスのアンカーポイントの数が同じでなければエラーを返す
	# 
	checkVertices:->
		for path in @pathes
			if @segments.length != path.segments.length
				alert "アンカーポイントの数が違います"
				throw "アンカーポイントの数が違います"
				break
		return

	# 
	# シェイプトゥイーン
	# @param {Number} morph: 変形状態
	#
	update: (morph = @morph)=>
		if @pathes.length <= 1 then return
		if morph != @morph then @morph = morph
		fromIndex = Math.floor(@morph)
		if fromIndex < 0 then fromIndex = 0
		else if fromIndex > @pathes.length - 2 then fromIndex = @pathes.length - 2
		toIndex = fromIndex + 1
		_from = @pathes[fromIndex]
		_to = @pathes[toIndex]
		p = @morph - fromIndex

		for segment, i in @segments
			segment.point.x = _from.segments[i].point.x + (_to.segments[i].point.x - _from.segments[i].point.x) * p + @position.x
			segment.point.y = _from.segments[i].point.y + (_to.segments[i].point.y - _from.segments[i].point.y) * p + @position.y
			segment.handleIn.x = _from.segments[i].handleIn.x + (_to.segments[i].handleIn.x - _from.segments[i].handleIn.x) * p
			segment.handleIn.y = _from.segments[i].handleIn.y + (_to.segments[i].handleIn.y - _from.segments[i].handleIn.y) * p
			segment.handleOut.x = _from.segments[i].handleOut.x + (_to.segments[i].handleOut.x - _from.segments[i].handleOut.x) * p
			segment.handleOut.y = _from.segments[i].handleOut.y + (_to.segments[i].handleOut.y - _from.segments[i].handleOut.y) * p

			if p <= 0
				if _from.segments[i].handleIn.x == 0 && _from.segments[i].handleIn.y == 0
					segment.handleIn.x = _from.segments[i].handleIn.x
					segment.handleIn.y = _from.segments[i].handleIn.y
				if _from.segments[i].handleOut.x == 0 && _from.segments[i].handleOut.y == 0
					segment.handleOut.x = _from.segments[i].handleOut.x
					segment.handleOut.y = _from.segments[i].handleOut.y
			if p >= 1
				if _to.segments[i].handleIn.x == 0 && _to.segments[i].handleIn.y == 0
					segment.handleIn.x = _to.segments[i].handleIn.x
					segment.handleIn.y = _to.segments[i].handleIn.y
				if _to.segments[i].handleOut.x == 0 && _to.segments[i].handleOut.y == 0
					segment.handleOut.x = _to.segments[i].handleOut.x
					segment.handleOut.y = _to.segments[i].handleOut.y

		return

	#
	# リセット処理
	#
	reset: ->
		@morph = 0
		@update()
		return

module.exports = MorphablePath