Import sat.vec2
Import mojo
Import animation
Import hazard
Import movement.backandforth

'TODO this seems a bit weird - is there a better pattern?
Function GetEater:Hazard(position:Vec2, radius:Float)
	Local origin := position.Clone().Add(New Vec2(0.0, -35.0))
	Local destination := position.Clone().Add(New Vec2(0.0, 35.0))
	Local movement:Moving = New BackAndForth(origin, destination, position.Clone(), 1, 1.0)
	Local collidable:CollidableAndMoving = New MovingCircularCollidable(movement, radius)
	Local image:Image = LoadImage("images/mysteryforest/Other/monster/sprite.png", 50, 50, 25, Image.MidHandle)
	Local animation:Animation = New Animation(0, 3, 2)
	Local scaleX:Float = (25.0 / radius) * 2.3
	Local scaleY:Float = (25.0 / radius) * 2.3
	Return New Hazard(collidable, image, scaleX, scaleY, animation)
End