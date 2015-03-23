Import sat.vec
Import sat.polygon

Class Ray
	Field origin:Vec2
	Field destination:Vec2
	Field offset:Vec2
	
	Method New(origin:Vec2, destination:Vec2)
		Self.origin = origin
		Self.destination = destination
		offset = destination.Clone().Sub(origin)
	End
	
	Method ToPolygon:Polygon()
		Return New Polygon(origin.x, origin.y, New VecStack([
			New Vec2(), New Vec2(offset.x, offset.y)]))
	End
End