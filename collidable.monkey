Import rect
Import sat.vec

Interface Collidable

	Method CollisionRect:Rect()
		
	Method IsHazard:Bool()
	
	Method IsGoal:Bool()
	
	Method IsMoving:Bool()
	
	Method LastMovement:Vec2()
End