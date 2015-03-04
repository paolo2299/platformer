Import config
Import sat.vec2


Class Grapple

 Field handlePos:Vec2 = New Vec2()
 Field hookPos:Vec2 = New Vec2()
 Field extendSpeed:Float = 0.9 * TILE_WIDTH
 Field desiredHookPos:Vec2 = New Vec2()
 
 Field grappleSize:Float = 40.0
 
 Field flying:Bool = False
 Field engaged:Bool = False
 
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
 
 Method Update(playerPosition:Vec2, playerVelocity:Vec2)
 	handlePos.Set(playerPosition.x, playerPosition.y)
 	If flying
 		desiredHookPos.Set(hookPos.x, hookPos.y)
 		desiredHookPos.Add(Direction().Scale(extendSpeed))
 	Elseif engaged
 		desiredHookPos.Set(hookPos.x, hookPos.y)
 	Else
 		'hook is by players side
 		If playerVelocity.x > 0
 			desiredHookPos.Set(handlePos.x, handlePos.y)
 			desiredHookPos.Add(New Vec2(grappleSize, -grappleSize))
 		Elseif playerVelocity.x < 0
 			desiredHookPos.Set(handlePos.x, handlePos.y)
 			desiredHookPos.Add(New Vec2(-grappleSize, -grappleSize))
 		Else
 			desiredHookPos.Set(handlePos.x, handlePos.y)
 			desiredHookPos.Add(New Vec2(0.0, -grappleSize * 1.4))
 		End
 	End
 End
 
 Method Draw()
 	DrawLine(handlePos.x, handlePos.y, hookPos.x, hookPos.y)
 End
	
End