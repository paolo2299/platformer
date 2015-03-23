Import block
Import sat.vec
Import ray

Class Collision
	Field block:Block
	Field ray:Ray
	
	Method New(block: Block, ray:Ray)
		Self.block = block
		Self.ray = ray
	End
End