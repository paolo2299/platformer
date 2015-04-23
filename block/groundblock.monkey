Import block
Import tileimage

Class GroundBlock Extends Block

	Field tileImage:TileImage

	Method New(rect:Rect, tileImage:TileImage)
		Super.New(rect)
		Self.tileImage = tileImage
	End
	
	Method IsGrappleable:Bool()
		Return True
	End
	
	Method Draw()
		mojo.SetColor(255.0, 255.0, 255.0)
		DrawImage(tileImage.image, rect.topLeft.x + tileImage.offset.x, rect.topLeft.y + tileImage.offset.y, tileImage.rotation, tileImage.scale.x, tileImage.scale.y, tileImage.frame)
		'DrawRect(rect.topLeft.x, rect.topLeft.y, rect.width, rect.height)
	End
End