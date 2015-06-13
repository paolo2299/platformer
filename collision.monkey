Import block
Import sat.response
Import ray

Class Collision
	Field ray:Ray
	
	Method New(ray:Ray)
		Self.ray = ray
	End
End

Class BlockyCollision Extends Collision
	Field blocky:Blocky
	
	Method New(ray:Ray, blocky:Blocky)
		Super.New(ray)
		Self.blocky = blocky
	End
	
	Method OnTopOrBottom:Bool()
		Return blocky.Rect().IsOnTopOrBottom(ray.destination)
	End
	
	Method OnCorner:Bool()
		Return blocky.Rect().IsOnCorner(ray.destination)
	End
End

