Import collidablehazard
Import sat.vec2
Import sat
Import mojo
Import utilities
Import animation
Import enemy

Class CircularHazard Implements CollidableHazard
	Field position:Vec2
	Field radius:Float
	Field circle:Circle
	Field collisionResponse:Response
	Field image:Image
	Field animation:Animation
	Field enemy:Enemy

	Method New(position:Vec2, radius:Float)
		Self.enemy = New Enemy(position, radius)
		Self.position = position
		Self.radius = radius
		Self.image = image
		Self.animation = animation
		circle = New Circle(position.x, position.y, radius)
		collisionResponse = New Response()
	End
	
	Method CollidesWithRay:Bool(ray:Ray)
		'PrintVec("ray origin", ray.origin)
		'PrintVec("ray destination", ray.destination)
		'PrintVec("collidable hazard position", position)
		'Print("collidable hazard radius: " + radius)
		collisionResponse.Clear()
		If SAT.TestPolygonCircle(ray.ToPolygon(), circle, collisionResponse)
			Return True
		Else
			Return False
		End
	End
	
	Method Draw()
		'SetColor(255.0, 0.0, 0.0)
		'DrawCircle(position.x, position.y, radius)
		enemy.Draw()
	End
End