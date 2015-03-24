Import mojo
Import config
Import vec
Import rect
Import sat.vec2
Import level
Import grapple

Class Player
	Field level:Level

	Field width:Float
	Field height:Float
	Field widthFactor:Float = 1.0
	Field heightFactor:Float = 1.0

	Field position:Vec2 = New Vec2()
	Field desiredPosition:Vec2 = New Vec2()	
	Field originalPos:Vec2 = New Vec2()
	Field velocity:Vec2 = New Vec2()

	Field gravity:Float
	Field wallGravity:Float
	Field gravityFactor:Float = 0.0125
	Field wallGravityFactor:Float = 0.01
	
	Field accelerationRunningFactor:Float = 0.021875
	Field maxVelocityXRunningFactor:Float = 0.46875
	Field accelerationWalkingFactor:Float = 0.010975
	Field maxVelocityXWalkingFactor:Float = 0.2345
	Field maxVelocityYFactor:Float = 0.78
	Field accelerationRunning:Float
	Field maxVelocityXRunning:Float
	Field accelerationWalking:Float
	Field maxVelocityXWalking:Float
	Field maxVelocityY:Float
	Field oppositeDirectionAccelerationBoost:Float = 1.5
	
	Field jumpForceFactor:Float = 0.3825
	Field jumpCutoffFactor:Float = 0.10
	Field wallJumpXForceWalkingFactor:Float = 0.3
	Field wallJumpXForceRunningFactor:Float = 0.3125
	Field wallJumpYForceFactor:Float = 0.42625
	Field jumpForce:Float
	Field jumpCutoff:Float
	Field wallJumpXForceWalking:Float
	Field wallJumpXForceRunning:Float
	Field wallJumpYForce:Float
	
	Field wallStickMillisecs:Int = 250
	Field millisecsRightHeld:Int = 0
	Field millisecsLeftHeld:Int = 0
	Field minVelocityX:Float = 0.1
	
	Field onGround:Bool = False
	Field huggingLeft:Bool = False
	Field huggingRight:Bool = False
	
	Field lastUpdate:Int = Millisecs()
	
	Field grapple:Grapple
	Field grappleExtendSpeedFactor:Float = 1.0 / 8.0
	Field grappleExtendSpeed:Float

	Method New(level:Level)
		Self.level = level
		SetPlayerConstants()
		originalPos = level.playerStartingPosition
		position.Set(originalPos.x, originalPos.y)
		desiredPosition.Set(originalPos.x, originalPos.y)
		grapple = New Grapple(level)
	End
	
	Method SetPlayerConstants()
		Local tileWidth:Float = level.tileWidth
		Local tileHeight:Float = level.tileHeight
		width = widthFactor * tileWidth
		height = heightFactor * tileHeight
		gravity = gravityFactor * tileHeight
		wallGravity = wallGravityFactor * tileHeight
		accelerationRunning = accelerationRunningFactor * tileWidth
		maxVelocityXRunning = maxVelocityXRunningFactor * tileWidth
		accelerationWalking = accelerationWalkingFactor * tileWidth
		maxVelocityXWalking = maxVelocityXWalkingFactor * tileWidth
		maxVelocityY = maxVelocityYFactor * tileHeight
		jumpForce = jumpForceFactor * tileHeight
		jumpCutoff = jumpCutoffFactor * tileHeight
		wallJumpXForceWalking = wallJumpXForceWalkingFactor * tileWidth
		wallJumpXForceRunning = wallJumpXForceRunningFactor * tileWidth
		wallJumpYForce = wallJumpYForceFactor * tileHeight
		grappleExtendSpeed = grappleExtendSpeedFactor * tileWidth
	End

	Method Reset()
		grapple.Undeploy()
		position.Set(originalPos.x, originalPos.y)
		desiredPosition.Set(originalPos.x, originalPos.y)
		velocity.Set(0, 0)
	End
    
	Method Draw()
		SetColor(0, 255, 0)
		DrawRect(position.x - width/2, position.y - height/2, width, height)
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
			velocity.Project(perp)
			
			'jumping
			If KeyHit(KEY_SPACE)
				grapple.Undeploy()
				velocity.y = -jumpForce
			End
			
			'moving left/right    			
			If KeyDown(KEY_RIGHT)
				If velocity.x > 0 Or huggingLeft
					velocity.x += accelerationWalking
				End
			Elseif KeyDown(KEY_LEFT)
				If velocity.x < 0 Or huggingRight
					velocity.x -= accelerationWalking
				End
			End
    		
    		'extend/shorten the grapple
    		If KeyDown(KEY_UP)
    			grapple.Retract(grappleExtendSpeed)
    		Elseif KeyDown(KEY_DOWN)
    			grapple.Extend(grappleExtendSpeed)
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
			If stretched <> 0
				desiredPosition.Add(grapple.Direction().Scale(stretched))
			End
		End
		
		lastUpdate = Millisecs()
    End
    
    Method BoundingBox:Rect()
    	Return New Rect(position.x - width/2, position.y - height/2, width, height)
    End
    
    Method DesiredBoundingBox:Rect()
    	Return New Rect(desiredPosition.x - width/2, desiredPosition.y - height/2, width, height)
    End
    
    Method MovementVector:Vec2()
    	Return desiredPosition.Clone().Sub(position)
    End
       
    Method DetectionBox:Rect()
    	Return New Rect(desiredPosition.x - width/2 - 1, desiredPosition.y - height/2 - 1, width + 2, height + 2)
    End
End