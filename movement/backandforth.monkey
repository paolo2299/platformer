Import moving
Import sat.vec2

Const GOING_FORWARDS = 1
Const GOING_BACKWARDS = -1

Class BackAndForth Implements Moving
	Field position:Vec2
	Field originalPosition:Vec2
	Field speed:Float
	Field previousPosition:Vec2
	Field direction:Int = GOING_FORWARDS

	Field movementNormal:Vec2
	
	Field origin:Vec2
	Field destination:Vec2
	Field midPoint:Vec2
	Field maxDistanceFromMidpoint: Float
	
	Method New(origin:Vec2, destination:Vec2, originalPosition:Vec2, speed:Float)
		Self.origin = origin
		Self.destination = destination
		Local movementVec:Vec2 = destination.Clone().Sub(origin)
		Local midpointVec:Vec2 = movementVec.Clone().Scale(0.5)
		maxDistanceFromMidpoint = midpointVec.Length()
		midPoint = origin.Clone().Add(midpointVec)
		movementNormal = movementVec.Normalize()
		
		Self.originalPosition = originalPosition
		Self.speed = speed
		Reset()
	End
	
	Method Reset()
		position = originalPosition.Clone()
		direction = GOING_FORWARDS
		previousPosition = position.Clone()
	End
	
	Method Update()
		previousPosition = position.Clone()
		Local distanceFromMidpoint:Float  = position.Clone().Sub(midPoint).Length()
		If distanceFromMidpoint > maxDistanceFromMidpoint
			'go in the opposite direction
			direction = direction * -1
		End
		Local movement:Vec2 = movementNormal.Clone().Scale(direction * speed)
		position.Add(movement)
	End
	
	Method Position:Vec2()
		Return position
	End
	
	Method LastMovement:Vec2()
		Return position.Clone().Sub(previousPosition)
	End
End