Import config
Import vec
Import block
Import sat.vec2

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
	
	Method DetectCollision:Bool(coordX:Int, coordY:Int)
		Local collision:Bool = False
		
		If collisionArray[mapWidth * coordY + coordX] = 1
			collision = True
		End
		Return collision
	End
	
	Method AddBlock(block:Block)
		AddCollision(block.coord)
	End
End