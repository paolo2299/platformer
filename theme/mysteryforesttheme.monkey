Import mojo
Import backgroundlayer
Import theme

Class MysteryForestTheme Implements Theme
	Field tileWidth:Float
	Field tileHeight:Float
	Field scale:Vec2
	
	Field tileImageBMLL:Image
	Field tileImageBMLR:Image
	Field tileImageBMUL:Image
	Field tileImageBMUR:Image
	Field tileImageBEUL:Image
	Field tileImageBEUR:Image
	Field tileImageBELL:Image
	Field tileImageBELR:Image
	Field tileImageBIUL:Image
	Field tileImageBIUR:Image
	Field tileImageBILL:Image
	Field tileImageBILR:Image
	Field tileImageBWUR:Image
	Field tileImageBWLR:Image
	Field tileImageBWUL:Image
	Field tileImageBWLL:Image
	Field tileImageBCUL:Image
	Field tileImageBCUR:Image
	Field tileImageBCLL:Image
	Field tileImageBCLR:Image
	
	Field platformImageOL:Image
	Field platformImageIL:Image
	Field platformImageOR:Image
	Field platformImageIR:Image
	
	Field spikesImage:Image
	
	Field farBackgroundImage:Image
	Field nearBackgroundImage:Image
	
	Field backgroundLayers:Stack<BackgroundLayer> = New Stack<BackgroundLayer>()
	
	Method New(tileWidth, tileHeight)
		Self.tileWidth = tileWidth
		Self.tileHeight = tileHeight
		Local imageScaleX:Float = tileWidth / 128.0
		Local imageScaleY:Float = tileHeight / 128.0
		scale = New Vec2(imageScaleX, imageScaleY)
	
		tileImageBEUL = LoadImage("images/mysteryforest/Walls/wall_1_nw.png")
		tileImageBEUR = LoadImage("images/mysteryforest/Walls/wall_1_ne.png")
		tileImageBELR = LoadImage("images/mysteryforest/Walls/wall_1_se.png")
		tileImageBELL = LoadImage("images/mysteryforest/Walls/wall_1_sw.png")
		tileImageBMLL = LoadImage("images/mysteryforest/Walls/wall_2_sw.png")
		tileImageBMLR = LoadImage("images/mysteryforest/Walls/wall_2_se.png")
		tileImageBMUR = LoadImage("images/mysteryforest/Walls/wall_2_ne.png")
		tileImageBMUL = LoadImage("images/mysteryforest/Walls/wall_2_nw.png")
		tileImageBWUL = LoadImage("images/mysteryforest/Walls/wall_3_ne.png")
		tileImageBWUR = LoadImage("images/mysteryforest/Walls/wall_3_nw.png")
		tileImageBWLL = LoadImage("images/mysteryforest/Walls/wall_3_se.png")
		tileImageBWLR = LoadImage("images/mysteryforest/Walls/wall_3_sw.png")
		tileImageBCUR = LoadImage("images/mysteryforest/Walls/wall_4_ne.png")
		tileImageBCUL = LoadImage("images/mysteryforest/Walls/wall_4_nw.png")
		tileImageBCLL = LoadImage("images/mysteryforest/Walls/wall_4_sw.png")
		tileImageBCLR = LoadImage("images/mysteryforest/Walls/wall_4_se.png")
		tileImageBIUR = LoadImage("images/mysteryforest/Walls/wall_5_sw.png")
		tileImageBIUL = LoadImage("images/mysteryforest/Walls/wall_5_se.png")
		tileImageBILL = LoadImage("images/mysteryforest/Walls/wall_5_ne.png")
		tileImageBILR = LoadImage("images/mysteryforest/Walls/wall_5_nw.png")
		
		spikesImage = LoadImage("images/mysteryforest/Other/stakes.png", 128, 128, 12)
		
		platformImageOL = LoadImage("images/mysteryforest/Walkways/walkway_outer_left.png")
		platformImageIL = LoadImage("images/mysteryforest/Walkways/walkway_inner_left.png")
		platformImageOR = LoadImage("images/mysteryforest/Walkways/walkway_outer_right.png")
		platformImageIR = LoadImage("images/mysteryforest/Walkways/walkway_inner_right.png")

		farBackgroundImage = LoadImage("images/mysteryforest/Other/far_background.png")
		nearBackgroundImage = LoadImage("images/mysteryforest/Other/near_background.png")
		backgroundLayers.Push(New BackgroundLayer(farBackgroundImage, 0.15))
		backgroundLayers.Push(New BackgroundLayer(nearBackgroundImage))
	End
	
	Method BackgroundLayers:Stack<BackgroundLayer>()
		Return backgroundLayers
	End
	
	Method OffsetForTileCode:Vec2(tileCode:String)
		Local uplift:Float = -2.0
		If tileCode = "beul"
			Return New Vec2(-3.0, uplift)
		Elseif tileCode = "bmul" Or tileCode = "bmur" Or tileCode = "beur"
			Return New Vec2(0.0, uplift)
		Else
			Return New Vec2()
		End
	End
	
	Method TileImageForCode:TileImage(tileCode:String)
		Local imageOffset:Vec2 = OffsetForTileCode(tileCode)
		If tileCode = "bmll"
			Return New TileImage(tileImageBMLL, scale, imageOffset, 0.0)
		Elseif tileCode = "bmlr"
			Return New TileImage(tileImageBMLR, scale, imageOffset, 0.0)
		Elseif tileCode = "bmul"
			Return New TileImage(tileImageBMUL, scale, imageOffset, 0.0)
		Elseif tileCode = "bmur"
			Return New TileImage(tileImageBMUR, scale, imageOffset, 0.0)
		Elseif tileCode = "beul"
			Return New TileImage(tileImageBEUL, scale, imageOffset, 0.0)
		Elseif tileCode = "beur"
			Return New TileImage(tileImageBEUR, scale, imageOffset, 0.0)
		Elseif tileCode = "bell"
			Return New TileImage(tileImageBELL, scale, imageOffset, 0.0)
		Elseif tileCode = "belr"
			Return New TileImage(tileImageBELR, scale, imageOffset, 0.0)
		Elseif tileCode = "biul"
			Return New TileImage(tileImageBIUL, scale, imageOffset, 0.0)
		Elseif tileCode = "biur"
			Return New TileImage(tileImageBIUR, scale, imageOffset, 0.0)
		Elseif tileCode = "bill"
			Return New TileImage(tileImageBILL, scale, imageOffset, 0.0)
		Elseif tileCode = "bilr"
			Return New TileImage(tileImageBILR, scale, imageOffset, 0.0)
		Elseif tileCode = "bwur"
			Return New TileImage(tileImageBWUR, scale, imageOffset, 0.0)
		Elseif tileCode = "bwlr"
			Return New TileImage(tileImageBWLR, scale, imageOffset, 0.0)
		Elseif tileCode = "bwul"
			Return New TileImage(tileImageBWUL, scale, imageOffset, 0.0)
		Elseif tileCode = "bwll"
			Return New TileImage(tileImageBWLL, scale, imageOffset, 0.0)
		Elseif tileCode = "bcul"
			Return New TileImage(tileImageBCUL, scale, imageOffset, 0.0)
		Elseif tileCode = "bcur"
			Return New TileImage(tileImageBCUR, scale, imageOffset, 0.0)
		Elseif tileCode = "bcll"
			Return New TileImage(tileImageBCLL, scale, imageOffset, 0.0)
		Elseif tileCode = "bclr"
			Return New TileImage(tileImageBCLR, scale, imageOffset, 0.0)
		Elseif tileCode = "platform_outer_left"
			Return New TileImage(platformImageOL, scale, imageOffset, 0.0)
		Elseif tileCode = "platform_inner_left"
			Return New TileImage(platformImageIL, scale, imageOffset, 0.0)
		Elseif tileCode = "platform_inner_right"
			Return New TileImage(platformImageIR, scale, imageOffset, 0.0)
		Elseif tileCode = "platform_outer_right"
			Return New TileImage(platformImageOR, scale, imageOffset, 0.0)
		Elseif tileCode = "h_spikes_up1"
			Return New TileImage(spikesImage, scale, imageOffset, 0.0, 0)
		Elseif tileCode = "h_spikes_up2"
			Return New TileImage(spikesImage, scale, imageOffset, 0.0, 1)
		Elseif tileCode = "h_spikes_up3"
			Return New TileImage(spikesImage, scale, imageOffset, 0.0, 2)
		Elseif tileCode = "h_spikes_up4"
			Return New TileImage(spikesImage, scale, imageOffset, 0.0, 3)
		Elseif tileCode = "h_spikes_left1"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 0)
		Elseif tileCode = "h_spikes_left2"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 1)
		Elseif tileCode = "h_spikes_left3"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 2)
		Elseif tileCode = "h_spikes_left4"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(0.0, tileHeight)), 90.0, 3)
		Elseif tileCode = "h_spikes_right1"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 0)
		Elseif tileCode = "h_spikes_right2"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 1)
		Elseif tileCode = "h_spikes_right3"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 2)
		Elseif tileCode = "h_spikes_right4"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, 0.0)), 270.0, 3)
		Elseif tileCode = "h_spikes_down1"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 0)
		Elseif tileCode = "h_spikes_down2"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 1)
		Elseif tileCode = "h_spikes_down3"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 2)
		Elseif tileCode = "h_spikes_down4"
			Return New TileImage(spikesImage, scale, imageOffset.Clone().Add(New Vec2(tileWidth, tileHeight)), 180.0, 3)
		End
	End 
End