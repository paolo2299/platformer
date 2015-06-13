Import player

Class PlayerRecorder
	
	Field player:Player
	Field playerPositions:Stack<Vec2> = New Stack<Vec2>()
	Field grappleHookPositions:Stack<Vec2> = New Stack<Vec2>()
	Field totalRecordings:Int = 0
	
	Field maxRecordings = 60 * 60 * 2 '2 minutes
	
	Field playbackPos:Int = 0
	
	Method New(player:Player)
		Self.player = player
	End
	
	Method Reset()
		playerPositions.Clear()
		grappleHookPositions.Clear()
		totalRecordings = 0
		playbackPos = 0
	End
	
	Method ResetPlayback()
		playbackPos = 0
	End
	
	Method Record(player:Player)
		If totalRecordings < maxRecordings
			playerPositions.Push(player.position.Clone())
			If player.grapple.engaged
				grappleHookPositions.Push(player.grapple.hookPos.Clone())
			Else
				grappleHookPositions.Push(Null)
			End
			totalRecordings += 1
		End
	End
	
	Method DrawGhostPlayer(playerPos:Vec2, grappleHookPos:Vec2)
		SetColor(100, 100, 100)
		DrawRect(playerPos.x - player.width/2, playerPos.y - player.height/2, player.width, player.height)
		If grappleHookPos <> Null
			DrawLine(playerPos.x, playerPos.y, grappleHookPos.x, grappleHookPos.y)
		End
	End
	
	Method UpdateForPlayback()
		If playbackPos < totalRecordings - 1
			playbackPos += 1
		End
	End
	
	Method PlayBack()
		Local playerPos:Vec2 = playerPositions.Get(playbackPos)
		Local grappleHookPos:Vec2 = grappleHookPositions.Get(playbackPos)
		DrawGhostPlayer(playerPos, grappleHookPos)
	End
End
