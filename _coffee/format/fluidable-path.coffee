require 'extension'

RADIAN_TO_DEGREE = 180 / Math.PI
DEGREE_TO_RADIAN = Math.PI / 180
# 
# パスの輪郭を液体っぽくアニメーションさせるクラス
# @param {Object} path: アニメーションするパス
#
class FluidablePath extends paper.Path
	constructor: (path)->
		super()
		@path = path
		@fluidPath = new paper.Path()
		@fluidPath.remove()
		@flexibility = 1
		@speed = 0.01
		@amplitude = 1
		@numWaves = 5
		@smoothFactor = 0.3
		@fixEnds = true # 線の端を固定するフラグ
		@setPath(@path)


	#
	# パスを変更
	#
	setPath: (path) ->
		@path = path
		@segments = []
		@fluidPath.segments = []
		@fluidRadians = []

		# アンカーをコピー
		for segment in @path.segments
			@add segment.clone()
			@fluidPath.segments.push segment.clone()

		# 揺らす方向を計算
		for segment,i in @segments

			radian = 0
			if i <= 0
				if segment.handleOut? && !segment.handleOut.isZero()
					radian = segment.handleOut.angleInRadians + Math.PI * 0.5
				else
					radian = segment.point.getAngleInRadians(@segments[i+1].point) + Math.PI * 0.5
			else if i >= @segments.length - 1
				if segment.handleIn? && !segment.handleIn.isZero()
					radian = segment.handleIn.angleInRadians - Math.PI * 0.5
				else
					radian = segment.point.getAngleInRadians(@segments[i-1].point) - Math.PI * 0.5
			else
				if segment.handleIn? && !segment.handleIn.isZero()
					radianL = segment.handleIn.angleInRadians
				else
					radianL = segment.point.getAngleInRadians(@segments[i-1].point)
				if segment.handleOut? && !segment.handleOut.isZero()
					radianR = segment.handleOut.angleInRadians
				else
					radianR = segment.point.getAngleInRadians(@segments[i+1].point)

				radian = radianL + (radianR-radianL) * 0.5

			@fluidRadians.push(radian)

		#
		for segment,i in @fluidPath.segments
			segment.handleIn.x = segment.handleIn.y = 0
			segment.handleOut.x = segment.handleOut.y = 0


		@update()
		return


	#
	# 前後のアンカーポイントの位置を元に線がスムースになるようにコントロールポイントを調整する
	#
	smoothSegment: (segment,left,right,factor) ->
		distanceL = if left? then segment.point.getDistance(left) else 0
		distanceR = if right? then segment.point.getDistance(right) else 0

		radian = 0
		if left? && right?
			radianL = segment.point.getAngleInRadians(left)
			radianR = segment.point.getAngleInRadians(right)
			radian = radianL + (radianR-radianL) * 0.5 + Math.PI * 0.5
		else if left?
			radian = segment.point.getAngleInRadians(left)
		else if right?
			radian = segment.point.getAngleInRadians(right)


		if left? && right?
			if radian < Math.PI * -0.5 || radian > Math.PI * 0.5 then distanceR *= -1
			else distanceL *= -1

		segment.handleIn.x = Math.cos(radian) * distanceL * factor
		segment.handleIn.y = Math.sin(radian) * distanceL * factor
		segment.handleOut.x = Math.cos(radian) * distanceR * factor
		segment.handleOut.y = Math.sin(radian) * distanceR * factor
		return

	# 
	# データ更新
	#
	update: ()->

		now = new Date().getTime()
		phase = now * @speed

		# console.log 'phase:'+phase+' speed:'+@speed

		for fluidSegment,i in @fluidPath.segments
			baseSegment = @path.segments[i]
			# phaseを元に移動距離を計算
			distance = Math.sin(phase+i/@fluidPath.segments.length*@numWaves*Math.PI*2) * @amplitude
			radian = @fluidRadians[i]
			if !@closed && @fixEnds && (i == 0 || i == @fluidPath.segments.length-1) then distance = 0
			# 
			fluidSegment.point.x = baseSegment.point.x + Math.cos(radian) * distance
			fluidSegment.point.y = baseSegment.point.y + Math.sin(radian) * distance
			fluidSegment.handleIn.x = baseSegment.handleIn.x
			fluidSegment.handleIn.y = baseSegment.handleIn.y
			fluidSegment.handleOut.x = baseSegment.handleOut.x
			fluidSegment.handleOut.y = baseSegment.handleOut.y

		# fluidSegmentのスムース化
		# @fluidPath.smooth()
		# for fluidSegment,i in @fluidPath.segments
		# 	left = if i > 0 then @fluidPath.segments[i-1].point else null
		# 	right = if i < @fluidPath.segments.length-1 then @fluidPath.segments[i+1].point else null
		# 	@smoothSegment(fluidSegment,left,right,@smoothFactor)

		# Flexibilityに応じて各ポイントを計算
		for fluidSegment,i in @fluidPath.segments
			baseSegment = @path.segments[i]
			@segments[i].point.x = baseSegment.point.x + (fluidSegment.point.x - baseSegment.point.x) * @flexibility
			@segments[i].point.y = baseSegment.point.y + (fluidSegment.point.y - baseSegment.point.y) * @flexibility
			@segments[i].handleIn.x = baseSegment.handleIn.x + (fluidSegment.handleIn.x - baseSegment.handleIn.x) * @flexibility
			@segments[i].handleIn.y = baseSegment.handleIn.y + (fluidSegment.handleIn.y - baseSegment.handleIn.y) * @flexibility
			@segments[i].handleOut.x = baseSegment.handleOut.x + (fluidSegment.handleOut.x - baseSegment.handleOut.x) * @flexibility
			@segments[i].handleOut.y = baseSegment.handleOut.y + (fluidSegment.handleOut.y - baseSegment.handleOut.y) * @flexibility


module.exports = FluidablePath