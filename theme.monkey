Import mojo
Import backgroundlayer
Import sat.vec2
Import tileimage

Interface Theme
	Method BackgroundLayers:Stack<BackgroundLayer>()
	Method TileImageForCode:TileImage(tileCode:String)
End