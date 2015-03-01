Import mojo
Import config
Import vec
Import rect

Class Player

	Field position:Vec2D = New Vec2D()
	Field desiredPosition:Vec2D = New Vec2D()	
	Field originalPos:Vec2D = New Vec2D()
	Field velocity:Vec2D = New Vec2D()

	Field gravity:Float = 0.0125 * TILE_HEIGHT
	Field wallGravity:Float = 0.01 * TILE_HEIGHT
	
    Field accelerationRunning:Float = 0.021875 * TILE_WIDTH
	Field maxVelocityXRunning:Float = 0.46875 * TILE_WIDTH
	Field accelerationWalking:Float = 0.010975 * TILE_WIDTH
	Field oppositeDirectionAccelerationBoost:Float = 1.5
	Field maxVelocityXWalking:Float = 0.2345 * TILE_WIDTH
	Field maxVelocityY:Float = 0.49 * TILE_HEIGHT
	
	Field jumpForce:Float = 0.3825 * TILE_HEIGHT
	Field jumpCutoff:Float = 0.10 * TILE_HEIGHT
	Field wallJumpXForceWalking:Float = 0.3 * TILE_WIDTH
	Field wallJumpXForceRunning:Float = 0.3125 * TILE_WIDTH
	Field wallJumpYForce:Float = 0.42625 * TILE_HEIGHT
	
	Field wallStickMillisecs:Int = 250
	Field millisecsRightHeld:Int = 0
	Field millisecsLeftHeld:Int = 0
	Field minVelocityX:Float = 0.1
	
	Field onGround:Bool = False
	Field huggingLeft:Bool = False
	Field huggingRight:Bool = False
	
	Field lastUpdate:Int = Millisecs()

	Method New(x:Float=0, y:Float=0)
	    Set(x, y)
    End
    
    Method New(pos:Vec2D)
    	Set(pos)
    End
    
    Method Set(x:Float, y:Float)
		position.Set(x, y)
	    originalPos.Set(x, y)
	    UpdateDesiredPosition(x, y)
    End
    
    Method Set(pos:Vec2D)
    	Set(pos.x, pos.y)
    End
    
    Method Reset()
    	position.Set(originalPos.x, originalPos.y)
    	velocity.Set(0, 0)
    End
    
    Method Draw()
    	SetColor(0, 255, 0)
    	DrawRect(position.x - PLAYER_WIDTH/2, position.y - PLAYER_HEIGHT/2, PLAYER_WIDTH, PLAYER_HEIGHT)
    End
    
    Method Update()
    
    	'running vs walking
    	Local acceleration:Float = accelerationWalking
    	Local maxVelocityX:Float = maxVelocityXWalking
    	Local wallJumpXForce:Float = wallJumpXForceWalking
    	If KeyDown(KEY_SHIFT)
    		acceleration = accelerationRunning
    		maxVelocityX = maxVelocityXRunning
    		wallJumpXForce = wallJumpXForceRunning
    	End
    	
        'gravity
        If huggingLeft Or huggingRight
        	velocity.y += wallGravity
        Else
    		velocity.y += gravity
    	End
    	
    	'bookkeeping
    	If KeyDown(KEY_RIGHT)
    		millisecsRightHeld += (Millisecs() - lastUpdate)
    	Else
    		millisecsRightHeld = 0
    	End
    	
    	If KeyDown(KEY_LEFT)
    		millisecsLeftHeld += (Millisecs() - lastUpdate)
    	Else
    		millisecsLeftHeld = 0
    	End
    	
    	'jumping
    	If KeyHit(KEY_SPACE)
    		If onGround
    			velocity.y = -jumpForce
    		Elseif huggingLeft
    			velocity.y = -wallJumpYForce
    			velocity.x = wallJumpXForce
    		Elseif huggingRight
    			velocity.y = -wallJumpYForce
    			velocity.x = -wallJumpXForce
    		End
    	End
    	
    	If Not KeyDown(KEY_SPACE) And (velocity.y < -jumpCutoff)
    		velocity.y = -jumpCutoff
    	End

		'moving left/right    			
    	If KeyDown(KEY_RIGHT)
    		If velocity.x < 0
    			acceleration *= oppositeDirectionAccelerationBoost
    		End
    		If (huggingLeft And Not onGround)
    			If millisecsRightHeld > wallStickMillisecs
					velocity.x += acceleration
				End
			Else
				velocity.x += acceleration
			End
		Elseif KeyDown(KEY_LEFT)
			If velocity.x > 0
    			acceleration *= oppositeDirectionAccelerationBoost
    		End
			If (huggingRight And Not onGround)
    			If millisecsLeftHeld > wallStickMillisecs
					velocity.x -= acceleration
				End
			Else
				velocity.x -= acceleration
			End
		Elseif onGround
			velocity.x = 0
		End
		
		'clamp velocities
		velocity.x = Clamp(velocity.x, -maxVelocityX, maxVelocityX)
		velocity.y = Clamp(velocity.y, -maxVelocityY, maxVelocityY)
		If Abs(velocity.x) < minVelocityX
			velocity.x = 0
		End
		
		'update!
		UpdateDesiredPositionX(position.x + velocity.x)
		UpdateDesiredPositionY(position.y + velocity.y)
		
		lastUpdate = Millisecs()
    End

    Method UpdateDesiredPositionX(x:Float)
    	UpdateDesiredPosition(x, position.y)
    End
    
    Method UpdateDesiredPositionY(y:Float)
    	UpdateDesiredPosition(position.x, y)
    End
    
    Method UpdateDesiredPosition(x:Float, y:Float)
    	desiredPosition.x = x
    	desiredPosition.y = y
    End 
    
    Method CollisionBoundingBox:Rect()
    	Local topLeft:Vec2D = New Vec2D(desiredPosition.x - PLAYER_WIDTH/2, desiredPosition.y - PLAYER_HEIGHT/2)
    	Return New Rect(topLeft, PLAYER_WIDTH, PLAYER_HEIGHT)
    End
       
    Method DetectionBox:Rect()
    	Local topLeft:Vec2D = New Vec2D(desiredPosition.x - PLAYER_WIDTH/2 - 3, desiredPosition.y - PLAYER_HEIGHT/2 - 1)
    	Return New Rect(topLeft, PLAYER_WIDTH + 6, PLAYER_HEIGHT + 2)
    End
End