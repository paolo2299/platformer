Import block
Import level

Class RenderMap

	Field coordToBlocks: StringMap<Stack<Block>> = New StringMap<Stack<Block>>()

	Field level:Level
	
	Method New(level: Level)
		Self.level = level
		Local tilesX:Int = ((level.mapWidth * level.tileWidth) / VIRTUAL_WINDOW_WIDTH) + 1
		Local tilesY:Int = ((level.mapHeight * level.tileHeight) / VIRTUAL_WINDOW_HEIGHT) + 1
		For Local tileX := 0 To tilesX + 1
			For Local tileY := 0 To tilesY + 1
				Print tileX + "," + tileY
				Local coord:Vec2Di = New Vec2Di(tileX - 1, tileY - 1) 'Index from 0
				coordToBlocks.Add(CoordToString(coord), New Stack<Block>())
			End
		End
	End
	
	Method CoordToString:String(coord:Vec2Di)
		Return "" + coord.x + "," + coord.y
	End
	
	Method AddBlock(block: Block)
		Local position:Vec2 = block.rect.centre
		Local tileCoord := TileCoordFromPoint(position)
		Local surroundingCoords := SurroundingCoordsForCoord(tileCoord)
		coordToBlocks.Get(CoordToString(tileCoord)).Push(block)
		For Local coord := Eachin surroundingCoords
			coordToBlocks.Get(CoordToString(coord)).Push(block)
		End
	End

	Method TileCoordFromPoint:Vec2Di(point:Vec2)
		Local tileX:Int = point.x / VIRTUAL_WINDOW_WIDTH
		Local tileY:Int = point.y / VIRTUAL_WINDOW_HEIGHT
		
		Return New Vec2Di(tileX, tileY)
	End
	
	Method BlocksFromPosition:Stack<Block>(position: Vec2)
		Local tileCoord := TileCoordFromPoint(position)
		Return coordToBlocks.Get(CoordToString(tileCoord))
	End
End