Import block

Class GroundBlock Extends Block

	Field image:Image
	Field imageScaleX:Float
	Field imageScaleY:Float
	Field imageOffsetX:Float
	Field imageOffsetY:Float

	Method New(rect:Rect, image:Image, imageOffsetX:Float = 0.0, imageOffsetY:Float = 0.0)
		Super.New(rect)
		Self.image = image
		imageScaleX = rect.width / 128.0
		imageScaleY = rect.height / 128.0
		Self.imageOffsetX = imageOffsetX
		Self.imageOffsetY = imageOffsetY
	End
	
	Method IsGrappleable:Bool()
		Return True
	End
	
	Method Draw()
		mojo.SetColor(255.0, 255.0, 255.0)
		DrawImage(image, rect.topLeft.x + imageOffsetX, rect.topLeft.y + imageOffsetY, 0.0, imageScaleX, imageScaleY)
		'DrawRect(rect.topLeft.x, rect.topLeft.y, rect.width, rect.height)
	End
End