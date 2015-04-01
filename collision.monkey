Import block
Import sat.vec
Import sat.response
Import ray

Class Collision
	Field collidable:Collidable
	Field ray:Ray
	
	Method New(collidable: Collidable, ray:Ray)
		Self.collidable = collidable
		Self.ray = ray
	End
	
	Method TopOrBottomOfBlock:Bool()
		Local dest:Vec2 = ray.destination
		Local rect:Rect = collidable.CollisionRect()
		If (dest.y = rect.topLeft.y) Or (dest.y = rect.botLeft.y)
			Return True
		End
		Return False
	End
End

Function DetectCollision:Collision(ray: Ray, collidable:Collidable)
	'TODO move this to Collision class?
	Local collisionRect:Rect = collidable.CollisionRect()
	Local response:Response = New Response()
	Local origin:Vec2 = ray.origin
	Local destination:Vec2 = ray.destination
	Local rayPoly:Polygon = ray.ToPolygon()
	If SAT.TestPolygonPolygon(rayPoly, collisionRect.ToPolygon(), response)
		'Find point of intersection with left/right of tile
		If destination.x = origin.x
			If destination.y > origin.y
				Local collisionPoint:Vec2 = New Vec2(origin.x, collisionRect.topLeft.y)
				Return  New Collision(collidable, New Ray(origin, collisionPoint))
			Else
				Local collisionPoint:Vec2 = New Vec2(origin.x, collisionRect.botLeft.y)
				Return  New Collision(collidable, New Ray(origin, collisionPoint))
			End
		Elseif destination.y = origin.y
			If destination.x > origin.x
				Local collisionPoint:Vec2 = New Vec2(collisionRect.topLeft.x, origin.y)
				Return  New Collision(collidable, New Ray(origin, collisionPoint))
			Else
				Local collisionPoint:Vec2 = New Vec2(collisionRect.topRight.x, origin.y)
				Return  New Collision(collidable, New Ray(origin, collisionPoint))
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
				Return  New Collision(collidable, New Ray(origin, collisionPoint))
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
				Return  New Collision(collidable, New Ray(origin, collisionPoint))
			End
		End
	End
	Return Null
End

Function RayCastCollision:Collision(origin:Vec2, direction:Vec2, maxLength:Float)
	Local offset:Vec2 = direction.Clone().Scale(maxLength)
	Local destination:Vec2 = origin.Clone().Add(offset)		 
	
	Return RayCastCollision(New Ray(origin, destination))
End