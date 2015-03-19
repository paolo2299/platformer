Import block

Class GoalBlock Extends Block

	Method New(coordX:Int, coordY:Int, width:Int, height:Int)
		Super.New(coordX, coordY, width, height)
	End
	
	Method SetColor()
		mojo.SetColor(255.0, 255.0, 255.0)
	End
	
	Method IsGoal:Bool()
		Return True
	End

End