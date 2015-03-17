Import mojo
Import config
Import sat
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
	Field collisionResponse:Response = New Response()
	Field detectionResponse:Response = New Response()

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
		Return New Level(1)
	End
	
	Method IncrementLevel()
		'TODO
	End
	
	Method OnRender()
	    Cls(0, 0, 0)
	    
	    Select gameState
	    	Case STATE_MENU
	    		DrawText("Platform Game!", VIRTUAL_WINDOW_WIDTH / 2, VIRTUAL_WINDOW_HEIGHT / 2, 0.5)
	    		DrawText("Press Enter to Play", VIRTUAL_WINDOW_WIDTH / 2, VIRTUAL_WINDOW_HEIGHT / 1.8, 0.5)
	    	Case STATE_GAME
	    		PushMatrix()
				Local translation:Vec2 = camera.Translation()
	    		Translate(translation.x, translation.y)
	    		player.Draw()
	    		player.grapple.Draw()
	    		For Local block := Eachin currentLevel.blocks
	    			block.Draw()
	    		End
	    		PopMatrix()
	    	Case STATE_DEATH
	    	 	DrawText("Game Over!", 320, 100, 0.5)
	    		DrawText("Press Enter to Play Again", 320, 400, 0.5)
	    End
	End
	
	Method DrawVec(origin:Vec2, vec:Vec2)
		DrawLine(origin.x, origin.y, origin.x + vec.x, origin.y + vec.y)
	End
	
	Method TileCoordFromPoint:Vec2Di(point:Vec2)
		Local tileX:Int = point.x / TILE_WIDTH
		Local tileY:Int = point.y / TILE_WIDTH
		
		Return New Vec2Di(tileX, tileY)
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * TILE_WIDTH, coord.y * TILE_WIDTH, TILE_WIDTH, TILE_HEIGHT)
	End
	
	Method SurroundingTilesAtPosition:Vec2Di[](position:Vec2)
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
		
		UpdateGrapple(player)
	End
	
	Method UpdateGrapple(player:Player)
	    Local grapple:Grapple = player.grapple
		grapple.Update(player.position)
		If grapple.flying
			Local hitPosition:Vec2 = currentLevel.collisionMap.RayCastCollision(player.position, grapple.Direction(), grapple.maxSize)
			If hitPosition <> Null
				'Local tileHitRect:Rect = TileRectFromTileCoord(tileHitCoord)
				'Local grappleEngagePoint:Vec2 = tileHitRect.BottomMiddle()
				grapple.Engage(hitPosition)
			End
			grapple.flying = False
		End
	End
	
	Method PrintRect(desc:String, r:Rect)
	    Print desc
		PrintVec("topLeft", r.topLeft)
		PrintVec("topRight", r.topRight) 
		PrintVec("botLeft", r.botLeft) 
		PrintVec("botRight", r.botRight) 
	End
	
	Method PrintVec(desc: String, v:Vec2)
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
				If SAT.TestPolygonPolygon(tileRect.ToPolygon(), pRect.ToPolygon(), collisionResponse)
					p.desiredPosition.Add(collisionResponse.overlapV)
					If Abs(collisionResponse.overlapV.x) > 0
						p.velocity.x = 0
					End
					If Abs(collisionResponse.overlapV.y) > 0
						p.velocity.y = 0
					End
					If collisionResponse.overlapV.y < 0
						p.onGround = True
					End
				End
				SAT.TestPolygonPolygon(tileRect.ToPolygon(), dRect.ToPolygon(), detectionResponse)
				If SAT.TestPolygonPolygon(tileRect.ToPolygon(), dRect.ToPolygon(), detectionResponse)
					If detectionResponse.overlapV.x > 0
						p.huggingLeft = True
					Elseif detectionResponse.overlapV.x < 0
          		 		p.huggingRight = True
					End
				End
				collisionResponse.Clear()
				detectionResponse.Clear()
			End
			tileIndex += 1
		Next
		p.position = p.desiredPosition	
	End
End



Function Main()
	New PfGame()
End