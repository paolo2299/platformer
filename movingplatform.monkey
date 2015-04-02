Import collidable
Import sat.vec
Import rect

Class MovingPlatform Implements Collidable
	
	Field width:Float
	Field height:Float
	Field speed:Float
	Field originalTopLeftPos:Vec2
	Field topLeftPos:Vec2
	Field prevTopLeftPos:Vec2
	Field midpointTopLeftPos:Vec2
	
	Field originalDirection:Vec2
	Field direction:Vec2
	Field offset:Vec2
	Field maxDistance:Float

	Method New(originTopLeftPos:Vec2, destinationTopLeftPos:Vec2, width:Float, height:Float, speed:Float)
		originalTopLeftPos = originTopLeftPos
		Self.width = width
		Self.height = height
		Self.speed = speed
		topLeftPos = originTopLeftPos.Clone()
		prevTopLeftPos = originTopLeftPos.Clone()
		Local movementVec:Vec2 = destinationTopLeftPos.Clone().Sub(originTopLeftPos)
		direction = movementVec.Clone().Normalize()
		originalDirection = direction.Clone()
		Local midpointVec:Vec2 = movementVec.Clone().Scale(0.5)
		maxDistance = midpointVec.Length()
		midpointTopLeftPos = originTopLeftPos.Clone().Add(midpointVec)
		PrintVec("originTopLeftPos", originTopLeftPos)
		PrintVec("destinationTopLeftPos", destinationTopLeftPos)
		PrintVec("midpointTopLeftPos", midpointTopLeftPos)
		Print "maxDistance" + maxDistance
	End
	
	Method IsMoving:Bool()
		Return True
	End
	
	Method LastMovement:Vec2()
		Return offset
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method IsGrappleable:Bool()
		Return True
	End
	
	Method Reset()
		topLeftPos = originalTopLeftPos.Clone()
		prevTopLeftPos = originalTopLeftPos.Clone()
		direction = originalDirection.Clone()
		offset = New Vec2(0.0, 0.0)
	End
	
	Method Update()
		prevTopLeftPos = topLeftPos.Clone()
		Local distanceFromMidpoint:Vec2  = topLeftPos.Clone().Sub(midpointTopLeftPos)
		If distanceFromMidpoint.Length() > maxDistance
			'go in the opposite direction
			direction.Scale(-1)
		End
		Local movement:Vec2 = direction.Clone().Scale(speed)
		topLeftPos.Add(movement)
		offset = topLeftPos.Clone().Sub(prevTopLeftPos)
	End
	
	Method PrevMove:Vec2()
		Return topLeftPos.Clone().Sub(prevTopLeftPos)
	End
	
	Method CollisionRect:Rect()
		Return New Rect(topLeftPos.x, topLeftPos.y, width, height)
	End
	
	Method Draw()
		SetColor()
		DrawRect(topLeftPos.x, topLeftPos.y, width, height)
	End

	Method SetColor()
		mojo.SetColor(0.0, 0.0, 255.0)
	End
	
	Method PrintVec(desc: String, v:Vec2)
		Print desc + ": " + v.x + "," + v.y
	End
End