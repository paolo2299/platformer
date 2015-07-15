Import player

Class PlayerRecorder
	
	Field player:Player
	Field playerSprite:PlayerSprite
	Field playerPositions:Stack<Vec2> = New Stack<Vec2>()
	Field playerVelocities:Stack<Vec2> = New Stack<Vec2>()
	Field playerOnGround:Stack<Bool> = New Stack<Bool>()
	Field playerHuggingLeft:Stack<Bool> = New Stack<Bool>()
	Field playerHuggingRight:Stack<Bool> = New Stack<Bool>()
	Field grappleHookPositions:Stack<Vec2> = New Stack<Vec2>()
	Field totalRecordings:Int = 0
	
	Field maxRecordings = 60 * 60 * 2 '2 minutes
	
	Field playbackPos:Int = 0
	
	Method New(player:Player)
		Self.player = player
		playerSprite = New PlayerSprite(player.width, player.height)
	End
	
	Method Reset()
		playerPositions.Clear()
		playerVelocities.Clear()
		playerOnGround.Clear()
		playerHuggingLeft.Clear()
		playerHuggingRight.Clear()
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
			playerVelocities.Push(player.velocity.Clone())
			playerOnGround.Push(player.onGround)
			playerHuggingLeft.Push(player.huggingLeft)
			playerHuggingRight.Push(player.huggingRight)
			If player.grapple.engaged
				grappleHookPositions.Push(player.grapple.hookPos.Clone())
			Else
				grappleHookPositions.Push(Null)
			End
			totalRecordings += 1
		End
	End
	
	Method UpdateForPlayback()
		If playbackPos < totalRecordings - 1
			playbackPos += 1
		End
	End
	
	Method PlayBack()
		SetColor(100, 100, 100)
		Local position:Vec2 = playerPositions.Get(playbackPos)
		Local velocity:Vec2 = playerVelocities.Get(playbackPos)
		Local onGround:Bool = playerOnGround.Get(playbackPos)
		Local huggingLeft:Bool = playerHuggingLeft.Get(playbackPos)
		Local huggingRight:Bool = playerHuggingRight.Get(playbackPos)
		Local grappleHookPos:Vec2 = grappleHookPositions.Get(playbackPos)

		playerSprite.Draw(position, velocity, onGround, huggingLeft, huggingRight)
		If grappleHookPos <> Null
			DrawLine(position.x, position.y, grappleHookPos.x, grappleHookPos.y)
		End
	End
End
