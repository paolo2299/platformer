Import config
Import block
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
		GetLayoutFromFile()
	End
	
	Method GetLayout()
		'ignore level num for now, only one level
		mapWidth = 60
		mapHeight = 35
		
		collisionMap = New CollisionMap(mapWidth, mapHeight)
		
		playerStartingPosition.Set(300, 300)
		
		
		For Local i = 0 To (mapHeight - 1)
			blocks.Push(New Block(0, i))
			blocks.Push(New Block(mapWidth - 1, i))
		End
		For Local i = 1 To (mapWidth - 2)
			blocks.Push(New Block(i, mapHeight - 1))
		End
		For Local i = 1 To (mapWidth - 2)
			blocks.Push(New Block(i, 0))
		End
		For Local i = (mapWidth / 2) - 15 To (mapWidth / 2) + 15
			blocks.Push(New Block(i, ((mapHeight + 9) / 2) - 14))
		End
		For Local i = (mapWidth / 2) - 3 To (mapWidth / 2) + 3
			For Local j = ((mapHeight + 9) / 2) - 1 To ((mapHeight + 9) / 2) + 5
				blocks.Push(New Block(i, j))
			End
		End
		
		For Local block := Eachin blocks
        	collisionMap.AddBlock(block)
        End	
	End
	
	Method FileString:String()
		Local filePath:String = "monkey://data/level" + levelNumber + ".txt"
		Return mojo.LoadString(filePath)
	End
	
	Method GetLayoutFromFile()
		SetMapWidthAndMapHeight()
		collisionMap = New CollisionMap(mapWidth, mapHeight)
		
		Local rows:String[] = FileString().Split("~n")
		Local rowNum:Int = 0
		Local colNum:Int = 0
		For Local row:String = Eachin rows
			Local tiles:String[] = row.Split(",")
			For Local tile:String = Eachin tiles
				If tile = "b"
					blocks.Push(New Block(colNum, rowNum))
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