Utils = require 'utils'

RADIAN_TO_DEGREE = 180 / Math.PI
DEGREE_TO_RADIAN = Math.PI / 180

# 
# シェイプトゥイーン用クラス
# @param {Object} pathes: 変形情報
# @param {Number} morph: 変形状態
#
class CustomStroke extends paper.Path
	constructor: (path, width, settings)->
		super()
		Utils.transformInit @
		@width = width
		@path = path
		@settings = settings

		@update()
		return

	#
	# 交点を求める
	#
	getCrossingPoint: (point1, radian1, point2, radian2) ->
		a1 = Math.tan(radian1)
		b1 = point1.y + (-point1.x * a1)
		a2 = Math.tan(radian2)
		b2 = point2.y + (-point2.x * a2)
		x = (b1 - b2) / (a2 - a1)
		y = (a2 * b1 - a1 * b2) / (a2 - a1)
		return new paper.Point x, y

	#
	#
	#
	getAnchorPoint: (point,radian1,radian2) ->
		r1 = radian1 + Math.PI * 0.5
		r2 = radian2 - Math.PI * 0.5
		point1 = point.add new paper.Point Math.cos(r1) * @width * 0.5, Math.sin(r1) * @width * 0.5
		point2 = point.add new paper.Point Math.cos(r2) * @width * 0.5, Math.sin(r2) * @width * 0.5
		return @getCrossingPoint point1, radian1, point2, radian2

	#
	# 角丸のアンカーポイントを求める
	#
	getRoundedCornerAnchorPoints: (radius,point,prevPoint,nextPoint) ->
		if radius <= 0 then return [point]
		prevRadian = Math.atan2(prevPoint.y-point.y, prevPoint.x-point.x)
		nextRadian = Math.atan2(nextPoint.y-point.y, nextPoint.x-point.x)
		radianOffset = (prevRadian-nextRadian) * 0.5
		if radianOffset > Math.PI * 0.5 || ( radianOffset < 0 && radianOffset > Math.PI * -0.5 )
			return [point]
		distanceFromPoint = radius / Math.sin(radianOffset)

		radian = nextRadian + radianOffset
		circleCenter = point.add new paper.Point Math.cos(radian)*distanceFromPoint, Math.sin(radian)*distanceFromPoint

		radian1 = prevRadian + Math.PI * 0.5
		point1 = circleCenter.add new paper.Point Math.cos(radian1)*radius, Math.sin(radian1)*radius
		segment1 = new paper.Segment point1
		length = point.subtract(point1).length * 0.55228
		segment1.handleOut = new paper.Point { angle:(prevRadian+Math.PI)*RADIAN_TO_DEGREE, length:length }

		radian2 = nextRadian - Math.PI * 0.5
		point2 = circleCenter.add new paper.Point Math.cos(radian2)*radius, Math.sin(radian2)*radius
		segment2 = new paper.Segment point2
		length = point.subtract(point2).length * 0.55228
		segment2.handleIn = new paper.Point { angle:(nextRadian+Math.PI)*RADIAN_TO_DEGREE, length:length }
		return [segment1,segment2]


	# 
	# 更新
	#
	update: =>
		#
		# 時計回りの外側
		#

		@segments = []

		outerSegments = []

		# 始点から外周までの線
		segment = @path.segments[0]
		nextSegment = @path.segments[1]
		radian = Math.atan2(nextSegment.point.y-segment.point.y, nextSegment.point.x-segment.point.x)
		radian -= Math.PI * 0.5
		strokeSegment = new paper.Segment new paper.Point segment.point.add new paper.Point { angle:radian * RADIAN_TO_DEGREE, length: @width*0.5 }
		outerSegments.push strokeSegment

		# 各ポイントの線
		for i in [1..@path.segments.length-2]
			prevSegment = @path.segments[i-1]
			segment = @path.segments[i]
			nextSegment = @path.segments[i+1]

			if segment.handleIn.length == 0 && segment.handleOut.length == 0
				# 直線の場合
				prevPoint = if prevSegment.handleOut.length == 0 then prevSegment.point else prevSegment.point.add prevSegment.handleOut
				nextPoint = if nextSegment.handleIn.length == 0 then nextSegment.point else nextSegment.point.add nextSegment.handleIn
				prevRadian = Math.atan2(prevPoint.y-segment.point.y, prevPoint.x-segment.point.x)
				nextRadian = Math.atan2(nextPoint.y-segment.point.y, nextPoint.x-segment.point.x)
				strokeSegment = new paper.Segment @getAnchorPoint segment.point, prevRadian, nextRadian
			else
				# 曲線の場合
				prevPoint = prevSegment.point
				if segment.handleIn.length != 0 then prevPoint = segment.point.add segment.handleIn
				else if prevSegment.handleOut.length != 0 then prevPoint = prevSegment.point.add prevSegment.handleOut
				nextPoint = nextSegment.point
				if segment.handleIn.length != 0 then nextPoint = segment.point.add segment.handleIn
				else if nextSegment.handleOut.length != 0 then nextPoint = nextSegment.point.add nextSegment.handleOut

				prevRadian = Math.atan2(prevPoint.y-segment.point.y, prevPoint.x-segment.point.x)
				nextRadian = Math.atan2(nextPoint.y-segment.point.y, nextPoint.x-segment.point.x)
				radian = prevRadian + (nextRadian - prevRadian) * 0.5 + Math.PI * 0.5
				if prevRadian > nextRadian
					radian += Math.PI
				strokeSegment = new paper.Segment new paper.Point segment.point.add new paper.Point { angle:radian * RADIAN_TO_DEGREE, length: @width*0.5 }

			outerSegments.push strokeSegment

		# 終点
		segment = @path.segments[@path.segments.length-1]
		prevSegment = @path.segments[@path.segments.length-2]
		radian = Math.atan2(prevSegment.point.y-segment.point.y, prevSegment.point.x-segment.point.x)
		radian += Math.PI * 0.5
		strokeSegment = new paper.Segment new paper.Point segment.point.add new paper.Point { angle:radian * RADIAN_TO_DEGREE, length: @width*0.5 }
		outerSegments.push strokeSegment

		# ハンドルのコピー
		for i in [0...outerSegments.length]
			segment = @path.segments[i]
			strokeSegment = outerSegments[i]

			if i > 0 && segment.handleIn.length != 0 
				prevSegment = @path.segments[i-1]
				prevStrokeSegment = outerSegments[i-1]
				distance = segment.point.getDistance(prevSegment.point)
				strokeDistance = strokeSegment.point.getDistance(prevStrokeSegment.point)
				ratio = strokeDistance / distance
				strokeSegment.handleIn = new paper.Point {angle: segment.handleIn.angle, length: segment.handleIn.length*ratio}

			if i < @path.segments.length-1 && segment.handleOut != 0
				nextSegment = @path.segments[i+1]
				distance = segment.point.getDistance(nextSegment.point)
				strokeDistance = segment.point.getDistance(nextSegment.point)
				ratio = strokeDistance / distance
				strokeSegment.handleOut = new paper.Point {angle: segment.handleOut.angle, length: segment.handleOut.length*ratio}


		#
		# 時計回りの内側
		#

		innerSegments = []
		
		# 始点
		segment = @path.segments[@path.segments.length-1]
		nextSegment = @path.segments[@path.segments.length-2]
		radian = Math.atan2(nextSegment.point.y-segment.point.y, nextSegment.point.x-segment.point.x)
		radian -= Math.PI * 0.5
		strokeSegment = new paper.Segment new paper.Point segment.point.add new paper.Point { angle:radian * RADIAN_TO_DEGREE, length: @width*0.5 }
		innerSegments.unshift strokeSegment
		
		# 各ポイントの線
		for i in [@path.segments.length-2..1]
			prevSegment = @path.segments[i-1]
			segment = @path.segments[i]
			nextSegment = @path.segments[i+1]

			if segment.handleIn.length == 0 && segment.handleOut.length == 0
				# 直線の場合
				prevPoint = if prevSegment.handleOut.length == 0 then prevSegment.point else prevSegment.point.add prevSegment.handleOut
				nextPoint = if nextSegment.handleIn.length == 0 then nextSegment.point else nextSegment.point.add nextSegment.handleIn
				prevRadian = Math.atan2(prevPoint.y-segment.point.y, prevPoint.x-segment.point.x)
				nextRadian = Math.atan2(nextPoint.y-segment.point.y, nextPoint.x-segment.point.x)
				strokeSegment = new paper.Segment @getAnchorPoint segment.point, nextRadian, prevRadian
			else
				# 曲線の場合
				prevPoint = prevSegment.point
				if segment.handleIn.length != 0 then prevPoint = segment.point.add segment.handleIn
				else if prevSegment.handleOut.length != 0 then prevPoint = prevSegment.point.add prevSegment.handleOut
				nextPoint = nextSegment.point
				if segment.handleIn.length != 0 then nextPoint = segment.point.add segment.handleIn
				else if nextSegment.handleOut.length != 0 then nextPoint = nextSegment.point.add nextSegment.handleOut

				prevRadian = Math.atan2(prevPoint.y-segment.point.y, prevPoint.x-segment.point.x)
				nextRadian = Math.atan2(nextPoint.y-segment.point.y, nextPoint.x-segment.point.x)
				radian = prevRadian + (nextRadian - prevRadian) * 0.5 - Math.PI * 0.5
				if prevRadian > nextRadian
					radian += Math.PI
				strokeSegment = new paper.Segment new paper.Point segment.point.add new paper.Point { angle:radian * RADIAN_TO_DEGREE, length: @width*0.5 }

			innerSegments.unshift strokeSegment

		# 終点
		segment = @path.segments[0]
		prevSegment = @path.segments[1]
		radian = Math.atan2(prevSegment.point.y-segment.point.y, prevSegment.point.x-segment.point.x)
		radian += Math.PI * 0.5
		strokeSegment = new paper.Segment new paper.Point segment.point.add new paper.Point { angle:radian * RADIAN_TO_DEGREE, length: @width*0.5 }
		innerSegments.unshift strokeSegment
		
		# ハンドルのコピー
		for i in [0...innerSegments.length]
			segment = @path.segments[i]
			strokeSegment = innerSegments[i]

			if i > 0 && segment.handleOut.length != 0 
				prevSegment = @path.segments[i-1]
				prevStrokeSegment = innerSegments[i-1]
				distance = segment.point.getDistance(prevSegment.point)
				strokeDistance = strokeSegment.point.getDistance(prevStrokeSegment.point)
				ratio = strokeDistance / distance
				strokeSegment.handleIn = new paper.Point {angle: segment.handleOut.angle, length: segment.handleOut.length*ratio}

			if i < @path.segments.length-1 && segment.handleIn != 0
				nextSegment = @path.segments[i+1]
				distance = segment.point.getDistance(nextSegment.point)
				strokeDistance = segment.point.getDistance(nextSegment.point)
				ratio = strokeDistance / distance
				strokeSegment.handleOut = new paper.Point {angle: segment.handleIn.angle, length: segment.handleIn.length*ratio}


		#
		# 角丸処理
		#
		for i in [0...outerSegments.length]
			strokeSegment = outerSegments[i]
			if i > 0 then prevPoint = outerSegments[i-1].point
			else prevPoint = @path.segments[0].point
			if i < outerSegments.length - 1 then nextPoint = outerSegments[i+1].point
			else nextPoint = @path.segments[@path.segments.length-1].point
			r = if i >= @settings.length then 0 else @settings[i][0]
			points = @getRoundedCornerAnchorPoints( r, strokeSegment.point, prevPoint, nextPoint)
			for point in points 
				@add point

		for i in [innerSegments.length-1..0]
			strokeSegment = innerSegments[i]
			if i > 0 then prevPoint = innerSegments[i-1].point
			else prevPoint = @path.segments[0].point
			if i < innerSegments.length - 1 then nextPoint = innerSegments[i+1].point
			else nextPoint = @path.segments[@path.segments.length-1].point
			r = if i >= @settings.length then 0 else @settings[i][1]
			points = @getRoundedCornerAnchorPoints( r, strokeSegment.point, nextPoint, prevPoint)
			for point in points 
				@add point

		# @add @segments[0].clone()

		return

module.exports = CustomStroke