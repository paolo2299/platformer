Import collidable
Import sat.vec
Import rect
Import theme

Class MovingPlatform Implements Blocky
	
	Field platformWidthTiles:Float
	Field tileWidth:Float
	Field tileHeight:Float
	Field speed:Float
	Field originalTopLeftPos:Vec2
	Field topLeftPos:Vec2
	Field prevTopLeftPos:Vec2
	Field midpointTopLeftPos:Vec2
	
	Field theme:Theme
	
	Field imageScaleX:Float
	Field imageScaleY:Float
	
	Field originalDirection:Vec2
	Field direction:Vec2
	Field offset:Vec2
	Field maxDistance:Float
	
	Field tileImageOuterLeft:TileImage
	Field tileImageInnerLeft:TileImage
	Field tileImageInnerRight:TileImage
	Field tileImageOuterRight:TileImage

	Method New(theme:Theme, originTopLeftPos:Vec2, destinationTopLeftPos:Vec2, platformWidthTiles:Float, tileWidth:Float, tileHeight:Float, speed:Float)
		Self.theme = theme

		Self.platformWidthTiles = platformWidthTiles
		Self.tileWidth = tileWidth
		Self.tileHeight = tileHeight

		originalTopLeftPos = originTopLeftPos
		Self.speed = speed
		topLeftPos = originTopLeftPos.Clone()
		prevTopLeftPos = originTopLeftPos.Clone()
		Local movementVec:Vec2 = destinationTopLeftPos.Clone().Sub(originTopLeftPos)
		direction = movementVec.Clone().Normalize()
		originalDirection = direction.Clone()
		Local midpointVec:Vec2 = movementVec.Clone().Scale(0.5)
		maxDistance = midpointVec.Length()
		midpointTopLeftPos = originTopLeftPos.Clone().Add(midpointVec)
		'PrintVec("originTopLeftPos", originTopLeftPos)
		'PrintVec("destinationTopLeftPos", destinationTopLeftPos)
		'PrintVec("midpointTopLeftPos", midpointTopLeftPos)
		'Print "maxDistance" + maxDistance
		tileImageOuterLeft = theme.TileImageForCode("platform_outer_left")
		tileImageOuterRight = theme.TileImageForCode("platform_outer_right")
		tileImageInnerLeft = theme.TileImageForCode("platform_inner_left")
		tileImageInnerRight = theme.TileImageForCode("platform_inner_right")
	End
	
	Method IsMoving:Bool()
		Return True
	End
	
	Method LastMovement:Vec2()
		Return offset
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
		topLeftPos = originalTopLeftPos.Clone()
		prevTopLeftPos = originalTopLeftPos.Clone()
		direction = originalDirection.Clone()
		offset = New Vec2(0.0, 0.0)
	End
	
	Method Update()
		prevTopLeftPos = topLeftPos.Clone()
		Local distanceFromMidpoint:Vec2  = topLeftPos.Clone().Sub(midpointTopLeftPos)
		If distanceFromMidpoint.Length() > maxDistance
			'go in the opposite direction
			direction.Scale(-1)
		End
		Local movement:Vec2 = direction.Clone().Scale(speed)
		topLeftPos.Add(movement)
		offset = topLeftPos.Clone().Sub(prevTopLeftPos)
	End
	
	Method PrevMove:Vec2()
		Return topLeftPos.Clone().Sub(prevTopLeftPos)
	End
	
	Method Rect:Rect()
		Return New Rect(topLeftPos.x, topLeftPos.y, platformWidthTiles * tileWidth, tileHeight)
	End
	
	Method GetCollision:Collision(ray:Ray)
		Local collidable:RectangularCollidable = New RectangularCollidable(Rect())
		Return collidable.GetCollision(ray)
	End
	
	Method Draw()
		SetColor()
		Local tileCount:Int = 0
		Local drawPos:Vec2 = topLeftPos.Clone()
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
	
	Method PrintVec(desc: String, v:Vec2)
		Print desc + ": " + v.x + "," + v.y
	End
End