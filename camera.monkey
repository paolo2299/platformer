Import config
Import vec
Import player
Import level

Class Camera

	Field position:Vec2D = New Vec2D()
	
	Method Update(player:Player, level:Level)
		position.Set(player.position)
		position.x = Clamp(position.x, VIRTUAL_WINDOW_WIDTH / 2.0, TILE_WIDTH * level.mapWidth - (VIRTUAL_WINDOW_WIDTH / 2.0))
		position.y = Clamp(position.y, VIRTUAL_WINDOW_HEIGHT / 2.0, TILE_HEIGHT * level.mapHeight - (VIRTUAL_WINDOW_HEIGHT / 2.0))
	End
	
	Method Translation:Vec2D()
		Local translationX:Float = (VIRTUAL_WINDOW_WIDTH / 2.0) - position.x
		Local translationY:Float = (VIRTUAL_WINDOW_HEIGHT / 2.0) - position.y
		
		Return New Vec2D(translationX, translationY)
	End
End