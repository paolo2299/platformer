Import collidable
Import rect
Import sat.vec2

Interface Drawable
	Method Draw()
End

Interface Collectible Extends Collidable, Drawable
	Method Type:String()
	Method Collect()
	Method Reset()
End

Const COLLECTIBLE_GRAPPLE:String = "grapple"

Class CollectibleGrapple Implements Collectible
	Field position:Vec2
	Field width:Float
	Field height:Float
	Field collisionRect: Rect
	
	Field collected:Bool = False

	Method New(position:Vec2, width:Float, height:Float)
		Self.position = position
		Self.width = width
		Self.height = height
		collisionRect = New Rect(position.x, position.y, width, height)
	End

	Method Type:String()
		Return COLLECTIBLE_GRAPPLE
	End
	
	Method Collect()
		collected = True
	End
	
	Method Reset()
		collected = False
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method IsGrappleable:Bool()
		Return False
	End
	
	Method IsMoving:Bool()
		Return False
	End
	
	Method CollisionRect:Rect()
		Return collisionRect
	End
	
	Method LastMovement:Vec2()
		Return Null
	End
	
	Method Draw()
		If Not collected
			SetColor(0.0,0.0,255.0)
			DrawRect(position.x, position.y, width, height)
		End
	End
End