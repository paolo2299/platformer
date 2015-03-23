Import config
Import block.groundblock
Import block.hazardblock
Import block.goalblock
Import collisionmap
Import sat.vec2

Class Level
	Field levelNumber:Int

	Field playerStartingPosition:Vec2 = New Vec2()
	Field blocks:Stack<Block> = New Stack<Block>()	
	Field collisionMap:CollisionMap
	Field mapWidth:Int
	Field mapHeight:Int
	
	Field defaultTileWidth:Int = 28
	Field defaultTileHeight:Int = 28
	Field tileWidth:Int
	Field tileHeight:Int
	
	Method New(number:Int)
		Self.levelNumber = number
		GetConfig()
		GetLayout()
	End
	
	Method LayoutFileString:String()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/layout.txt"
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
				If tile = "b"
					Local block:Block = New GroundBlock(rect)
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
	End
	
	Method SetMapWidthAndMapHeight()
		Local rows:String[] = LayoutFileString().Split("~n")
		mapHeight = rows.Length()
		mapWidth = rows[0].Split(",").Length()
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * tileWidth, coord.y * tileHeight, tileWidth, tileHeight)
	End
End
