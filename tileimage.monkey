Import mojo
Import sat.vec2

Class TileImage
	Field image:Image
	Field offset:Vec2 = New Vec2()
	Field rotation:Float = 0.0
	Field scale:Vec2 = New Vec2(1.0, 1.0)
	Field frame:Int = 0

	Method New(image:Image, scale:Vec2 = Null, offset:Vec2 = Null, rotation:Float = 0.0, frame:Int = 0)
		Self.image = image
		If offset <> Null
			Self.offset = offset
		End
		If scale <> Null
			Self.scale = scale
		End
		Self.rotation = rotation
		Self.frame = frame
	End
End