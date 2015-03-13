Import config
Import sat.vec2


Class Grapple

 Field handlePos:Vec2 = New Vec2()
 Field hookPos:Vec2 = New Vec2()
 Field extendSpeed:Float = 2.5 * TILE_WIDTH
 
 Field grappleSize:Float = PLAYER_WIDTH * 0.8
 Field maxSize:Float = PLAYER_WIDTH * 10
 Field minSize:Float = PLAYER_WIDTH * 2
 
 Field flying:Bool = False
 Field engaged:Bool = False
 
 Field engagedLength:Float = 0.0
 
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
 End
 
 Method Undeploy()
 	flying = False
 	engaged = False
 End
 
 Method Engage(engagePoint:Vec2)
 	hookPos = engagePoint
 	engagedLength = Length()
 	ClampLength()
 	flying = False
 	engaged = True
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
 
 Method Update(playerPosition:Vec2)
 	handlePos.Set(playerPosition.x, playerPosition.y)
 	If engaged
 		engagedLength = Length()
 	End
 	If Not flying And Not engaged
 		PositionHookByPlayersSide(playerPosition)
 	End
 End
 
 Method PositionHookByPlayersSide(playerPosition:Vec2)
 	If KeyDown(KEY_RIGHT)
 		hookPos.Set(handlePos.x, handlePos.y)
 		hookPos.Add(New Vec2(grappleSize, -grappleSize))
 	Elseif KeyDown(KEY_LEFT)
 		hookPos.Set(handlePos.x, handlePos.y)
 		hookPos.Add(New Vec2(-grappleSize, -grappleSize))
 	Else
 		hookPos.Set(handlePos.x, handlePos.y)
 		hookPos.Add(New Vec2(0.0, -grappleSize * 1.4))
 	End
 End
 
 Method Draw()
 	DrawLine(handlePos.x, handlePos.y, hookPos.x, hookPos.y)
 End
	
End