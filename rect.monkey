Import mojo
Import sat.vec2
Import sat.rectangle

Class Rect Extends Rectangle
	Field topLeft:Vec2
	Field topRight:Vec2
	Field botLeft:Vec2
	Field botRight:Vec2
	
	Method New(x:Float = 0.0, y:Float = 0.0, width:Float = 0.0, height:Float = 0.0)
		Super.New(x, y, width, height)
		topLeft = New Vec2(x, y)
		topRight = New Vec2(topLeft.x + width, topLeft.y)
		botLeft = New Vec2(topLeft.x, topLeft.y + height)
		botRight = New Vec2(topLeft.x + width, botLeft.y)
	End
	
	Method BottomMiddle:Vec2()
		Return botLeft.Clone().Add(New Vec2(width / 2, 0.0))
	End
	
	Method Intersection:Rect(otherRect:Rect)
		Local iTopLeftX:Float = Max(topLeft.x, otherRect.topLeft.x)
		Local iTopLeftY:Float = Max(topLeft.y, otherRect.topLeft.y)
		Local iBotRightX:Float = Min(botRight.x, otherRect.botRight.x)
		Local iBotRightY:Float = Min(botRight.y, otherRect.botRight.y)
		
		If (iTopLeftX < iBotRightX) And (iTopLeftY < iBotRightY)
	        Local width:Float = iBotRightX - iTopLeftX
	        Local height:Float = iBotRightY - iTopLeftY		
			Return New Rect(iTopLeftX, iTopLeftY, width, height)
		End
		Return Null
	End
End
