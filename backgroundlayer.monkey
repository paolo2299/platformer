Import mojo

Class BackgroundLayer
	Field parallaxFactor:Float
	Field image:Image
	Field imageWidth:Float
	Field imageHeight:Float
	Field imageScaleX:Float
	Field imageScaleY:Float
	Field onlyAlongBottom:Bool

	Method New(image:Image, parallaxFactor:Float = 0.0, desiredWidth:Float = -1.0, desiredHeight:Float = -1.0, onlyAlongBottom:Bool=False)
		Self.image = image
		Self.parallaxFactor = parallaxFactor
		Self.onlyAlongBottom = onlyAlongBottom
		If desiredWidth = -1.0
			imageWidth = image.Width()
			imageScaleX = 1.0
		Else
			imageWidth = desiredWidth
			imageScaleX = desiredWidth/image.Width()
		End
		
		If desiredHeight = -1.0
			imageHeight = image.Height()
			imageScaleY = 1.0
		Else
			imageHeight = desiredHeight
			imageScaleY = desiredHeight/image.Height()
		End
	End
End	