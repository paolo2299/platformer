Import sat.vec2
Import sat
Import mojo
Import utilities
Import enemy
Import collision
Import drawable

'TODO circular hazard has too many responsibilities - should actaully be circularcollidable and implement the bare minimum for collidable?

Class CircularHazard Implements Collidable, Drawable
	Field position:Vec2
	Field originalPos:Vec2
	Field radius:Float
	Field circle:Circle
	Field collisionResponse:Response
	Field enemy:Enemy

	Method New(position:Vec2, radius:Float)
		enemy = New Enemy(position, radius)
		Self.position = position
		originalPos = position.Clone()
		Self.radius = radius
		circle = New Circle(position.x, position.y, radius)
		collisionResponse = New Response()
	End
	
	Method GetCollision:Collision(ray:Ray)
		'PrintVec("ray origin", ray.origin)
		'PrintVec("ray destination", ray.destination)
		'PrintVec("collidable hazard position", position)
		'Print("collidable hazard radius: " + radius)
		collisionResponse.Clear()
		If SAT.TestPolygonCircle(ray.ToPolygon(), circle, collisionResponse)
			'TODO - do we want to bother actually calculating the collision vector here? We never use it...for now return null
			Return New Collision(Self, Null)
		Else
			Return Null
		End
	End

	Method Draw()
		'SetColor(255.0, 0.0, 0.0)
		'DrawCircle(position.x, position.y, radius)
		enemy.Draw()
	End
End