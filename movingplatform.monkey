Import collidable
Import sat.vec
Import rect

Class MovingPlatform Implements Collidable
	
	Field platformWidthTiles:Float
	Field tileWidth:Float
	Field tileHeight:Float
	Field speed:Float
	Field originalTopLeftPos:Vec2
	Field topLeftPos:Vec2
	Field prevTopLeftPos:Vec2
	Field midpointTopLeftPos:Vec2
	
	Field imageOL:Image
	Field imageIL:Image
	Field imageIR:Image
	Field imageOR:Image
	
	Field imageScaleX:Float
	Field imageScaleY:Float
	
	Field originalDirection:Vec2
	Field direction:Vec2
	Field offset:Vec2
	Field maxDistance:Float

	Method New(imageOL:Image, imageIL:Image, imageIR:Image, imageOR:Image, originTopLeftPos:Vec2, destinationTopLeftPos:Vec2, platformWidthTiles:Float, tileWidth:Float, tileHeight:Float, speed:Float)
		Self.imageOL = imageOL
		Self.imageIL = imageIL
		Self.imageIR = imageIR
		Self.imageOR = imageOR

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
		PrintVec("originTopLeftPos", originTopLeftPos)
		PrintVec("destinationTopLeftPos", destinationTopLeftPos)
		PrintVec("midpointTopLeftPos", midpointTopLeftPos)
		Print "maxDistance" + maxDistance
		
		imageScaleX = tileWidth / imageIL.Width()
		imageScaleY = tileHeight / imageIL.Height()
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
	
	Method CollisionRect:Rect()
		Return New Rect(topLeftPos.x, topLeftPos.y, platformWidthTiles * tileWidth, tileHeight)
	End
	
	Method Draw()
		SetColor()
		Local tileCount:Int = 0
		Local drawPos:Vec2 = topLeftPos.Clone()
		While tileCount < platformWidthTiles
			If tileCount = 0
				DrawImage(imageOL, drawPos.x, drawPos.y, 0.0, imageScaleX, imageScaleY)
			Elseif tileCount = (platformWidthTiles - 1)
				DrawImage(imageOR, drawPos.x, drawPos.y, 0.0, imageScaleX, imageScaleY)
			Else
				Local parity:Int = tileCount Mod 2
				If parity = 0
					DrawImage(imageIR, drawPos.x, drawPos.y, 0.0, imageScaleX, imageScaleY)
				Else
					DrawImage(imageOR, drawPos.x, drawPos.y, 0.0, imageScaleX, imageScaleY)
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