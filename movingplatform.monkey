Import collidable
Import sat.vec
Import rect

Class MovingPlatform Implements Collidable
	
	Field width:Float
	Field height:Float
	Field speed:Float
	Field topLeftPos:Vec2
	Field originTopLeftPos:Vec2
	Field prevTopLeftPos:Vec2
	
	Field direction:Vec2
	Field offset:Vec2
	Field maxDistance:Float

	Method New(originTopLeftPos:Vec2, destinationTopLeftPos:Vec2, width:Float, height:Float, speed:Float)
		Self.width = width
		Self.height = height
		Self.speed = speed
		topLeftPos = originTopLeftPos.Clone()
		Self.originTopLeftPos = originTopLeftPos
		prevTopLeftPos = originTopLeftPos.Clone()
		Local movementVec:Vec2 = destinationTopLeftPos.Clone().Sub(originTopLeftPos)
		direction = movementVec.Clone().Normalize()
		maxDistance = movementVec.Length()
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
	
	Method Update()
		prevTopLeftPos = topLeftPos.Clone()
		Local distanceFromOrigin:Vec2  = topLeftPos.Clone().Sub(originTopLeftPos)
		If distanceFromOrigin.Length() >= maxDistance
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
End