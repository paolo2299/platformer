Import mojo
Import config
Import vec
Import sat.vec2

Class Block

	Field coord:Vec2Di = New Vec2Di()
	Field position:Vec2 = New Vec2()
	Field width:Int
	Field height:Int
	
	Method New(coordX:Int, coordY:Int, width:Int, height:Int)
		coord.Set(coordX, coordY)
		Self.width = width
		Self.height = height
		position.Set(width*coordX + width/2, height*coordY + height/2)
		
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method IsGoal:Bool()
		Return False
	End
	
	Method SetColor()
		mojo.SetColor(0.0, 0.0, 255.0)
	End
	
	Method Draw()
		Self.SetColor()
    	DrawRect(position.x - width/2, position.y - height/2, width, height)
	End
End