Import mojo
Import level

Class SavedState
	Field stateString:String
	Field stateMap:StringMap<String> = New StringMap<String>()

	Method New(stateString:String)
		Self.stateString = stateString
		BuildStateMap()
	End
	
	Method SetLevelTime(level:Level, time:Int)
		Print "Setting level time: level " + level.levelNumber + " time " + time
		Local result:Bool = stateMap.Set(LevelTimeKey(level), String(time))
		If result
			Print "true"
		Else
			Print "false"
		End
		Save()
	End
	
	Method GetLevelTime:Int(level:Level)
		Local val:String = stateMap.Get(LevelTimeKey(level))
		If val
			Return Int(val)
		Else
			Return -1
		End
	End
	
	Method LevelTimeKey:String(level:Level)
		Return "level" + level.levelNumber + "time"
	End
	
	Method Save()
		BuildStateString()
		Print "saaving stateString: " + stateString
		SaveState(stateString)
	End

	
	Method BuildStateMap()
		Print "building state map:stateString: " + stateString
		stateMap = New StringMap<String>()
		Local lines:String[] = stateString.Split("~n")
		For Local line:String = Eachin lines
			If line = ""
				Exit
			End
			Print "line: " + line
			Local components:String[] = line.Split(":")
			Local key:String = components[0]
			Local value:String = components[1]
			stateMap.Set(key, value)
		End
	End
	
	Method BuildStateString()
		stateString = ""
		For Local node := Eachin stateMap
			Print "node.Key(): " + node.Key()
			Print "node.Value(): " + node.Value()
			
			stateString += (node.Key() + ":" + node.Value() + "~n")
		End
	End
	
	Method Clear()
		stateString = ""
		Print "stateString after emptying: " + stateString
		BuildStateMap()
		Save()
	End
End

Function LoadSavedState:SavedState()
	Local stateString:String = LoadState()
	Print "loaded saved state: " + stateString
	Return New SavedState(stateString)
End