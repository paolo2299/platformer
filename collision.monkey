Import block
Import sat.vec
Import sat.response
Import ray

'TODO - feels like this shoud not need to expose the collidable - you always have access to it?

Class Collision
	Field collidable:Collidable
	Field ray:Ray
	
	Method New(collidable: Collidable, ray:Ray)
		Self.collidable = collidable
		Self.ray = ray
	End
End


