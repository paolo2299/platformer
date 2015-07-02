Import collidable
Import rect
Import theme
Import movement.backandforth

'Const GOING_FORWARDS = 1
'Const GOING_BACKWARDS = -1 'TODO how do we export constants so we don't define these in two different places? Or define as class to expose them?

Class MovingPlatform Implements Blocky
	Field platformWidthTiles:Float
	Field tileWidth:Float
	Field tileHeight:Float
	
	Field theme:Theme
	
	Field tileImageOuterLeft:TileImage
	Field tileImageInnerLeft:TileImage
	Field tileImageInnerRight:TileImage
	Field tileImageOuterRight:TileImage
	
	Field movement:Moving

	Method New(theme:Theme, originTopLeftPos:Vec2, destinationTopLeftPos:Vec2, platformWidthTiles:Float, tileWidth:Float, tileHeight:Float, speed:Float)
		Self.theme = theme

		Self.platformWidthTiles = platformWidthTiles
		Self.tileWidth = tileWidth
		Self.tileHeight = tileHeight

		movement = New BackAndForth(originTopLeftPos, destinationTopLeftPos, originTopLeftPos, speed)
		tileImageOuterLeft = theme.TileImageForCode("platform_outer_left") 'TODO pass in the correct scale
		tileImageOuterRight = theme.TileImageForCode("platform_outer_right")
		tileImageInnerLeft = theme.TileImageForCode("platform_inner_left")
		tileImageInnerRight = theme.TileImageForCode("platform_inner_right")
	End
	
	Method IsMoving:Bool()
		Return True
	End
	
	Method LastMovement:Vec2()
		Return movement.LastMovement().Clone()
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method IsGrappleable:Bool()
		Return True
	End
	
	Method Reset()
		movement.Reset()
	End
	
	Method Update()
		movement.Update()
	End
	
	Method Rect:Rect()
		Local topLeftPos:Vec2 = TopLeftPos()
		Return New Rect(topLeftPos.x, topLeftPos.y, platformWidthTiles * tileWidth, tileHeight)
	End
	
	Method TopLeftPos:Vec2()
		Return movement.Position().Clone()
	End
	
	Method GetCollision:Collision(ray:Ray)
		Local collidable:RectangularCollidable = New RectangularCollidable(Rect())
		Return collidable.GetCollision(ray)
	End
	
	Method Draw()
		SetColor()
		Local tileCount:Int = 0
		Local drawPos:Vec2 = TopLeftPos()
		While tileCount < platformWidthTiles
			If tileCount = 0
				DrawImage(tileImageOuterLeft.image, drawPos.x + tileImageOuterLeft.offset.x, drawPos.y + tileImageOuterLeft.offset.y, tileImageOuterLeft.rotation, tileImageOuterLeft.scale.x, tileImageOuterLeft.scale.y, tileImageOuterLeft.frame)
			Elseif tileCount = (platformWidthTiles - 1)
				DrawImage(tileImageOuterRight.image, drawPos.x + tileImageOuterRight.offset.x, drawPos.y + tileImageOuterRight.offset.y, tileImageOuterRight.rotation, tileImageOuterRight.scale.x, tileImageOuterRight.scale.y, tileImageOuterRight.frame)
			Else
				Local parity:Int = tileCount Mod 2
				If parity = 0
					DrawImage(tileImageInnerRight.image, drawPos.x + tileImageInnerRight.offset.x, drawPos.y + tileImageInnerRight.offset.y, tileImageInnerRight.rotation, tileImageInnerRight.scale.x, tileImageInnerRight.scale.y, tileImageInnerRight.frame)
				Else
					DrawImage(tileImageInnerLeft.image, drawPos.x + tileImageInnerLeft.offset.x, drawPos.y + tileImageInnerLeft.offset.y, tileImageInnerLeft.rotation, tileImageInnerLeft.scale.x, tileImageInnerLeft.scale.y, tileImageInnerLeft.frame)
				End
			End
			drawPos.Add(New Vec2(tileWidth, 0.0))
			tileCount += 1
		End
	End

	Method SetColor()
		mojo.SetColor(255.0, 255.0, 255.0)
	End
End
