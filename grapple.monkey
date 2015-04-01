Import config
Import level
Import sat.vec2
Import ray


Class Grapple

 Field level:Level

 Field handlePos:Vec2 = New Vec2()
 Field hookPos:Vec2 = New Vec2()
 
 Field extendSpeed:Float
 Field grappleSize:Float
 Field maxSize:Float
 Field minSize:Float
 Field extendSpeedFactor:Float = 2.5
 Field grappleSizeFactor:Float = 0.8
 Field maxSizeFactor:Float = 10
 Field minSizeFactor:Float = 2
 
 Field millisecsShownFlying:Float
 Field showFlying:Bool = False
 Field flyingRay:Ray
 Field lastUpdate:Float
 
 Field flying:Bool = False
 Field engaged:Bool = False
 Field engagedWith:Collidable = Null
 
 Field engagedLength:Float = 0.0

 Method New(level:Level)
 	Self.level = level
 	SetGrappleConstants()
 End
 
 Method SetGrappleConstants()
 	extendSpeed = extendSpeedFactor * level.tileWidth
 	grappleSize = grappleSizeFactor * level.tileWidth
 	maxSize = maxSizeFactor * level.tileWidth
 	minSize = minSizeFactor * level.tileWidth
 End
 
 Method Vector:Vec2()
 	Return hookPos.Clone().Sub(handlePos)
 End
 
 Method Direction:Vec2()
 	Return Vector().Normalize()
 End
 
 Method Perp:Vec2()
 	Return Vector().Perp().Normalize()
 End
 
 Method Deploy()
 	flying = True
 	showFlying = True
 	flyingRay = FlyingRay()
 	millisecsShownFlying = 0.0
 End
 
 Method Undeploy()
 	flying = False
 	Unengage()
 End
 
 Method Unengage()
 	engaged = False
 	engagedWith = Null
 End
 
 Method Engage(collision:Collision)
 	hookPos = collision.ray.destination
 	engagedLength = Length()
 	ClampLength()
 	flying = False
 	engaged = True
 	engagedWith = collision.collidable
 End
 
 Method Extend(amount:Float)
 	engagedLength = engagedLength + amount
 	ClampLength()
 End
 
 Method Retract(amount:Float)
 	engagedLength = engagedLength - amount
 	ClampLength()
 End
 
 Method ClampLength()
 	engagedLength = Clamp(engagedLength, minSize, maxSize)
 End
 
 Method Undeployed:Bool()
 	Return Not flying And Not engaged
 End
 
 Method Length:Float()
 	Return Vector().Length()
 End
 
 Method FlyingRay:Ray()
 	Return RayFromOriginDirectionSize(handlePos, Direction(), maxSize)
 End
 
 Method Update(playerPosition:Vec2)
 	handlePos.Set(playerPosition.x, playerPosition.y)
 	If engaged
 		engagedLength = Length()
 	End
 	If Not flying And Not engaged
 		PositionHookByPlayersSide(playerPosition)
 	End
 	
 	If showFlying And Not engaged And millisecsShownFlying < 100
    		millisecsShownFlying += (Millisecs() - lastUpdate)
    	Else
    		showFlying = False
    	End
    	
    	lastUpdate = Millisecs()
 End
 
 Method PositionHookByPlayersSide(playerPosition:Vec2)
 	If KeyDown(KEY_RIGHT)
 		hookPos.Set(handlePos.x, handlePos.y)
 		hookPos.Add(New Vec2(grappleSize * 1.5, -grappleSize))
 	Elseif KeyDown(KEY_LEFT)
 		hookPos.Set(handlePos.x, handlePos.y)
 		hookPos.Add(New Vec2(-grappleSize * 1.5, -grappleSize))
 	Else
 		hookPos.Set(handlePos.x, handlePos.y)
 		hookPos.Add(New Vec2(0.0, -grappleSize * 1.6))
 	End
 End
 
 Method Draw()
 	If showFlying And Not engaged
 		SetColor(255, 0, 0)
 		DrawLine(flyingRay.origin.x, flyingRay.origin.y, flyingRay.destination.x, flyingRay.destination.y)
 	End
 	SetColor(0, 255, 0)
 	DrawLine(handlePos.x, handlePos.y, hookPos.x, hookPos.y)
 End
	
End
