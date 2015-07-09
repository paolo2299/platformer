Class RenderMap

	Field coordToBlocks: Map<Vec2D, Stack<Block>>
	Field level:Level
	
	Method New(level: Level)
		Self.level = level
		Local tilesX:Int = ((level.mapWidth * level.tileWidth) / VIRTUAL_WINDOW_WIDTH) + 1
		Local tilesY:Int = ((level.mapHeight * level.tileHeight) / VIRTUAL_WINDOW_HEIGHT) + 1
		For tileX := 1 To tilesX
			For tileY := 1 To tilesY
				Local coord:Vec2D = New Vec2D(tileX - 1, tileY - 1) 'Index from 0
				coordToBlocks[coord] = New Stack<Block>()
			End
		End
	End
	
	Method AddBlock(block: Block)
		Local position:Vec2 = block.rect.centre
		
		Local 
	End

	Method TileCoordFromPoint:Vec2Di(point:Vec2)
		Local tileX:Int = point.x / VIRTUAL_WINDOW_WIDTH
		Local tileY:Int = point.y / VIRTUAL_WINDOW_HEIGHT
		
		Return New Vec2Di(tileX, tileY)
	End
	
	Method BlocksFromCoord:Block(coord: Vec2D)
	End
End