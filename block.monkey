Import mojo
Import config
Import vec

Class Block

	Field coord:Vec2Di = New Vec2Di()
	Field position:Vec2D = New Vec2D()
	
	Method New(coordX:Int, coordY:Int)
		coord.Set(coordX, coordY)
		position.Set(TILE_WIDTH*coordX + TILE_WIDTH/2, TILE_HEIGHT*coordY + TILE_HEIGHT/2)
	End
	
	Method Draw()
		SetColor(0, 0, 255)
    	DrawRect(position.x - TILE_WIDTH/2, position.y - TILE_HEIGHT/2, TILE_WIDTH, TILE_HEIGHT)
	End

End