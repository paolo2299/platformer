Import mojo
Import config
Import sat
Import vec
Import rect
Import player
Import block
Import collisionmap
Import collision
Import camera
Import level
Import fontmachine
Import playerrecorder
Import savedstate
Import utilities

Const STATE_MENU:Int = 0
Const STATE_LEVEL_CHOICE = 1
Const STATE_GAME:Int = 2
Const STATE_LEVEL_COMPLETE = 3
'TODO have a separate state for completing the level than displaying the level complete menu
Const STATE_DEATH:Int = 4

Const FIRST_LEVEL = 1

Class PfGame Extends App
	Field startTime:Int = Millisecs()
	
	Field player:Player
	Field gameState:Int = STATE_MENU
	Field currentLevel:Level

	Field camera:Camera = New Camera()
	Field collisionResponse:Response = New Response()
	Field detectionResponse:Response = New Response()
	
	Field font:BitmapFont
	Field playerRecorder:PlayerRecorder = Null
	Field bestPlayerRecorder:PlayerRecorder = Null
	
	Field savedState:SavedState
	
	Method OnCreate()
    		SetUpdateRate 60
    		
    		font = New BitmapFont("fonts/CleanWhite/CleanWhite.txt", False)
    		savedState = LoadSavedState()
    		'savedState.Clear()
	End
	
	Method OnUpdate()
		Select gameState
			Case STATE_MENU
				If KeyHit(KEY_ENTER)
					currentLevel = FirstLevel()
					StartLevel()
					playerRecorder.Record(player)
				End
			Case STATE_GAME
				If KeyHit(KEY_R)
					ResetLevel()
					playerRecorder.Record(player)
				Else
					UpdateMovingPlatforms()
					UpdateHazards()
					UpdatePlayer(player)
					playerRecorder.Record(player)
					camera.Update(player, currentLevel)	
					If bestPlayerRecorder <> Null
						bestPlayerRecorder.UpdateForPlayback()
					End
				End	
			Case STATE_LEVEL_COMPLETE
				currentLevel.stopWatch.Stop()
				If (savedState.GetLevelTime(currentLevel) = -1) Or (currentLevel.stopWatch.Elapsed() < savedState.GetLevelTime(currentLevel))
					savedState.SetLevelTime(currentLevel, currentLevel.stopWatch.Elapsed())
				End
			
				If KeyHit(KEY_ENTER)
					IncrementLevel()
					StartLevel()
				End
				
				If KeyHit(KEY_R)
					If bestPlayerRecorder = Null
						bestPlayerRecorder = playerRecorder
					Else
						If bestPlayerRecorder.totalRecordings > playerRecorder.totalRecordings
							bestPlayerRecorder = playerRecorder
						End
					End
					ResetLevel()
					gameState = STATE_GAME
					playerRecorder.Record(player)
				End
			Case STATE_DEATH
				ResetLevel()
				gameState = STATE_GAME
		End
	End
	
	Method OnRender()
	    Cls(0, 0, 0)
	    
	    Select gameState
	    	Case STATE_MENU
	    		RenderTextCenter("Platform Game!", 9)
	    		RenderTextCenter("Press Enter to Play", 11)
	    	Case STATE_GAME
			PushMatrix()
				Local translation:Vec2 = camera.Translation()
				Translate(translation.x, translation.y)
				RenderBackground(translation)
				If player.holdsGrapple
					player.grapple.Draw()
				End
				player.Draw()
				
				For Local block := Eachin currentLevel.blocks
					block.Draw()
				End
				For Local movingPlatform := Eachin currentLevel.movingPlatforms
					movingPlatform.Draw()
				End
				
				For Local hazard := Eachin currentLevel.hazards
					hazard.Draw()
				End
				
				For Local collectible := Eachin currentLevel.collectibles
					collectible.Draw()
				End
				
				If bestPlayerRecorder <> Null
					bestPlayerRecorder.PlayBack()
				End
			PopMatrix()
			SetColor(255, 255, 255)
			font.DrawText("" + currentLevel.stopWatch.ElapsedString(), VIRTUAL_WINDOW_WIDTH - 50, 20, eDrawAlign.RIGHT)
			If currentLevel.stopWatch.TotalElapsed() < 2000
				font.DrawText("" + currentLevel.name, VIRTUAL_WINDOW_WIDTH / 2, 40)	
			End
			Case STATE_LEVEL_COMPLETE
				RenderTextCenter("Your time: " + FormatMillisecs(currentLevel.stopWatch.Elapsed()), 3)
				
				RenderTextCenter("Fastest time ever: " + FormatMillisecs(savedState.GetLevelTime(currentLevel)), 5)
				
				RenderTextCenter("Medal awarded: " + currentLevel.AwardMedal(savedState.GetLevelTime(currentLevel)), 6)
				
				RenderTextCenter("Medal times:", 8)
				RenderTextCenter("Gold: " + FormatMillisecs(currentLevel.goldTime), 9)
				RenderTextCenter("Silver: " + FormatMillisecs(currentLevel.silverTime), 10)
				RenderTextCenter("Bronze: " + FormatMillisecs(currentLevel.bronzeTime), 11)
				
				RenderTextCenter("Press Enter to go to the next level", 14)
				RenderTextCenter("Press R to retry the level and try to get a faster time!", 15)
		End
	End
	
	Method RenderTextCenter(text:String, slot:Int = 10) '20 vertical slots
		font.DrawText(text, VIRTUAL_WINDOW_WIDTH/2, VIRTUAL_WINDOW_HEIGHT * (slot * 1.0 / 20.0), eDrawAlign.CENTER)
	End 
	
	Method RenderBackground(cameraTranslation:Vec2)
		For Local backgroundLayer := Eachin currentLevel.theme.BackgroundLayers()
			PushMatrix()
				Local revTranslation:Vec2 = cameraTranslation.Clone().Scale(-1* backgroundLayer.parallaxFactor)
				Translate(revTranslation.x, revTranslation.y)
				Local countX:Int = 0
				Local countY:Int = 0
				Local tilesX:Int = ((currentLevel.mapWidth * currentLevel.tileWidth) / backgroundLayer.imageWidth) + 1
				Local tilesY:Int = ((currentLevel.mapHeight * currentLevel.tileHeight) / backgroundLayer.imageHeight) + 1
				While countX < tilesX
					While countY < tilesY
						DrawImage(backgroundLayer.image, countX * backgroundLayer.imageWidth, countY * backgroundLayer.imageHeight, 0.0,  backgroundLayer.imageScaleX,  backgroundLayer.imageScaleY)
						countY += 1
					End
					countY = 0
					countX += 1
				End
			PopMatrix()
		End
	End
	
	Method ResetLevel()
		currentLevel.Reset()
		player.Reset()
		playerRecorder = New PlayerRecorder(player)
		If bestPlayerRecorder <> Null
			bestPlayerRecorder.ResetPlayback()
		End
		camera.Update(player, currentLevel)
	End
	
	Method StartLevel()
		player = New Player(currentLevel)
		camera.Update(player, currentLevel)
		playerRecorder = New PlayerRecorder(player)
		bestPlayerRecorder = Null
		gameState = STATE_GAME
	End
	
	Method FirstLevel:Level()
		Return New Level(FIRST_LEVEL)
	End
	
	Method IncrementLevel()
		currentLevel = New Level(currentLevel.levelNumber + 1)
	End
	
	Method DrawVec(origin:Vec2, vec:Vec2)
		DrawLine(origin.x, origin.y, origin.x + vec.x, origin.y + vec.y)
	End
	
	Method TileCoordFromPoint:Vec2Di(point:Vec2)
		Local tileX:Int = point.x / currentLevel.tileWidth
		Local tileY:Int = point.y / currentLevel.tileHeight
		
		Return New Vec2Di(tileX, tileY)
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * currentLevel.tileWidth, coord.y * currentLevel.tileHeight, currentLevel.tileWidth, currentLevel.tileHeight)
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
	
	Method UpdateMovingPlatforms()
		For Local movingPlatform := Eachin currentLevel.movingPlatforms
			movingPlatform.Update()
		End
	End
	
	Method UpdateHazards()
		For Local hazard := Eachin currentLevel.hazards
			hazard.Update()
		End
	End
	
	Method UpdatePlayer(player:Player)
		If currentLevel.OffscreenPosition(player.position)
			'TODO - When changing state could throw and catch to avoid doing unecessary/non-sensical logic? 
			gameState = STATE_DEATH
			Return
		End
		If player.onMovingPlatform <> Null
			player.UpdateForMovingPlatforms()
			CheckForAndResolveCollisions(player)
		End
		player.Update()
		CheckForAndResolveCollisions(player)
		DetectNearbySurfaces(player)
		
		If player.holdsGrapple
			UpdateGrapple(player)
		End
	End
	
	Method UpdateGrapple(player:Player)
	    Local grapple:Grapple = player.grapple
		grapple.Update(player.position)
		If grapple.flying
			Local collision:BlockyCollision = GetClosestCollision(grapple.FlyingRay())
			If collision <> Null
				If collision.blocky.IsGrappleable()
					grapple.Engage(collision)
				End
			End
			grapple.flying = False
		Elseif grapple.engaged
			Local blocky:Blocky = grapple.engagedWith
			If blocky.IsMoving()
				grapple.hookPos.Add(blocky.LastMovement())
			End
		End
	End
	
	Method GetClosestCollision:BlockyCollision(p: Player, movementVec: Vec2)
		Local pRect:Rect = p.BoundingBox()
		Local rays:Stack<Ray> = RaysForMovement(pRect, movementVec)
		
		Return GetClosestCollision(rays)
	End
	
	Method GetClosestCollision:BlockyCollision(rays: Stack<Ray>)
		'Print "In get closest"
		'PrintVec("playerPosition", player.position)
		Local closest:BlockyCollision = Null
		'First check collisions with static blocks
		For Local ray := Eachin rays
			Local bc:BlockyCollision = currentLevel.collisionMap.RayCastCollision(ray)
			If bc <> Null
				'PrintRect("collisionRect", bc.blocky.Rect())
				'PrintVec("ray oriign", ray.origin)
				'PrintVec("ray destination", ray.destination)
				'PrintVec("collision ray origin", bc.collision.ray.origin)
				'PrintVec("collisionl ray destination", bc.collision.ray.destination)
				If closest = Null
					closest = bc
					'Print "shortest by default!"
				Elseif bc.ray.Length() < closest.ray.Length()
					'Print "shortest!"
					closest = bc
				Elseif bc.ray.Length() = closest.ray.Length()
					'PrintRect("testing corner: bc collides with", bc.blocky.Rect())
					'PrintVec("ray destination", bc.collision.ray.destination)
					If Not bc.OnCorner()
						'Print("not on corner")
						closest = bc
					Else
						'Print("on corner")
					End
				End
			End
		End
		
		'Now check collisions with moving platforms
		For Local ray := Eachin rays
			For Local movingPlatform := Eachin currentLevel.movingPlatforms
				Local collision:Collision = movingPlatform.GetCollision(ray)
				If (collision <> Null) 
					If (closest = Null)
						closest = New BlockyCollision(collision.ray, movingPlatform)
					Elseif collision.ray.Length() < closest.ray.Length()
						closest = New BlockyCollision(collision.ray, movingPlatform)
					Elseif collision.ray.Length() = closest.ray.Length()
						closest = New BlockyCollision(collision.ray, movingPlatform)
					End
				End
			End
		End
		
		If closest <> Null
			'Print("Result")
			'PrintVec("origin", closest.collision.ray.origin)
			'PrintVec("dest", closest.collision.ray.destination)
		End
		Return closest
	End
	
	Method GetClosestCollision:BlockyCollision(ray: Ray)
		Local rays:Stack<Ray> = New Stack<Ray>()
		rays.Push(ray)
		Return GetClosestCollision(rays)
	End
	
	Method CheckForAndResolveCollisions(p: Player)			
		Local movementVec:Vec2 = p.MovementVector()
		Local startRect:Rect = p.BoundingBox().CloneRect()
		
		Local closestCollision:BlockyCollision = GetClosestCollision(p, movementVec)
		If closestCollision = Null
			'no collision
			p.position.Add(movementVec)
			CheckForCollisionWithCollidingHazard(p, startRect)
			CheckForCollisionWithCollectible(p, startRect)
			Return
		End
		
		'there was a collision
		Local stateChanged:Bool = UpdateGameStateForCollision(closestCollision)
		If stateChanged
			Return
		End
		
		'Print("collision!")
		'PrintRect("collidded with rect:", closestCollision.blocky.Rect())
		'PrintVec("ray destination", closestCollision.collision.ray.destination)
		'PrintVec("player position before first offset", p.position)
		
		p.position.Add(closestCollision.ray.offset)
		
		'PrintVec("player position after first offset", p.position)
		
		'see if we can maintain momentum
		If closestCollision.OnTopOrBottom()
			'Print("OnTopOrBottom")
			'PrintVec("movement vec before", movementVec)
			'PrintVec("ray origin", closestCollision.ray.origin)
			'PrintVec("ray destination", closestCollision.ray.destination)
			'PrintVec("ray offset", closestCollision.ray.offset)
			movementVec.y = 0
			movementVec.x -= closestCollision.ray.offset.x
			'PrintVec("movement vec after", movementVec)
			p.velocity.y = 0
		Else
			'Print("Not top or bottom")
			movementVec.x = 0
			movementVec.y -= closestCollision.ray.offset.y
			p.velocity.x = 0
		End
		
		closestCollision = GetClosestCollision(p, movementVec)
		If closestCollision = Null
			'Print("no second collision")
			p.position.Add(movementVec)
		Else
			Local stateChanged:Bool = UpdateGameStateForCollision(closestCollision)
			If stateChanged
				Return
			End
			'Print("second collision!")
			'PrintVec("ray offset", closestCollision.ray.offset)
			p.position.Add(closestCollision.ray.offset)
		End
		'PrintVec("final player position", p.position)
		CheckForCollisionWithCollidingHazard(p, startRect)
		CheckForCollisionWithCollectible(p, startRect)
	End
	
	Method CheckForCollisionWithCollidingHazard(p:Player, startRect:Rect)
		'TODO refactor - this should be icorporated into the closest collision logic.
		'For example it is currently possible to fly though a hazard into the level goal
		Local endRect:Rect = p.BoundingBox().CloneRect()
		Local movementRays:Stack<Ray> = RaysForMovement(startRect, endRect)
		For Local ray := Eachin movementRays
			For Local hazard := Eachin currentLevel.hazards
				If hazard.GetCollision(ray)
					gameState = STATE_DEATH
					Return
				End
			End
		End
	End
	
	Method CheckForCollisionWithCollectible(p:Player, startRect:Rect)
		'TODO is it possible to fly striaght through a collectibe with enough speed and the correct angle? (answer: yes) how to resolve?
		Local endRect:Rect = p.BoundingBox().CloneRect()
		Local movementRays:Stack<Ray> = RaysForMovement(startRect, endRect)
		For Local ray := Eachin movementRays
			For Local collectible := Eachin currentLevel.collectibles
				If collectible.GetCollision(ray)
					p.CollectCollectible(collectible)
				End
			End
		End
	End
	
	Method UpdateGameStateForCollision:Bool(collision:BlockyCollision)
		If collision.blocky.IsHazard()
			gameState = STATE_DEATH
			Return True
		End
		If collision.blocky.IsGoal()
			gameState = STATE_LEVEL_COMPLETE
			Return True
		End
		Return False
	End
	
	Method DetectNearbySurfaces(p: Player)
		p.onGround = False
		p.huggingLeft = False
		p.huggingRight = False
		p.onMovingPlatform = Null	
	
		Local downVec:Vec2 = New Vec2(0.0, 0.5)
		Local collision:BlockyCollision = GetClosestCollision(p, downVec)
		If collision <> Null
			p.onGround = True
		End
		
		Local rightVec:Vec2 = New Vec2(0.5, 0.0)
		collision = GetClosestCollision(p, rightVec)
		If collision <> Null
			p.huggingRight = True
		End
		
		Local leftVec:Vec2 = New Vec2(-0.5, 0.0)
		collision = GetClosestCollision(p, leftVec)
		If collision <> Null
			p.huggingLeft = True
		End
		
		'TODO deduce this from the former collision
		For Local movingPlatform := Eachin currentLevel.movingPlatforms
			Local response:Response = New Response()
			If SAT.TestPolygonPolygon(p.DetectionBox().ToPolygon(), movingPlatform.Rect().ToPolygon(), response)
				p.onMovingPlatform = movingPlatform
				Exit
			End
		End
	End
End



Function Main()
	New PfGame()
End