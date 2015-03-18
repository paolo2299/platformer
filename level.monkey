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
	
	Method New(number:Int)
		Self.levelNumber = number
		'GetLayout()
		GetLayout()
	End
	
	Method FileString:String()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/layout.txt"
		Return mojo.LoadString(filePath)
	End
	
	Method GetLayout()
		SetMapWidthAndMapHeight()
		collisionMap = New CollisionMap(mapWidth, mapHeight)
		
		Local rows:String[] = FileString().Split("~n")
		Local rowNum:Int = 0
		Local colNum:Int = 0
		For Local row:String = Eachin rows
			Local tiles:String[] = row.Split(",")
			For Local tile:String = Eachin tiles
				If tile = "b"
					blocks.Push(New GroundBlock(colNum, rowNum))
				Elseif tile = "h"
					blocks.Push(New HazardBlock(colNum, rowNum))
				Elseif tile = "g"
					blocks.Push(New GoalBlock(colNum, rowNum))
				Elseif tile = "p"
					Local tileRect:Rect = TileRectFromTileCoord(New Vec2Di(colNum, rowNum))
					playerStartingPosition.Set(tileRect.centre.x, tileRect.centre.y)
				End
				colNum += 1
			End
			rowNum += 1
			colNum = 0
		End
		
		For Local block := Eachin blocks
        	collisionMap.AddBlock(block)
        End	
	End
	
	Method SetMapWidthAndMapHeight()
		Local rows:String[] = FileString().Split("~n")
		mapHeight = rows.Length()
		mapWidth = rows[0].Split(",").Length()
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * TILE_WIDTH, coord.y * TILE_WIDTH, TILE_WIDTH, TILE_HEIGHT)
	End
End