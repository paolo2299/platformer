Import mojo
Import vec

Class Rect
	Field topLeft:Vec2D
	Field topRight:Vec2D
	Field botLeft:Vec2D
	Field botRight:Vec2D
	Field width:Float
	Field height:Float
	
	Method New(topLeft:Vec2D, width:Float, height:Float)
		Self.topLeft = topLeft
		topRight = New Vec2D(topLeft.x + width, topLeft.y)
		botLeft = New Vec2D(topLeft.x, topLeft.y + height)
		botRight = New Vec2D(topLeft.x + width, topLeft.y + height)
		Self.width = width
		Self.height = height
	End
	
	Method Intersection:Rect(otherRect:Rect)
		Local iTopLeftX:Float = Max(topLeft.x, otherRect.topLeft.x)
		Local iTopLeftY:Float = Max(topLeft.y, otherRect.topLeft.y)
		Local iBotRightX:Float = Min(botRight.x, otherRect.botRight.x)
		Local iBotRightY:Float = Min(botRight.y, otherRect.botRight.y)
		
		If (iTopLeftX < iBotRightX) And (iTopLeftY < iBotRightY)
			Local iTopLeft:Vec2D = New Vec2D(iTopLeftX, iTopLeftY)
			Local iBotRight:Vec2D = New Vec2D(iBotRightX, iBotRightY)
	        Local width:Float = iBotRight.x - iTopLeft.x
	        Local height:Float = iBotRight.y - iTopLeft.y		
			Return New Rect(iTopLeft, width, height)
		End
		Return Null
	End
End