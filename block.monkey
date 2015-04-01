Import mojo
Import config
Import vec
Import sat.vec2
Import rect
Import collidable

Class Block Implements Collidable
	Field rect:Rect
	
	Method New(rect:Rect)
		Self.rect = rect
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method CollisionRect:Rect()
		Return rect
	End
	
	Method SetColor()
		mojo.SetColor(0.0, 0.0, 255.0)
	End
	
	Method Draw()
		Self.SetColor()
		DrawRect(rect.topLeft.x, rect.topLeft.y, rect.width, rect.height)
	End
	
	Method IsMoving:Bool()
		Return False
	End
	
	Method LastMovement:Vec2()
		Return Null
	End
End