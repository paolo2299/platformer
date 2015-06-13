Import mojo
Import utilities
Import enemy
Import collidable
Import drawable

Class CircularCollidable Implements Collidable
	Field circle:Circle
	Field collisionResponse:Response
	
	Method New(position:Vec2, radius:Float)
		circle = New Circle(position.x, position.y, radius)
		collisionResponse = New Response()
	End
	
	Method GetCollision:Collision(ray:Ray)
		collisionResponse.Clear()
		If SAT.TestPolygonCircle(ray.ToPolygon(), circle, collisionResponse)
			'TODO - do we want to bother actually calculating the collision vector here? We never use it...for now return null
			Return New Collision(Null)
		Else
			Return Null
		End
	End
End
