Import mojo
Import config
Import vec
Import sat.vec2
Import rect
Import collidable
Import collidable.rectangularcollidable
Import drawable
Import blocky

Class Block Implements Blocky, Drawable
	Field rect:Rect
	Field collidable:Collidable
	
	Method New(rect:Rect)
		Self.rect = rect
		Self.collidable = New RectangularCollidable(rect)
	End
	
	Method Rect:Rect()
		Return rect
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method GetCollision:BlockyCollision(ray: Ray)
		Local collision:Collision = collidable.GetCollision(ray)
		If collision <> Null
			Return New BlockyCollision(collision.ray, Self)
		End
		Return Null
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