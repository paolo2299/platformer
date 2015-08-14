Import mojo
Import config

Class StaticForeground
	Field image: Image
	Field levelNumber:Int
	Field scale: Float
	Field msg:String
	
	Method New(levelNumber, tileWidth)
		Self.levelNumber = levelNumber		
		Self.image = LoadImage("images/levels/level" + levelNumber + ".png")
		scale = tileWidth / 16.0
	End
	
	Method Draw()
		DrawImage(image, 0.0, 0.0, 0.0, scale, scale)
	End
	
	Method Draw(posY:Int, maxWidth:Float, maxHeight:Float)
		scale = maxWidth * 1.0 / image.Width()
		If image.Height() * scale > maxHeight
			scale = maxHeight * 1.0 / image.Height()
		End
		Local posX:Float = (VIRTUAL_WINDOW_WIDTH - scale * image.Width()) / 2
		DrawImage(image, posX, posY, 0.0, scale, scale)
	End
End