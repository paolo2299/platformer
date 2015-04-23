Import block
Import tileimage

Class HazardBlock Extends Block

	Field tileImage:TileImage

	Method New(rect:Rect, tileImage:TileImage)
		Super.New(rect)
		Self.tileImage = tileImage
	End
	
	Method IsHazard:Bool()
		Return True
	End

	Method SetColor()
		mojo.SetColor(255.0, 0.0, 0.0)
	End
	
	Method Draw()
		mojo.SetColor(255.0, 255.0, 255.0)
		DrawImage(tileImage.image, rect.topLeft.x + tileImage.offset.x, rect.topLeft.y + tileImage.offset.y, tileImage.rotation, tileImage.scale.x, tileImage.scale.y, tileImage.frame)
	End
End