Import mojo
Import config
Import vec
Import rect
Import player
Import block
Import collisionmap
Import camera
Import level

Const STATE_MENU:Int = 0
Const STATE_LEVEL_CHOICE = 1
Const STATE_GAME:Int = 2
Const STATE_LEVEL_COMPLETE = 3
Const STATE_DEATH:Int = 4

Class PfGame Extends App
	
	Field player:Player = New Player()
	Field gameState:Int = STATE_MENU
	Field currentLevel:Level
	Field camera:Camera = New Camera()

	Method OnCreate()
    	SetUpdateRate 60
	End
	
	Method OnUpdate()
		Select gameState
			Case STATE_MENU
				If KeyHit(KEY_ENTER)
					currentLevel = FirstLevel()
					player.Set(currentLevel.playerStartingPosition)
					gameState = STATE_GAME
				End
			Case STATE_GAME
				If KeyHit(KEY_R)
					player.Reset()
				End
	        	UpdatePlayer(player)
	        	camera.Update(player, currentLevel)
	        Case STATE_LEVEL_COMPLETE
	        	IncrementLevel()
	        	player.Set(currentLevel.playerStartingPosition)
	        	camera.Update(player, currentLevel)
			Case STATE_DEATH
				player.Reset()
				camera.Update(player, currentLevel)
		End
	End
	
	Method FirstLevel:Level()
		Return New Level(0)
	End
	
	Method IncrementLevel()
		'TODO
	End
	
	Method OnRender()
	    Cls(0, 0, 0)
	    
	    Select gameState
	    	Case STATE_MENU
	    		DrawText("Platform Game!", 320, 100, 0.5)
	    		DrawText("Press Enter to Play", 320, 400, 0.5)
	    	Case STATE_GAME
	    		PushMatrix()
				Local translation:Vec2D = camera.Translation()
	    		Translate(translation.x, translation.y)
	    		player.Draw()
	    		For Local block := Eachin currentLevel.blocks
	    			block.Draw()
	    		End
	    		PopMatrix()
	    	Case STATE_DEATH
	    	 	DrawText("Game Over!", 320, 100, 0.5)
	    		DrawText("Press Enter to Play Again", 320, 400, 0.5)
	    End
	End
	
	Method TileCoordFromPoint:Vec2Di(point:Vec2D)
		Local tileX:Int = point.x / TILE_WIDTH
		Local tileY:Int = point.y / TILE_WIDTH
		
		Return New Vec2Di(tileX, tileY)
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Local topLeft:Vec2D = New Vec2D(coord.x * TILE_WIDTH, coord.y * TILE_WIDTH)
		Return New Rect(topLeft, TILE_WIDTH, TILE_HEIGHT)
	End
	
	Method SurroundingTilesAtPosition:Vec2Di[](position:Vec2D)
		Local positionTileCoord:Vec2Di = TileCoordFromPoint(position)
		Local tileCoordArray:Vec2Di[8]
		
		'to use this for player collisions currently assumes player is <= (2 x 2) tile size 
		'TODO make this more versatile?
		tileCoordArray[0] = New Vec2Di(positionTileCoord.x, positionTileCoord.y + 1)  'tile below position
		tileCoordArray[1] = New Vec2Di(positionTileCoord.x, positionTileCoord.y - 1)  'tile above position
		tileCoordArray[2] = New Vec2Di(positionTileCoord.x - 1, positionTileCoord.y)  'tile left of position
		tileCoordArray[3] = New Vec2Di(positionTileCoord.x + 1, positionTileCoord.y)  'tile right of position
		tileCoordArray[4] = New Vec2Di(positionTileCoord.x - 1, positionTileCoord.y - 1)  'tile up left of position
		tileCoordArray[5] = New Vec2Di(positionTileCoord.x + 1, positionTileCoord.y - 1)  'tile up right of position
		tileCoordArray[6] = New Vec2Di(positionTileCoord.x - 1, positionTileCoord.y + 1)  'tile down left of position
		tileCoordArray[7] = New Vec2Di(positionTileCoord.x + 1, positionTileCoord.y + 1)  'tile down right of position
		
		Return tileCoordArray
	End
	
	Method UpdatePlayer(player:Player)
		player.Update()
		
		CheckForAndResolveCollisions(player)
	End
	
	Method PrintRect(desc:String, r:Rect)
	    Print desc
		PrintVec("topLeft", r.topLeft)
		PrintVec("topRight", r.topRight) 
		PrintVec("botLeft", r.botLeft) 
		PrintVec("botRight", r.botRight) 
	End
	
	Method PrintVec(desc: String, v:Vec2D)
		Print desc + ": " + v.x + "," + v.y
	End
	
	Method CheckForAndResolveCollisions(p: Player)
		Local tileCoords:Vec2Di[] = SurroundingTilesAtPosition(p.position)

		p.onGround = False
		p.huggingLeft = False
		p.huggingRight = False
		 		
		Local tileIndex:Int = 0
		For Local tileCoord := Eachin tileCoords
			If currentLevel.collisionMap.DetectCollision(tileCoord)
				Local pRect:Rect = p.CollisionBoundingBox()
				Local dRect:Rect = p.DetectionBox()
				Local tileRect:Rect = TileRectFromTileCoord(tileCoord)
				Local intersection:Rect = pRect.Intersection(tileRect)
				Local detectIntersection:Rect = dRect.Intersection(tileRect)
				If intersection <> Null
					If tileIndex = 0
						'Tile is directly below player
						p.desiredPosition.Set(p.desiredPosition.x, p.desiredPosition.y - intersection.height)
						p.velocity.y = 0
						p.onGround = True						
					Elseif tileIndex = 1
						'Tile is directly above player
						p.desiredPosition.Set(p.desiredPosition.x, p.desiredPosition.y + intersection.height)
						p.velocity.y = 0
					Elseif tileIndex = 2
						'Tile is left of player
						p.desiredPosition.Set(p.desiredPosition.x + intersection.width, p.desiredPosition.y)
						p.velocity.x = 0
					Elseif tileIndex = 3
          				'tile is right of player
          				p.desiredPosition.Set(p.desiredPosition.x - intersection.width, p.desiredPosition.y)
          				p.velocity.x = 0
          			Else
          				If intersection.width > intersection.height
            				'tile is diagonal, but resolving collision vertically
            				p.velocity.y = 0
            				Local resolutionHeight:Float = intersection.height
            				If (tileIndex > 5)
            					'Tile is below
              					resolutionHeight = -intersection.height
              					p.onGround = True
              				End
            				p.desiredPosition.Set(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight)
          				Else
          					'tile is diagonal, but resolving horizontally
            				Local resolutionWidth:Float = -intersection.width
            				If tileIndex = 6 Or tileIndex = 4
            					'Tile is to the left
              					resolutionWidth = intersection.width
              				End
            				p.desiredPosition.Set(p.desiredPosition.x + resolutionWidth, p.desiredPosition.y)
            				p.velocity.x = 0
            			End
					End
				End
				If detectIntersection <> Null
					If tileIndex = 2
						'Tile is left of player
						p.huggingLeft = True
					Elseif tileIndex = 3
          				'tile is right of player
          		 		p.huggingRight = True
					End
					'TODO(?) make able to jump sidewards from diagonal-below tiles?
				End
			End
			tileIndex += 1
		Next
		p.position = p.desiredPosition	
	End
End



Function Main()
	New PfGame()
End