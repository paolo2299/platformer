Import mojo
Import sat.vec2

Class Rect
	Field topLeft:Vec2
	Field topRight:Vec2
	Field botLeft:Vec2
	Field botRight:Vec2
	Field width:Float
	Field height:Float
	
	Method New(topLeft:Vec2, width:Float, height:Float)
		Self.topLeft = topLeft
		topRight = New Vec2(topLeft.x + width, topLeft.y)
		botLeft = New Vec2(topLeft.x, topLeft.y + height)
		botRight = New Vec2(topLeft.x + width, topLeft.y + height)
		Self.width = width
		Self.height = height
	End
	
	Method Intersection:Rect(otherRect:Rect)
		Local iTopLeftX:Float = Max(topLeft.x, otherRect.topLeft.x)
		Local iTopLeftY:Float = Max(topLeft.y, otherRect.topLeft.y)
		Local iBotRightX:Float = Min(botRight.x, otherRect.botRight.x)
		Local iBotRightY:Float = Min(botRight.y, otherRect.botRight.y)
		
		If (iTopLeftX < iBotRightX) And (iTopLeftY < iBotRightY)
			Local iTopLeft:Vec2 = New Vec2(iTopLeftX, iTopLeftY)
			Local iBotRight:Vec2 = New Vec2(iBotRightX, iBotRightY)
	        Local width:Float = iBotRight.x - iTopLeft.x
	        Local height:Float = iBotRight.y - iTopLeft.y		
			Return New Rect(iTopLeft, width, height)
		End
		Return Null
	End
End