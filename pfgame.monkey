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

Const STATE_MENU:Int = 0
Const STATE_LEVEL_CHOICE = 1
Const STATE_GAME:Int = 2
Const STATE_LEVEL_COMPLETE = 3
Const STATE_DEATH:Int = 4


Class PfGame Extends App
	
	Field player:Player
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
					player = New Player(currentLevel)
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
	        			player = New Player(currentLevel)
	        			camera.Update(player, currentLevel)
	        			gameState = STATE_GAME
			Case STATE_DEATH
				player.Reset()
				camera.Update(player, currentLevel)
				gameState = STATE_GAME
		End
	End
	
	
	Method FirstLevel:Level()
		Return New Level(1)
	End
	
	Method IncrementLevel()
		currentLevel = New Level(currentLevel.levelNumber + 1)
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
	    End
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
	
	Method UpdatePlayer(player:Player)
		player.Update()
		
		CheckForAndResolveCollisions(player)
		DetectNearbySurfaces(player)
		
		UpdateGrapple(player)
	End
	
	Method UpdateGrapple(player:Player)
	    Local grapple:Grapple = player.grapple
		grapple.Update(player.position)
		If grapple.flying
			Local collision:Collision = currentLevel.collisionMap.RayCastCollision(grapple.FlyingRay())
			If collision <> Null
				grapple.Engage(collision.ray.destination)
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
	
	Method GetClosestCollision:Collision(p: Player, movementVec: Vec2)
		Local pRect:Rect = p.BoundingBox()
		Local rays:Stack<Ray> = New Stack<Ray>()
		
		If movementVec.x > 0
			rays.Push(RayFromOffset(pRect.rightCentre, movementVec))
			rays.Push(RayFromOffset(pRect.botRight, movementVec))
			rays.Push(RayFromOffset(pRect.topRight, movementVec))
		End
		If movementVec.x < 0
			rays.Push(RayFromOffset(pRect.leftCentre, movementVec))
			rays.Push(RayFromOffset(pRect.botLeft, movementVec))
			rays.Push(RayFromOffset(pRect.topLeft, movementVec))
		End
		If movementVec.y > 0
			rays.Push(RayFromOffset(pRect.botCentre, movementVec))
			If movementVec.x <= 0
				rays.Push(RayFromOffset(pRect.botRight, movementVec))
			End
			If movementVec.x >= 0
				rays.Push(RayFromOffset(pRect.botLeft, movementVec))
			End
		End
		If movementVec.y < 0
			rays.Push(RayFromOffset(pRect.topCentre, movementVec))
			If movementVec.x <= 0
				rays.Push(RayFromOffset(pRect.topRight, movementVec))
			End
			If movementVec.x >= 0
				rays.Push(RayFromOffset(pRect.topLeft, movementVec))
			End
		End
		
		Local closestCollision:Collision = Null
		For Local ray := Eachin rays
			Local collision:Collision = currentLevel.collisionMap.RayCastCollision(ray)
			If collision <> Null
				'PrintVec("potential ray origin", collision.ray.origin)
				'PrintVec("potential ray destination", collision.ray.destination)
				If closestCollision = Null
					closestCollision = collision
				Elseif closestCollision.ray.Length() > collision.ray.Length()
				'	Print "shortest!"
					closestCollision = collision
				End
			End
		End
		Return closestCollision
	End
	
	Method CheckForAndResolveCollisions(p: Player)		
		Local movementVec:Vec2 = p.MovementVector()
		
		Local closestCollision:Collision = GetClosestCollision(p, movementVec)
		If closestCollision = Null
			'no collision
			p.position.Add(movementVec)
			Return
		End
		
		'there was a collision
		Local stateChanged:Bool = UpdateGameStateForCollision(closestCollision)
		If stateChanged
			Return
		End
		
		'Print("collision!")
		'PrintVec("player position before first offset", p.position)
		
		p.position.Add(closestCollision.ray.offset)
		
		'PrintVec("player position after first offset", p.position)
		
		'see if we can maintain momentum
		If closestCollision.TopOrBottomOfBlock()
		'	PrintVec("movement vec before", movementVec)
		'	PrintVec("ray origin", closestCollision.ray.origin)
		'	PrintVec("ray destination", closestCollision.ray.destination)
		'	PrintVec("ray offset", closestCollision.ray.offset)
			movementVec.y = 0
			movementVec.x -= closestCollision.ray.offset.x
		'	PrintVec("movement vec after", movementVec)
			p.velocity.y = 0
		Else
			movementVec.x = 0
			movementVec.y -= closestCollision.ray.offset.y
			p.velocity.x = 0
		End
		
		closestCollision = GetClosestCollision(p, movementVec)
		If closestCollision = Null
		'	Print("no second collision")
			p.position.Add(movementVec)
		Else
			Local stateChanged:Bool = UpdateGameStateForCollision(closestCollision)
			If stateChanged
				Return
			End
		'	Print("second collision!")
		'	PrintVec("ray offset", closestCollision.ray.offset)
			p.position.Add(closestCollision.ray.offset)
		End
		'PrintVec("final player position", p.position)
	End
	
	Method UpdateGameStateForCollision:Bool(collision:Collision)
		If collision.block.IsHazard()
			gameState = STATE_DEATH
			Return True
		End
		If collision.block.IsGoal()
			gameState = STATE_LEVEL_COMPLETE
			Return True
		End
		Return False
	End
	
	Method DetectNearbySurfaces(p: Player)
		p.onGround = False
		p.huggingLeft = False
		p.huggingRight = False
	
		Local downVec:Vec2 = New Vec2(0.0, 0.5)
		Local collision:Collision = GetClosestCollision(p, downVec)
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
	End
End



Function Main()
	New PfGame()
End