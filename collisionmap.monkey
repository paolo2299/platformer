Import config
Import vec
Import level
Import block
Import sat
Import rect
Import ray
Import collision

Class CollisionMap
	Field level:Level
	Field mapWidth:Int
	Field mapHeight:Int
	Field blockArray:Block[]

	Method New(level:Level)
		Self.level = level
 		Self.blockArray = New Block[level.mapWidth * level.mapHeight]
 	End

	Method AddBlock(block:Block, coord:Vec2Di)
		blockArray[level.mapWidth * coord.y + coord.x] = block
	End

	Method TileCoordFromPoint:Vec2Di(point:Vec2)
		Local tileX:Int = point.x / level.tileWidth
		Local tileY:Int = point.y / level.tileWidth
		
		Return New Vec2Di(tileX, tileY)
	End

	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * level.tileWidth, coord.y * level.tileHeight, level.tileWidth, level.tileHeight)
	End

	Method DetectCollisionBlock:Block(coordX:Int, coordY:Int)
		Local collisionBlock:Block = Null
		
		If (coordX > level.mapWidth - 1) Or (coordY > level.mapHeight - 1)
			Return Null
		End
		
		If (coordY < 0) Or (coordY < 0)
			Return Null
		End
		
		Return blockArray[level.mapWidth * coordY + coordX]
	End

	Method DetectCollisionBlock:Block(coord: Vec2Di)		
		Return DetectCollisionBlock(coord.x, coord.y)
	End

	Method RayCastCollision:BlockyCollision(ray:Ray)
		Local origin:Vec2 = ray.origin
		Local originCoord:Vec2Di = TileCoordFromPoint(origin)
		Local destination:Vec2 = ray.destination
		Local destCoord:Vec2Di = TileCoordFromPoint(destination)

		Local stepX:Int = Sgn(destCoord.x - originCoord.x)  '1, 0 or -1
		Local stepY:Int = Sgn(destCoord.y - originCoord.y)  '1, 0 or -1
		If stepX = 0
			stepX = 1
		End
		If stepY = 0
			stepY = 1
		End

	          Local collision:Collision = Null

		Local i:Int = originCoord.x
		Local j:Int = originCoord.y
		'TODO this cold be far more efficient, especially for rays close to 45 degrees. Possibilities:
		'1) Avoid iterating over tiles that 'obviously' don't collide
		'2) Avoid iterating over tiles that are outside the map
		While i <> destCoord.x + stepX
			While j <> destCoord.y + stepY
				Local block:Block = DetectCollisionBlock(i, j)
				If block <> Null
					'TODO should block.GetColliison return a BlockyCollision?
					collision = block.GetCollision(ray)
					If collision <> Null
						Return New BlockyCollision(collision.ray, block)
					End
				End
				j += stepY
			End
			If collision <> Null
				Exit
			End
			i += stepX
			j = originCoord.y
		End
		Return Null
	End
End