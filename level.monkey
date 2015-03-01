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
		GetLayout()
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
		For Local i = (mapWidth / 2) - 3 To (mapWidth / 2) + 3
			For Local j = (mapHeight / 2) - 1 To (mapHeight / 2) + 5
				blocks.Push(New Block(i, j))
			End
		End
		
		For Local block := Eachin blocks
        	collisionMap.AddBlock(block)
        End	
	End
End