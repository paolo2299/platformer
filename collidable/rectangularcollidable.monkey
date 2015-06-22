Import mojo
Import utilities
Import enemy
Import collidable
Import drawable

Class RectangularCollidable Implements Collidable
	Field collisionRect:Rect

	Method New(rect:Rect)
		collisionRect = rect
	End
	
	Method GetCollision:Collision(ray:Ray)
		If ray.Length() = 0
			Return Null
		End

		Local response:Response = New Response()
		Local origin:Vec2 = ray.origin
		Local destination:Vec2 = ray.destination
		Local rayPoly:Polygon = ray.ToPolygon()
		If SAT.TestPolygonPolygon(rayPoly, collisionRect.ToPolygon(), response)
			If destination.x = origin.x
				'If tangential then it doesn't count
				If (destination.x = collisionRect.topLeft.x Or destination.x = collisionRect.topRight.x) 
					Return Null
				End
				If destination.y > origin.y
					Local collisionPoint:Vec2 = New Vec2(origin.x, collisionRect.topLeft.y)
					Return  New Collision(Self, New Ray(origin, collisionPoint))
				Else
					Local collisionPoint:Vec2 = New Vec2(origin.x, collisionRect.botLeft.y)
					Return  New Collision(Self, New Ray(origin, collisionPoint))
				End
			Elseif destination.y = origin.y
				'If tangential then it doesn't count
				If (destination.y = collisionRect.topLeft.y Or destination.y = collisionRect.botLeft.y) 
					Return Null
				End
				If destination.x > origin.x
					Local collisionPoint:Vec2 = New Vec2(collisionRect.topLeft.x, origin.y)
					Return  New Collision(Self, New Ray(origin, collisionPoint))
				Else
					Local collisionPoint:Vec2 = New Vec2(collisionRect.topRight.x, origin.y)
					Return  New Collision(Self, New Ray(origin, collisionPoint))
				End
			Else
				'Check left/right of tile
				'Which side of the tile do we need to check?
				Local verticalX:Float = collisionRect.topLeft.x
				If destination.x < origin.x
					verticalX = collisionRect.topRight.x
				End
				Local raySlope:Float = (destination.y - origin.y) / (destination.x - origin.x)
				Local rayIntersect:Float = origin.y - raySlope * origin.x
						
				'At what y value does the ray cross the vertical line?
				Local crossPosition:Float = raySlope * verticalX + rayIntersect
				Local clamped:Float = Clamp(crossPosition, collisionRect.topLeft.y, collisionRect.botLeft.y)
				If clamped = crossPosition
					Local collisionPoint:Vec2 = New Vec2(verticalX, crossPosition)
					Return  New Collision(Self, New Ray(origin, collisionPoint))
				End 
				'Check top/bottom of tile
				'Which side of the tile do we need to check?
				Local horizontalY:Float = collisionRect.botLeft.y
				If destination.y > origin.y
					horizontalY = collisionRect.topLeft.y
				End
						
				'At what x value does the ray cross the horizontal line?
				crossPosition = (horizontalY - rayIntersect)/raySlope
				clamped = Clamp(crossPosition, collisionRect.topLeft.x, collisionRect.topRight.x)
				If clamped = crossPosition
					Local collisionPoint:Vec2 = New Vec2(crossPosition, horizontalY)
					Return  New Collision(Self, New Ray(origin, collisionPoint))
				End
			End
		End
		Return Null
	End
End