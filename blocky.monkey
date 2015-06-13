Import ray
Import rect

Interface Blocky
	Method GetCollision:BlockyCollision(ray:Ray)

	Method IsHazard:Bool()

	Method IsGoal:Bool()

	Method IsGrappleable:Bool()
	
	Method IsMoving:Bool()
	
	Method LastMovement:Vec2()
	
	Method Rect:Rect()
End