Import mojo
Import config
Import vec
Import sat.vec2

Class Block

	Field coord:Vec2Di = New Vec2Di()
	Field position:Vec2 = New Vec2()
	
	Method New(coordX:Int, coordY:Int)
		coord.Set(coordX, coordY)
		position.Set(TILE_WIDTH*coordX + TILE_WIDTH/2, TILE_HEIGHT*coordY + TILE_HEIGHT/2)
	End
	
	Method IsHazard:Bool()
		Return False
	End
	
	Method SetColor()
		mojo.SetColor(0.0, 0.0, 255.0)
	End
	
	Method Draw()
		Self.SetColor()
    	DrawRect(position.x - TILE_WIDTH/2, position.y - TILE_HEIGHT/2, TILE_WIDTH, TILE_HEIGHT)
	End
End