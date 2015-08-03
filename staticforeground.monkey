Import mojo

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
End