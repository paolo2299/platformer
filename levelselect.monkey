Const LEVEL_SELECT_MAX_LEVEL := 9
Const LEVEL_SELECT_MIN_LEVEL := 1

Class LevelSelect
	Field level:Int = 1
	
	Method IncrementLevel()
		If level < LEVEL_SELECT_MAX_LEVEL
			level += 1
		End
	End
	
	Method DecrementLevel()
		If level > LEVEL_SELECT_MIN_LEVEL
			level -= 1
		End
	End
End