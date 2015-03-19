Import block

Class HazardBlock Extends Block

	Method New(coordX:Int, coordY:Int, width:Int, height:Int)
		Super.New(coordX, coordY, width, height)
	End
	
	Method IsHazard:Bool()
		Return True
	End

	Method SetColor()
		mojo.SetColor(255.0, 0.0, 0.0)
	End
	
End