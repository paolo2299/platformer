Import mojo

Class StopWatch

	Field started:Int
	Field stopped:Int = -1

	Method New()
		started = Millisecs()
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
	
	Method ElapsedString:String()
	    Local elapsed:Int = Elapsed()
		Local wholeSeconds:String = String(elapsed / 1000)
		Local remainder:String = String((elapsed Mod 1000) / 10)
		If remainder.Length() < 2
			remainder = "0" + remainder
		End 
		Return wholeSeconds + "." + remainder 
	End
End