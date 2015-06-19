Import collision
Import ray
Import sat.vec

Interface Collidable
	Method GetCollision:Collision(ray:Ray)
End

Interface Blocky Extends Collidable	
	Method IsHazard:Bool()

	Method IsGoal:Bool()

	Method IsGrappleable:Bool()
	
	Method IsMoving:Bool()
	
	Method LastMovement:Vec2()
	
	Method Rect:Rect()
End
