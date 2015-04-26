Import rect
Import ray

'TODO merge in this functionality with Collidable
'Maybe HazardBlocks should instead be modeled as CollidableHazards? They don't need any of the other blocky functionality
Interface CollidableHazard
	Method CollidesWithRay:Bool(ray:Ray)
	Method Draw()
End