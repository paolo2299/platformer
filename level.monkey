Import config
Import block.groundblock
Import block.hazardblock
Import block.goalblock
Import collisionmap
Import movingplatform
Import stopwatch
Import sat.vec2

Class Level
	Field levelNumber:Int

	Field playerStartingPosition:Vec2 = New Vec2()
	Field blocks:Stack<Block> = New Stack<Block>()
	Field movingPlatforms:Stack<MovingPlatform> = New Stack<MovingPlatform>()	
	Field collisionMap:CollisionMap
	Field mapWidth:Int
	Field mapHeight:Int
	Field stopWatch:StopWatch = New StopWatch()
	
	Field defaultTileWidth:Int = 28
	Field defaultTileHeight:Int = 28
	Field tileWidth:Int
	Field tileHeight:Int
	
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
	
	
	Method New(number:Int)
		Self.levelNumber = number
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
		GetConfig()
		GetLayout()
	End
	
	Method LayoutFileString:String()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/layout.txt"
		Return mojo.LoadString(filePath)
	End
	
	Method MovingPlatformsFileString:String()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/movingplatforms.txt"
		Return mojo.LoadString(filePath)
	End
	
	Method GetConfig()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/config.txt"
		
		tileWidth = defaultTileWidth
		tileHeight = defaultTileHeight
		
		Local rows:String[] = mojo.LoadString(filePath).Split("~n")
		For Local row:String = Eachin rows
			Local data:String[] = row.Split(",")
			If data[0] = "tileWidth"
				tileWidth = Int(data[1].Trim())
			Elseif data[0] = "tileHeight"
				tileHeight = Int(data[1].Trim())
			End
		End
	End
	
	Method GetLayout()
		SetMapWidthAndMapHeight()
		collisionMap = New CollisionMap(Self)
		
		Local rows:String[] = LayoutFileString().Split("~n")
		Local rowNum:Int = 0
		Local colNum:Int = 0
		For Local row:String = Eachin rows
			Local tiles:String[] = row.Split(",")
			For Local tile:String = Eachin tiles
				Local coordX:Float = colNum * tileWidth
				Local coordY:Float = rowNum * tileHeight
				
				Local rect:Rect = New Rect(coordX, coordY, tileWidth, tileHeight)
				Local imageOffsetX:Float = -0.11
				Local imageOffsetY:Float = -0.09
				
				If tile = "bmll"
					Local block:Block = New GroundBlock(rect, tileImageBMLL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bmlr"
					Local block:Block = New GroundBlock(rect, tileImageBMLR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bmul"
					Local block:Block = New GroundBlock(rect, tileImageBMUL, 0.0, tileHeight * imageOffsetY)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bmur"
					Local block:Block = New GroundBlock(rect, tileImageBMUR, 0.0, tileHeight * imageOffsetY)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "beul"
					Local block:Block = New GroundBlock(rect, tileImageBEUL, tileWidth * imageOffsetX, tileHeight * imageOffsetY)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "beur"
					Local block:Block = New GroundBlock(rect, tileImageBEUR, 0.0, tileHeight * imageOffsetY)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bell"
					Local block:Block = New GroundBlock(rect, tileImageBELL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "belr"
					Local block:Block = New GroundBlock(rect, tileImageBELR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "biul"
					Local block:Block = New GroundBlock(rect, tileImageBIUL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "biur"
					Local block:Block = New GroundBlock(rect, tileImageBIUR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bill"
					Local block:Block = New GroundBlock(rect, tileImageBILL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bilr"
					Local block:Block = New GroundBlock(rect, tileImageBILR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bwur"
					Local block:Block = New GroundBlock(rect, tileImageBWUR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bwlr"
					Local block:Block = New GroundBlock(rect, tileImageBWLR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bwul"
					Local block:Block = New GroundBlock(rect, tileImageBWUL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bwll"
					Local block:Block = New GroundBlock(rect, tileImageBWLL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bcul"
					Local block:Block = New GroundBlock(rect, tileImageBCUL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bcur"
					Local block:Block = New GroundBlock(rect, tileImageBCUR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bcll"
					Local block:Block = New GroundBlock(rect, tileImageBCLL)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "bclr"
					Local block:Block = New GroundBlock(rect, tileImageBCLR)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "h"
					Local block:Block = New HazardBlock(rect)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "g"
					Local block:Block = New GoalBlock(rect)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "p"
					Local tileRect:Rect = TileRectFromTileCoord(New Vec2Di(colNum, rowNum))
					playerStartingPosition.Set(tileRect.centre.x, tileRect.centre.y)
				End
				colNum += 1
			End
			rowNum += 1
			colNum = 0
		End
		
		'TODO
		rows = MovingPlatformsFileString().Split("~n")
		For Local row:String = Eachin rows
			If row = ""
				Exit
			End
			Local data:String[] = row.Split(",")
			Local originTopLeftX:Float = Float(data[0].Trim()) * tileWidth
			Local originTopLeftY:Float = Float(data[1].Trim()) * tileHeight
			Local destinationTopLeftX:Float = Float(data[2].Trim()) * tileWidth
			Local destinationTopLeftY:Float = Float(data[3].Trim()) * tileHeight
			Local width:Float = Float(data[4].Trim()) * tileWidth
			Local height:Float = Float(data[5].Trim()) * tileHeight
			Local speed:Float = Float(data[6].Trim()) * tileWidth
			Local movingPlatform:MovingPlatform = New MovingPlatform(New Vec2(originTopLeftX, originTopLeftY), New Vec2(destinationTopLeftX, destinationTopLeftY), width, height, speed)
			movingPlatforms.Push(movingPlatform)
		End
	End
	
	Method SetMapWidthAndMapHeight()
		Local rows:String[] = LayoutFileString().Split("~n")
		mapHeight = rows.Length()
		mapWidth = rows[0].Split(",").Length()
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * tileWidth, coord.y * tileHeight, tileWidth, tileHeight)
	End
	
	Method Reset()
		For Local movingPlatform := Eachin movingPlatforms
			movingPlatform.Reset()
		End
		stopWatch.Reset()
	End
End
