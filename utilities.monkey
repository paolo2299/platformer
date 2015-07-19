Import ray
Import rect
Import sat.vec2
Import vec

Function RaysForMovement:Stack<Ray>(rect:Rect, movementVec:Vec2)
	Local rays:Stack<Ray> = New Stack<Ray>()
	If movementVec.x > 0
		rays.Push(RayFromOffset(rect.rightCentre, movementVec))
		rays.Push(RayFromOffset(rect.botRight, movementVec))
		rays.Push(RayFromOffset(rect.topRight, movementVec))
	End
	If movementVec.x < 0
		rays.Push(RayFromOffset(rect.leftCentre, movementVec))
		rays.Push(RayFromOffset(rect.botLeft, movementVec))
		rays.Push(RayFromOffset(rect.topLeft, movementVec))
	End
	If movementVec.y > 0
		rays.Push(RayFromOffset(rect.botCentre, movementVec))
		If movementVec.x <= 0
			rays.Push(RayFromOffset(rect.botRight, movementVec))
		End
		If movementVec.x >= 0
			rays.Push(RayFromOffset(rect.botLeft, movementVec))
		End
	End
	If movementVec.y < 0
		rays.Push(RayFromOffset(rect.topCentre, movementVec))
		If movementVec.x <= 0
			rays.Push(RayFromOffset(rect.topRight, movementVec))
		End
		If movementVec.x >= 0
			rays.Push(RayFromOffset(rect.topLeft, movementVec))
		End
	End
	Return rays
End

Function SurroundingCoordsForCoord:Vec2Di[](coord:Vec2Di)
	Local coordArray:Vec2Di[8]
	
	coordArray[0] = New Vec2Di(coord.x, coord.y + 1)  'coord below
	coordArray[1] = New Vec2Di(coord.x, coord.y - 1)  'coord above
	coordArray[2] = New Vec2Di(coord.x - 1, coord.y)  'coord left
	coordArray[3] = New Vec2Di(coord.x + 1, coord.y)  'coord right
	coordArray[4] = New Vec2Di(coord.x - 1, coord.y - 1)  'coord up left
	coordArray[5] = New Vec2Di(coord.x + 1, coord.y - 1)  'coord up right
	coordArray[6] = New Vec2Di(coord.x - 1, coord.y + 1)  'coord down left
	coordArray[7] = New Vec2Di(coord.x + 1, coord.y + 1)  'coord down right
		
	Return coordArray
End

'Implicity assumes startRect and endRect are the same dimensions
Function RaysForMovement:Stack<Ray>(startRect:Rect, endRect:Rect)
	Local movementVec:Vec2 = endRect.topLeft.Clone().Sub(startRect.topLeft)
	Return RaysForMovement(startRect, movementVec)
End

Function PrintVec(desc: String, v:Vec2)
	Print desc + ": " + v.x + "," + v.y
End

Function TileCoordFromPoint:Vec2Di(point:Vec2, tileWidth:Int, tileHeight:Int)
	Local tileX:Int = point.x / tileWidth
	Local tileY:Int = point.y / tileHeight
		
	Return New Vec2Di(tileX, tileY)
End

Function PrintRect(desc:String, r:Rect)
    Print desc
	PrintVec("topLeft", r.topLeft)
	PrintVec("topRight", r.topRight) 
	PrintVec("botLeft", r.botLeft) 
	PrintVec("botRight", r.botRight) 
End

Function FormatMillisecs:String(millisecs:Int)
	Local wholeSeconds:String = String(millisecs / 1000)
	Local remainder:String = String((millisecs Mod 1000) / 10)
	If remainder.Length() < 2
		remainder = "0" + remainder
	End
	Return wholeSeconds + "." + remainder 
End

Function ParseVec2:Vec2(s:String)
	Local trimmed := s.Trim()
	If trimmed = "null"
		Return Null
	End
	Local data:String[] = s.Split(",")
	Local x:Float = Float(data[0].Trim())
	Local y:Float = Float(data[1].Trim())
	Return New Vec2(x, y)
End

Function ParseBool:Bool(s:String)
	Local trimmed := s.Trim()
	If trimmed = "true"
		Return True
	End
	Return False
End