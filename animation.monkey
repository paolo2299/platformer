Import mojo

Class Animation	
	Field frameOffset:Int
	
	Field startTime:Int
	Field numFrames:Int
	Field frameLength:Int

	Method New(frameOffset:Int, numFrames:Int, fps:Int)
		Self.frameOffset = frameOffset
		
		startTime = Millisecs()
		Self.numFrames = numFrames
		frameLength = 1000 / fps
	End
	
	Method Reset()
		startTime = Millisecs()
	End
	
	Method GetFrame:Int()
		Local timeNow:Int = Millisecs()
		Local frameNum:Int = ((timeNow - startTime) / frameLength) Mod numFrames
		Return frameOffset + frameNum
	End
End