Import block

Class GoalBlock Extends Block

	Method New(rect:Rect)
		Super.New(rect)
	End
	
	Method SetColor()
		mojo.SetColor(255.0, 255.0, 255.0)
	End
	
	Method IsGoal:Bool()
		Return True
	End

End