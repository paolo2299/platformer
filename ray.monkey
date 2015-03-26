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
	
	Method Length:Float()
		Return offset.Length()
	End
	
	Method ToPolygon:Polygon()
		Return New Polygon(origin.x, origin.y, New VecStack([
			New Vec2(), New Vec2(offset.x, offset.y)]))
	End
End

Function RayFromOffset:Ray(origin:Vec2, offset:Vec2)
	Local destination:Vec2 = origin.Clone().Add(offset)
	Return New Ray(origin, destination)
End

Function RayFromOriginDirectionSize:Ray(origin:Vec2, direction:Vec2, size:Float)
	Local offset:Vec2 = direction.Clone().Scale(size)
	Local destination:Vec2 = origin.Clone().Add(offset)		 
		
	Return New Ray(origin, destination)
End