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
	
	Method RayCastCollision:Collision(ray:Ray)
		Local origin:Vec2 = ray.origin
		Local originCoord:Vec2Di = TileCoordFromPoint(origin)
		Local destination:Vec2 = ray.destination
		Local destCoord:Vec2Di = TileCoordFromPoint(destination)
		
		Local rayPoly:Polygon = ray.ToPolygon()
		
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
				Local block:Block = DetectCollisionBlock(i, j)
				If block <> Null
					Local collisionRect:Rect = block.rect
					Local response:Response = New Response()
					If SAT.TestPolygonPolygon(rayPoly, collisionRect.ToPolygon(), response)
						'Find point of intersection with left/right of tile
						If destination.x = origin.x
							If destination.y > origin.y
								Local collisionPoint:Vec2 = New Vec2(origin.x, collisionRect.topLeft.y)
								Return New Collision(block, New Ray(origin, collisionPoint))
							Else
								Local collisionPoint:Vec2 = New Vec2(origin.x, collisionRect.botLeft.y)
								Return New Collision(block, New Ray(origin, collisionPoint))
							End
						Elseif destination.y = origin.y
							If destination.x > origin.x
								Local collisionPoint:Vec2 = New Vec2(collisionRect.topLeft.x, origin.y)
								Return New Collision(block, New Ray(origin, collisionPoint))
							Else
								Local collisionPoint:Vec2 = New Vec2(collisionRect.topRight.x, origin.y)
								Return New Collision(block, New Ray(origin, collisionPoint))
							End
						Else
							'Check left/right of tile
							'Which side of the tile do we need to check?
							Local verticalX:Float = collisionRect.topLeft.x
							If destination.x < origin.x
								verticalX = collisionRect.topRight.x
							End
							Local raySlope:Float = (destination.y - origin.y) / (destination.x - origin.x)
							Local rayIntersect:Float = origin.y - raySlope * origin.x
							
							'At what y value does the ray cross the vertical line?
							Local crossPosition:Float = raySlope * verticalX + rayIntersect
							Local clamped:Float = Clamp(crossPosition, collisionRect.topLeft.y, collisionRect.botLeft.y)
							If clamped = crossPosition
								Local collisionPoint:Vec2 = New Vec2(verticalX, crossPosition)
								Return New Collision(block, New Ray(origin, collisionPoint))
							End 
							'Check top/bottom of tile
							'Which side of the tile do we need to check?
							Local horizontalY:Float = collisionRect.botLeft.y
							If destination.y > origin.y
								horizontalY = collisionRect.topLeft.y
							End
							
							'At what x value does the ray cross the horizontal line?
							crossPosition = (horizontalY - rayIntersect)/raySlope
							clamped = Clamp(crossPosition, collisionRect.topLeft.x, collisionRect.topRight.x)
							If clamped = crossPosition
								Local collisionPoint:Vec2 = New Vec2(crossPosition, horizontalY)
								Return New Collision(block, New Ray(origin, collisionPoint))
							End 
						End
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
	
	Method RayCastCollision:Collision(origin:Vec2, direction:Vec2, maxLength:Float)
		Local offset:Vec2 = direction.Clone().Scale(maxLength)
		Local destination:Vec2 = origin.Clone().Add(offset)		 
		
		Return RayCastCollision(New Ray(origin, destination))
	End
End