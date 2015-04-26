Import ray
Import rect
Import sat.vec2

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

'Implicity assumes startRect and endRect are the same dimensions
Function RaysForMovement:Stack<Ray>(startRect:Rect, endRect:Rect)
	Local movementVec:Vec2 = endRect.topLeft.Clone().Sub(startRect.topLeft)
	'PrintRect("startRect", startRect)
	'PrintRect("endRect", endRect)
	'PrintVec("movementVec", movementVec)
	Return RaysForMovement(startRect, movementVec)
End

Function PrintVec(desc: String, v:Vec2)
	Print desc + ": " + v.x + "," + v.y
End

Function PrintRect(desc:String, r:Rect)
    Print desc
	PrintVec("topLeft", r.topLeft)
	PrintVec("topRight", r.topRight) 
	PrintVec("botLeft", r.botLeft) 
	PrintVec("botRight", r.botRight) 
End