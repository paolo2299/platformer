Import mojo
Import backgroundlayer

Class MysteryForestTheme
	
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
	
	Field farBackgroundImage:Image
	Field nearBackgroundImage:Image
	
	Field backgroundLayers:Stack<BackgroundLayer> = New Stack<BackgroundLayer>()
	
	Method New()
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
		
		platformImageOL = LoadImage("images/mysteryforest/Walkways/walkway_outer_left.png")
		platformImageIL = LoadImage("images/mysteryforest/Walkways/walkway_inner_left.png")
		platformImageOR = LoadImage("images/mysteryforest/Walkways/walkway_outer_right.png")
		platformImageIR = LoadImage("images/mysteryforest/Walkways/walkway_inner_right.png")

		farBackgroundImage = LoadImage("images/mysteryforest/Other/far_background.png")
		nearBackgroundImage = LoadImage("images/mysteryforest/Other/near_background.png")
		backgroundLayers.Push(New BackgroundLayer(farBackgroundImage, 0.15))
		backgroundLayers.Push(New BackgroundLayer(nearBackgroundImage))
	End
	
	Method ImageForTileCode:Image(tileCode:String)
		If tileCode = "bmll"
			Return tileImageBMLL
		Elseif tileCode = "bmlr"
			Return tileImageBMLR
		Elseif tileCode = "bmul"
			Return tileImageBMUL
		Elseif tileCode = "bmur"
			Return tileImageBMUR
		Elseif tileCode = "beul"
			Return tileImageBEUL
		Elseif tileCode = "beur"
			Return tileImageBEUR
		Elseif tileCode = "bell"
			Return tileImageBELL
		Elseif tileCode = "belr"
			Return tileImageBELR
		Elseif tileCode = "biul"
			Return tileImageBIUL
		Elseif tileCode = "biur"
			Return tileImageBIUR
		Elseif tileCode = "bill"
			Return tileImageBILL
		Elseif tileCode = "bilr"
			Return tileImageBILR
		Elseif tileCode = "bwur"
			Return tileImageBWUR
		Elseif tileCode = "bwlr"
			Return tileImageBWLR
		Elseif tileCode = "bwul"
			Return tileImageBWUL
		Elseif tileCode = "bwll"
			Return tileImageBWLL
		Elseif tileCode = "bcul"
			Return tileImageBCUL
		Elseif tileCode = "bcur"
			Return tileImageBCUR
		Elseif tileCode = "bcll"
			Return tileImageBCLL
		Elseif tileCode = "bclr"
			Return tileImageBCLR
		End
	End
End