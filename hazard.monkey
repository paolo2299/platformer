Import sat.vec2
Import sat
Import mojo
Import utilities
Import enemy
Import collision
Import drawable
Import collidableandmoving
Import collidable.circularcollidable

'TODO - this class could be Sprite instead of Hazard? Or separate the two?

Class Hazard Implements Collidable, Drawable
	Field collidable:CollidableAndMoving
	Field image:Image
	Field scaleX:Float
	Field scaleY:Float
	Field animation:Animation
	
	Method New(collidable:CollidableAndMoving, image:Image, scaleX:Float = 1.0, scaleY:Float = 1.0, animation:Animation = Null)
		Self.collidable = collidable
		Self.image = image
		Self.scaleX = scaleX
		Self.scaleY = scaleY
		Self.animation = animation
	End
	
	Method GetCollision:Collision(ray:Ray)
		Return collidable.GetCollision(ray)
	End
	
	Method GetCollision:Collision(rect:Rect)
		Return collidable.GetCollision(rect)
	End
	
	'TODO implement Updateable Interface
	Method Update()
		collidable.Update()
	End
	
	'TODO implement Resettable Interface
	Method Reset()
		collidable.Reset()
		'TODO animation.Reset()
	End
	
	Method Draw()
		Local position:Vec2 = collidable.Position()
		If animation = Null
			DrawImage(image, position.x, position.y, 0.0, scaleX, scaleY)
		Else
			DrawImage(image, position.x, position.y, 0.0, scaleX, scaleY, animation.GetFrame())
		End
	End
End
