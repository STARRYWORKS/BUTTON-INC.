module.exports = {}

# 
# ペーパーオブジェクト起点調整
# @param {Object or Array} object: paper.jsのオブジェクト
# @param {Boolean} pivotReset: trueならpivotも変更
# 
module.exports.transformInit = (object, pivotReset = true)->
	if object instanceof Array
		for obj in object
			obj.transformContent = false
			if pivotReset then obj.pivot = new paper.Point 0, 0
	else
		object.transformContent = false
		if pivotReset then object.pivot = new paper.Point 0, 0
	return

# 
# importしたSVGの子要素を取得
# @param {Object} SVG: SVG情報
# @param {Number} no: 取得する子要素の番号 -1の場合配列で返す
# @returns {Object or Array}: 指定したパスもしくは全てのパス情報
# 
module.exports.getSvgChild = (SVG, num = 0)->
	svg = paper.project.activeLayer.importSVG SVG
	svg.remove()
	if num != -1
		path = svg.children[num]
	else
		path = svg.children

	return path

# 
# 指定時間待機
# @param {Number} time: 待機時間(ms)
# 
module.exports.wait = (time)->
	df = $.Deferred()
	setTimeout df.resolve, time
	return df.promise()


# 
# 正規分布
# 
module.exports.normRand = (m, s) ->
	a = 1 - Math.random()
	b = 1 - Math.random()
	c = Math.sqrt(-2 * Math.log(a))
	if 0.5 - Math.random() > 0
		return c * Math.sin(Math.PI * 2 * b) * s + m
	else
		return c * Math.cos(Math.PI * 2 * b) * s + m


# 
# イースターエッグ用モード管理
# 
module.exports.secretMode = false

# 
# SE取得
# @prams [Array] seList: SEリスト
# @returns {String} SEを1つ返す
# 
NORMAL = "NORMAL"
SECRET = "SECRET"
module.exports.getSE = (seList) ->
	seList = if !module.exports.secretMode then seList[NORMAL] else seList[SECRET]
	return seList[Math.floor(Math.random() * seList.length)]


# 
# SEグループ取得
# @prams [Object] sound: シーンのSOUNDコンフィグ
# @returns {array} SEリストグループを返す
# 
module.exports.getSElist = (sound) ->
	soundLength = Object.keys(sound).length
	num = Math.floor(Math.random() * soundLength)
	return sound["SE_GROUP#{num}"]


# 
# アプリ内ブラウザ判定
# 
module.exports.ua = ((u)->
	return {
		fb:(u.indexOf("fban/fbios;fbav") != -1)
		tw:(u.indexOf("twitter") != -1)
	}
)(window.navigator.userAgent.toLowerCase())
