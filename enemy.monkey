Import sat.vec2
Import mojo
Import animation
Import hazard
Import movement.backandforth

'TODO this seems a bit weird - is there a better pattern?
Function GetEater:Hazard(movement:Moving, radius:Float)
	Local collidable:CollidableAndMoving = New MovingCircularCollidable(movement, radius)
	Local image:Image = LoadImage("images/mysteryforest/Other/monster/sprite.png", 50, 50, 25, Image.MidHandle)
	Local animation:Animation = New Animation(0, 3, 2)
	Local scaleX:Float = (25.0 / radius) * 2.3
	Local scaleY:Float = (25.0 / radius) * 2.3
	Return New Hazard(collidable, image, scaleX, scaleY, animation)
End