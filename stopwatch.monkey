Import mojo
Import utilities

Class StopWatch

	Field started:Int
	Field initialStarted:Int
	Field stopped:Int = -1

	Method New()
		started = Millisecs()
		initialStarted = started
	End
	
	Method Reset()
		started = Millisecs()
		stopped = -1
	End
	
	Method Stop()
		If stopped = -1
			stopped = Millisecs()
		End
	End
	
	Method Elapsed:Int()
		If stopped <> -1
			Return stopped - started
		End
		Return Millisecs() - started
	End
	
	Method TotalElapsed:Int()
		Return Millisecs() - initialStarted
	End
	
	Method ElapsedString:String()
		Local elapsed:Int = Elapsed()
		Return FormatMillisecs(elapsed)
	End
End