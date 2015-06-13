Import sat.vec2
Import sat
Import mojo
Import utilities
Import enemy
Import collision
Import drawable
Import collidable.circularcollidable

'TODO - this class could be Sprite instead of Hazard? Or separate the two?
Class Hazard Implements Collidable, Drawable
	Field collidable:Collidable
	Field position:Vec2
	Field image:Image
	Field scaleX:Float
	Field scaleY:Float
	Field animation:Animation

	Method New(position:Vec2, collidable:Collidable, image:Image, scaleX:Float = 1.0, scaleY:Float = 1.0, animation:Animation = Null)
		Self.position = position
		Self.collidable = collidable
		Self.image = image
		Self.scaleX = scaleX
		Self.scaleY = scaleY
		Self.animation = animation
	End
	
	Method GetCollision:Collision(ray:Ray)
		Return collidable.GetCollision(ray)
	End

	Method Draw()
		If animation = Null
			DrawImage(image, position.x, position.y, 0.0, scaleX, scaleY)
		Else
			DrawImage(image, position.x, position.y, 0.0, scaleX, scaleY, animation.GetFrame())
		End
	End
End
