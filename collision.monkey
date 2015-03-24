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
	
	Method TopOrBottomOfBlock:Bool()
		Local dest:Vec2 = ray.destination
		If (dest.y = block.rect.topLeft.y) Or (dest.y = block.rect.botLeft.y)
			Return True
		End
		Return False
	End
End