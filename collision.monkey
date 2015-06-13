Import block
Import sat.vec
Import sat.response
Import ray

Class Collision
	Field collidable:Collidable
	Field ray:Ray
	
	Method New(collidable: Collidable, ray:Ray)
		Self.collidable = collidable
		Self.ray = ray
	End
End
