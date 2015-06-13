Import mojo
Import config
Import vec
Import sat.vec2
Import rect
Import collidable
Import collidable/rectangularcollidable
Import drawable

Class Block Implements Collidable, Drawable
	Field rect:Rect
	Field collidable:Collidable
	
	Method New(rect:Rect)
		Self.rect = rect
		Self.collidable = New RectangularCollidable(rect)
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method GetCollision(ray: Ray)
		Return collidable.GetCollision(ray)
	End
	
	Method SetColor()
		mojo.SetColor(255.0, 255.0, 255.0)
	End
	
	Method Draw()
		Self.SetColor()
		DrawRect(rect.topLeft.x, rect.topLeft.y, rect.width, rect.height)
	End
	
	Method IsMoving:Bool()
		Return False
	End
	
	Method IsGrappleable:Bool()
		Return False
	End
	
	Method LastMovement:Vec2()
		Return Null
	End
End