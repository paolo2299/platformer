Import config
Import vec
Import block
Import sat.vec2

Class CollisionMap
	Field mapWidth:Int
	Field mapHeight:Int
	Field collisionArray:Int[]
	
	Field rayCastIncrement:Int = 5
	
	Method New(mapWidth, mapHeight)
		Self.mapWidth = mapWidth
		Self.mapHeight = mapHeight
 		Self.collisionArray = New Int[mapWidth * mapHeight]
 	End
	
	Method AddCollision(coord:Vec2Di)
		collisionArray[mapWidth * coord.y + coord.x] = 1
	End
	
	Method DetectCollision:Bool(coord:Vec2Di)
		Return DetectCollision(coord.x, coord.y)
	End
	
	Method TileCoordFromPoint:Vec2Di(point:Vec2)
		Local tileX:Int = point.x / TILE_WIDTH
		Local tileY:Int = point.y / TILE_WIDTH
		
		Return New Vec2Di(tileX, tileY)
	End
	
	Method DetectCollision:Bool(coordX:Int, coordY:Int)
		Local collision:Bool = False
		
		If collisionArray[mapWidth * coordY + coordX] = 1
			collision = True
		End
		Return collision
	End
	
	Method RayCastCollision:Vec2Di(origin:Vec2, direction:Vec2, maxLength:Float)
		Local increment:Vec2 = direction.Clone().Normalize().Scale(rayCastIncrement)
		Local totalIncrements:Int = 0
		Local testPoint:Vec2 = origin.Clone()
		Local testCoord:Vec2Di = Null
		While totalIncrements * rayCastIncrement <= maxLength
			testCoord = TileCoordFromPoint(testPoint)
			If DetectCollision(testCoord)
				Return testCoord
			End
			testPoint.Add(increment)
			totalIncrements = totalIncrements + 1
		End
		Return Null
	End
	
	Method AddBlock(block:Block)
		AddCollision(block.coord)
	End
End