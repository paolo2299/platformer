Import sat.vec2
Import mojo
Import animation

Class Enemy
	Field position:Vec2
	Field image:Image
	Field animation:Animation
	Field scaleX:Float
	Field scaleY:Float
	
	Method New(position:Vec2, radius)
		Self.position = position
		Self.image = LoadImage("images/mysteryforest/Other/monster/sprite.png", 50, 50, 25, Image.MidHandle)
		Self.animation = New Animation(0, 3, 2)
		scaleX = (25.0 / radius) * 2.3
		scaleY = (25.0 / radius) * 2.3
	End
	
	Method Draw()
		DrawImage(image, position.x, position.y, 0.0, scaleX, scaleY, animation.GetFrame())
	End
End