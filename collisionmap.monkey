Import config
Import vec
Import block
Import sat
Import rect

Class CollisionMap
	Field mapWidth:Int
	Field mapHeight:Int
	Field collisionArray:Int[]
	
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

	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * TILE_WIDTH, coord.y * TILE_WIDTH, TILE_WIDTH, TILE_HEIGHT)
	End
	
	Method DetectCollision:Bool(coordX:Int, coordY:Int)
		Local collision:Bool = False
		
		If (coordX > mapWidth - 1) Or (coordY > mapHeight - 1)
			Return False
		End
		
		If (coordY < 0) Or (coordY < 0)
			Return False
		End
		
		If collisionArray[mapWidth * coordY + coordX] = 1
			collision = True
		End
		Return collision
	End
	
	Method RayCastCollision:Vec2(origin:Vec2, direction:Vec2, maxLength:Float)
		Local originCoord:Vec2Di = TileCoordFromPoint(origin)
		Local offset:Vec2 = direction.Clone().Scale(maxLength)
		Local destination:Vec2 = origin.Clone().Add(offset)
		Local destCoord:Vec2Di = TileCoordFromPoint(destination)
		
		Local ray:Polygon = New Polygon(origin.x, origin.y, New VecStack([
			New Vec2(), New Vec2(offset.x, offset.y)]))
		
		Local stepX:Int = Sgn(destCoord.x - originCoord.x)  '1, 0 or -1
		Local stepY:Int = Sgn(destCoord.y - originCoord.y)  '1, 0 or -1
		If stepX = 0
			stepX = 1
		End
		If stepY = 0
			stepY = 1
		End
		Local i:Int = originCoord.x
		Local j:Int = originCoord.y
		'TODO this cold be far more efficient, especially for rays close to 45 degrees. Possibilities:
		'1) Avoid iterating over tiles that 'obviously' don't collide
		'2) Avoid iterating over tiles that are outside the map
		While i <> destCoord.x + stepX
			While j <> destCoord.y + stepY 
				If DetectCollision(i, j)
					Local tileRect:Rect = TileRectFromTileCoord(New Vec2Di(i, j))
					Local response:Response = New Response()
					If SAT.TestPolygonPolygon(ray, tileRect.ToPolygon(), response)
						'Find point of intersection with left/right of tile
						If destination.x = origin.x
							If destination.y > origin.y
								Return New Vec2(origin.x, tileRect.topLeft.y)
							Else
								Return New Vec2(origin.x, tileRect.botLeft.y)
							End
						Elseif destination.y = origin.y
							If destination.x > origin.x
								Return New Vec2(tileRect.topLeft.x, origin.y)
							Else
								Return New Vec2(tileRect.topRight.x, origin.y)
							End
						Else
							'Check left/right of tile
							'Which side of the tile do we need to check?
							Local verticalX:Float = tileRect.topLeft.x
							If destination.x < origin.x
								verticalX = tileRect.topRight.x
							End
							Local raySlope:Float = (destination.y - origin.y) / (destination.x - origin.x)
							Local rayIntersect:Float = origin.y - raySlope * origin.x
							
							'At what y value does the ray cross the vertical line?
							Local crossPosition:Float = raySlope * verticalX + rayIntersect
							Local clamped:Float = Clamp(crossPosition, tileRect.topLeft.y, tileRect.botLeft.y)
							If clamped = crossPosition
								Return New Vec2(verticalX, crossPosition)
							End 
							'Check top/bottom of tile
							'Which side of the tile do we need to check?
							Local horizontalY:Float = tileRect.botLeft.y
							If destination.y > origin.y
								horizontalY = tileRect.topLeft.y
							End
							
							'At what x value does the ray cross the horizontal line?
							crossPosition = (horizontalY - rayIntersect)/raySlope
							clamped = Clamp(crossPosition, tileRect.topLeft.x, tileRect.topRight.x)
							If clamped = crossPosition
								Return New Vec2(crossPosition, horizontalY)
							End 
						End
						'Return New Vec2Di(i, j)
						Return Null
					End
				End
				j += stepY
			End
			i += stepX
			j = originCoord.y
		End
			
		Return Null
	End
	
	Method AddBlock(block:Block)
		AddCollision(block.coord)
	End
End