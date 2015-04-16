Import mojo
Import backgroundlayer
Import sat.vec2

Interface Theme
	Method BackgroundLayers:Stack<BackgroundLayer>()
	Method ImageForTileCode:Image(tileCode:String)
	Method OffsetForTileCode:Vec2(tileCode:String) 'TODO will probably have to change this concept for something else (scale instead?) to allow spritesheets of equal size sprites
End