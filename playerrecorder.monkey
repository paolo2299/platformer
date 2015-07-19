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
	
	Field debug:Bool = False
	
	Method New(player:Player = Null, debug:Bool = False)
		Self.player = player
		Self.debug = debug
		If player <> Null
			playerSprite = New PlayerSprite(player.width, player.height)
		End
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
			If debug
				Debug(player)
			End
			totalRecordings += 1
		End
	End
	
	Method Debug(player:Player)
		DebugVec(player.position)
		DebugVec(player.velocity)
		DebugBool(player.onGround)
		DebugBool(player.huggingLeft)
		DebugBool(player.huggingRight)
		If player.grapple.engaged
			DebugVec(player.grapple.hookPos)
		Else
			DebugNull()
		End
	End
	
	
	Method DebugVec(vec:Vec2)
		Print vec.x + "," + vec.y
	End
	
	Method DebugBool(b:Bool)
		If b
			Print "true"
		Else
			Print "false"
		End
	End
	
	Method DebugNull()
		Print "null"
	End
	
	Method UpdateForPlayback(loop:Bool = False)
		If playbackPos < totalRecordings - 1
			playbackPos += 1
		Elseif loop
			playbackPos = 0
		End
	End
	
	Method PlayBack(faded:Bool = True)
		If faded
			SetColor(100, 100, 100)
		Else
			SetColor(255, 255, 255)
		End
		Local position:Vec2 = playerPositions.Get(playbackPos)
		Local velocity:Vec2 = playerVelocities.Get(playbackPos)
		Local onGround:Bool = playerOnGround.Get(playbackPos)
		Local huggingLeft:Bool = playerHuggingLeft.Get(playbackPos)
		Local huggingRight:Bool = playerHuggingRight.Get(playbackPos)
		Local grappleHookPos:Vec2 = grappleHookPositions.Get(playbackPos)

		playerSprite.Draw(position, velocity, onGround, huggingLeft, huggingRight)
		If grappleHookPos <> Null
			SetColor(0, 255, 0)
			DrawLine(position.x, position.y, grappleHookPos.x, grappleHookPos.y)
		End
	End
	
	Method LoadFromFile(fileName:String)
		Print "Loading"
		Local filePath:String = "monkey://data/playerrecordings/" + fileName
		Local rows:String[] = mojo.LoadString(filePath).Split("~n")
		Local rowNum := 1
		For Local row:String = Eachin rows
			If row = ""
				Print "Finished loading"
				Return
			End
			If (rowNum Mod 6) = 1
				totalRecordings += 1
				playerPositions.Push(ParseVec2(row))
			Elseif (rowNum Mod 6) = 2
				playerVelocities.Push(ParseVec2(row))
			Elseif (rowNum Mod 6) = 3
				playerOnGround.Push(ParseBool(row))
			Elseif (rowNum Mod 6) = 4
				playerHuggingLeft.Push(ParseBool(row))
			Elseif (rowNum Mod 6) = 5
				playerHuggingRight.Push(ParseBool(row))
			Elseif (rowNum Mod 6) = 0
				grappleHookPositions.Push(ParseVec2(row))
			End
			rowNum += 1
		End
	End
End
