Import block

Class HazardBlock Extends Block

	Method New(rect:Rect)
		Super.New(rect)
	End
	
	Method IsHazard:Bool()
		Return True
	End

	Method SetColor()
		mojo.SetColor(255.0, 0.0, 0.0)
	End
	
End