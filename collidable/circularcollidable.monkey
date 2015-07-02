Import mojo
Import utilities
Import enemy
Import collidable
Import collidableandmoving

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

Class MovingCircularCollidable Implements CollidableAndMoving
	Field movement:Moving
	Field radius:Float
	
	Method New(movement:Moving, radius:Float)
		Self.movement = movement
		Self.radius = radius
	End
	
	Method GetCollision:Collision(ray:Ray)
		Return New CircularCollidable(movement.Position(), radius).GetCollision(ray)
	End
	
	Method Update()
		Return movement.Update()
	End
	
	Method LastMovement:Vec2()
		Return movement.LastMovement()
	End
	
	Method Reset()
		Return movement.Reset()
	End
	
	Method Position:Vec2()
		Return movement.Position()
	End
End
