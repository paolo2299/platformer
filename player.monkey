Import mojo
Import config
Import vec
Import rect
Import sat.vec2
Import grapple

Class Player

	Field position:Vec2 = New Vec2()
	Field desiredPosition:Vec2 = New Vec2()	
	Field originalPos:Vec2 = New Vec2()
	Field velocity:Vec2 = New Vec2()

	Field gravity:Float = 0.0125 * TILE_HEIGHT
	Field wallGravity:Float = 0.01 * TILE_HEIGHT
	
    Field accelerationRunning:Float = 0.021875 * TILE_WIDTH
	Field maxVelocityXRunning:Float = 0.46875 * TILE_WIDTH
	Field accelerationWalking:Float = 0.010975 * TILE_WIDTH
	Field oppositeDirectionAccelerationBoost:Float = 1.5
	Field maxVelocityXWalking:Float = 0.2345 * TILE_WIDTH
	Field maxVelocityY:Float = 0.48 * TILE_HEIGHT
	
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
	
	Field grapple:Grapple = New Grapple()
	
	
	Field grapplePerp:Vec2 = New Vec2()
	Field velConstrained:Vec2 = New Vec2()

	Method New(x:Float=0, y:Float=0)
	    Set(x, y)
    End
    
    Method New(pos:Vec2)
    	Set(pos)
    End
    
    Method Set(x:Float, y:Float)
		position.Set(x, y)
	    originalPos.Set(x, y)
	    desiredPosition.Set(x, y)
    End
    
    Method Set(pos:Vec2)
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
    	'gravity
        If huggingLeft Or huggingRight
        	velocity.y += wallGravity
        Else
    		velocity.y += gravity
    	End
    	
    	If grapple.engaged
    		'constrain the velocity to be perpendicular to the grapple direction
			Local perp:Vec2 = grapple.Direction().Perp()
			grapplePerp = perp.Clone()
			velConstrained = velocity.Clone().Project(perp)
			velocity.Project(perp)
			
			'jumping
    		If KeyHit(KEY_SPACE)
    			grapple.Undeploy()
    			velocity.y = -jumpForce
    		End
			
			'moving left/right    			
    		If KeyDown(KEY_RIGHT)
    			If velocity.x > 0
    				velocity.x += accelerationWalking
    			End
			Elseif KeyDown(KEY_LEFT)
    			If velocity.x < 0
    				velocity.x -= accelerationWalking
    			End
    		End
		Else
			'running vs walking
    		Local acceleration:Float = accelerationWalking
    		Local maxVelocityX:Float = maxVelocityXWalking
    		Local wallJumpXForce:Float = wallJumpXForceWalking
    		If KeyDown(KEY_SHIFT)
    			acceleration = accelerationRunning
    			maxVelocityX = maxVelocityXRunning
    			wallJumpXForce = wallJumpXForceRunning
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
			
			'clamp x velocity
			velocity.x = Clamp(velocity.x, -maxVelocityX, maxVelocityX)
    	End
		
		'update grapple interaction
		If KeyHit(KEY_UP) And grapple.Undeployed()
			grapple.Deploy()
		End
		
		'clamp velocities
		velocity.x = Clamp(velocity.x, -maxVelocityXRunning, maxVelocityXRunning)
		velocity.y = Clamp(velocity.y, -maxVelocityY, maxVelocityY)
		If Abs(velocity.x) < minVelocityX
			velocity.x = 0
		End
		
		'update!
		desiredPosition.x = position.x + velocity.x
		desiredPosition.y = position.y + velocity.y
		
		'finally constrain by grapple again
		If grapple.engaged
			Local stretched:Float = desiredPosition.Clone().Sub(grapple.hookPos).Length() - grapple.engagedLength
			If stretched > 0
				Print "grapple.engagedLength: " + grapple.engagedLength
				Print "desiredPosition.Clone().Sub(grapple.hookPos).Length(): " + desiredPosition.Clone().Sub(grapple.hookPos).Length()
				desiredPosition.Add(grapple.Direction().Scale(stretched))
			End
		End
		
		lastUpdate = Millisecs()
    End
    
    Method CollisionBoundingBox:Rect()
    	Return New Rect(desiredPosition.x - PLAYER_WIDTH/2, desiredPosition.y - PLAYER_HEIGHT/2, PLAYER_WIDTH, PLAYER_HEIGHT)
    End
       
    Method DetectionBox:Rect()
    	Return New Rect(desiredPosition.x - PLAYER_WIDTH/2 - 1, desiredPosition.y - PLAYER_HEIGHT/2 - 1, PLAYER_WIDTH + 2, PLAYER_HEIGHT + 2)
    End
End