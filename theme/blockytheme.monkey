Import mojo
Import backgroundlayer
Import theme

Class BlockyTheme Implements Theme
	Field tileWidth:Float
	Field tileHeight:Float
	
	Field blockScale:Vec2
	Field platformScale:Vec2
	
	Field tileImageLargeBlocks:Image
	
	Field platformImageOL:Image
	Field platformImageIL:Image
	Field platformImageOR:Image
	Field platformImageIR:Image
	
	Field spikesImage:Image
	
	Field midnightBlueImage:Image
	Field starsImage:Image
	Field castleWallsImage:Image
	Field backgroundLayers:Stack<BackgroundLayer> = New Stack<BackgroundLayer>()
	
	Method New(tileWidth, tileHeight)
		Self.tileWidth = tileWidth
		Self.tileHeight = tileHeight
		Local blockScaleX:Float = tileWidth / 16.0
		Local blockScaleY:Float = tileHeight / 16.0
		Local platformScaleX:Float = tileWidth / 128.0
		Local platformScaleY:Float = tileHeight / 128.0
		blockScale = New Vec2(blockScaleX, blockScaleY)
		platformScale = New Vec2(platformScaleX, platformScaleY)
	
		tileImageLargeBlocks = LoadImage("images/blocks/large_blocks.png", 16, 16, 288)
		
		spikesImage = LoadImage("images/mysteryforest/Other/stakes.png", 128, 128, 12)
		
		platformImageOL = LoadImage("images/mysteryforest/Walkways/walkway_outer_left.png")
		platformImageIL = LoadImage("images/mysteryforest/Walkways/walkway_inner_left.png")
		platformImageOR = LoadImage("images/mysteryforest/Walkways/walkway_outer_right.png")
		platformImageIR = LoadImage("images/mysteryforest/Walkways/walkway_inner_right.png")
		
		midnightBlueImage = LoadImage("images/midnight_blue.png")
		starsImage = LoadImage("images/stars.png")
		castleWallsImage = LoadImage("images/castle_walls.png")
		Local backgroundSky:BackgroundLayer = New BackgroundLayer(midnightBlueImage, 0.0, 780.0, 780.0)
		Local stars:BackgroundLayer = New BackgroundLayer(starsImage, 0.3, 384.0, 384.0)
		Local castleWalls:BackgroundLayer = New BackgroundLayer(castleWallsImage, 0.15, 1280.0, 520.0, True)
		backgroundLayers.Push(backgroundSky)
		backgroundLayers.Push(stars)
		backgroundLayers.Push(castleWalls)
	End
	
	Method BackgroundLayers:Stack<BackgroundLayer>()
		Return backgroundLayers
	End
	
	Method TileImageForCode:TileImage(tileCode:String)
		Local imageOffset:Vec2 = New Vec2(0.0, 0.0)
		If tileCode[..1] = "b"
			Local frameX:Int = 0 + Floor(Rnd() * 4)
			Local frameY:Int = 8 + Floor(Rnd() * 4)
			Local frame:Int = frameY * 24 + frameX
			Return New TileImage(tileImageLargeBlocks, blockScale, imageOffset, 0.0, frame)
		Elseif tileCode = "platform_outer_left"
			Return New TileImage(platformImageOL, platformScale, imageOffset, 0.0)
		Elseif tileCode = "platform_inner_left"
			Return New TileImage(platformImageIL, platformScale, imageOffset, 0.0)
		Elseif tileCode = "platform_inner_right"
			Return New TileImage(platformImageIR, platformScale, imageOffset, 0.0)
		Elseif tileCode = "platform_outer_right"
			Return New TileImage(platformImageOR, platformScale, imageOffset, 0.0)
		Elseif tileCode = "h_spikes_up1"
			Return New TileImage(spikesImage, platformScale, imageOffset, 0.0, 0)
		Elseif tileCode = "h_spikes_up2"
			Return New TileImage(spikesImage, platformScale, imageOffset, 0.0, 1)
		Elseif tileCode = "h_spikes_up3"
			Return New TileImage(spikesImage, platformScale, imageOffset, 0.0, 2)
		Elseif tileCode = "h_spikes_up4"
			Return New TileImage(spikesImage, platformScale, imageOffset, 0.0, 3)
		Elseif tileCode = "h_spikes_left1"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 0)
		Elseif tileCode = "h_spikes_left2"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 1)
		Elseif tileCode = "h_spikes_left3"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 2)
		Elseif tileCode = "h_spikes_left4"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 3)
		Elseif tileCode = "h_spikes_right1"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 0)
		Elseif tileCode = "h_spikes_right2"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 1)
		Elseif tileCode = "h_spikes_right3"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 2)
		Elseif tileCode = "h_spikes_right4"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 3)
		Elseif tileCode = "h_spikes_down1"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 0)
		Elseif tileCode = "h_spikes_down2"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 1)
		Elseif tileCode = "h_spikes_down3"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 2)
		Elseif tileCode = "h_spikes_down4"
			Return New TileImage(spikesImage, platformScale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 3)
		End
	End 
End