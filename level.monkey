Import config
Import block.groundblock
Import block.hazardblock
Import block.goalblock
Import collisionmap
Import movingplatform
Import stopwatch
Import sat.vec2
Import theme.mysteryforesttheme

Class Level
	Field levelNumber:Int

	Field playerStartingPosition:Vec2 = New Vec2()
	Field blocks:Stack<Block> = New Stack<Block>()
	Field movingPlatforms:Stack<MovingPlatform> = New Stack<MovingPlatform>()	
	Field collisionMap:CollisionMap
	Field mapWidth:Int
	Field mapHeight:Int
	Field stopWatch:StopWatch = New StopWatch()
	
	Field defaultTileWidth:Int = 28
	Field defaultTileHeight:Int = 28
	Field tileWidth:Int
	Field tileHeight:Int
	
	Field theme:Theme
	
	Method New(number:Int)
		Self.levelNumber = number
		
		GetConfig()
		Print "instantialting mystery forest"
		Self.theme = New MysteryForestTheme(tileWidth, tileHeight) 'TODO get from level config
		GetLayout()
	End
	
	Method LayoutFileString:String()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/layout.txt"
		Return mojo.LoadString(filePath)
	End
	
	Method MovingPlatformsFileString:String()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/movingplatforms.txt"
		Return mojo.LoadString(filePath)
	End
	
	Method GetConfig()
		Local filePath:String = "monkey://data/levels/level" + levelNumber + "/config.txt"
		
		tileWidth = defaultTileWidth
		tileHeight = defaultTileHeight
		
		Local rows:String[] = mojo.LoadString(filePath).Split("~n")
		For Local row:String = Eachin rows
			Local data:String[] = row.Split(",")
			If data[0] = "tileWidth"
				tileWidth = Int(data[1].Trim())
			Elseif data[0] = "tileHeight"
				tileHeight = Int(data[1].Trim())
			End
		End
	End
	
	Method GetLayout()
		SetMapWidthAndMapHeight()
		collisionMap = New CollisionMap(Self)
		
		Local rows:String[] = LayoutFileString().Split("~n")
		Local rowNum:Int = 0
		Local colNum:Int = 0
		For Local row:String = Eachin rows
			Local tiles:String[] = row.Split(",")
			For Local tile:String = Eachin tiles
				Local coordX:Float = colNum * tileWidth
				Local coordY:Float = rowNum * tileHeight
				
				Local rect:Rect = New Rect(coordX, coordY, tileWidth, tileHeight)
				Local imageOffsetX:Float = -0.11
				Local imageOffsetY:Float = -0.09
				
				If tile[..1] = "b" 
					Local tileImage:TileImage = theme.TileImageForCode(tile)
					Local block:Block = New GroundBlock(rect, tileImage)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile[..1] = "h"
					Local tileImage:TileImage = theme.TileImageForCode(tile)
					Local block:Block = New HazardBlock(rect, tileImage)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "g"
					Local block:Block = New GoalBlock(rect)
					blocks.Push(block)
					collisionMap.AddBlock(block, New Vec2Di(colNum, rowNum))
				Elseif tile = "p"
					Local tileRect:Rect = TileRectFromTileCoord(New Vec2Di(colNum, rowNum))
					playerStartingPosition.Set(tileRect.centre.x, tileRect.centre.y)
				End
				colNum += 1
			End
			rowNum += 1
			colNum = 0
		End
		
		'TODO
		rows = MovingPlatformsFileString().Split("~n")
		For Local row:String = Eachin rows
			If row = ""
				Exit
			End
			Local data:String[] = row.Split(",")
			Local originTopLeftX:Float = Float(data[0].Trim()) * tileWidth
			Local originTopLeftY:Float = Float(data[1].Trim()) * tileHeight
			Local destinationTopLeftX:Float = Float(data[2].Trim()) * tileWidth
			Local destinationTopLeftY:Float = Float(data[3].Trim()) * tileHeight
			Local width:Float = Float(data[4].Trim()) * tileWidth  'TODO implement rather than hard code
			Local height:Float = Float(data[5].Trim()) * tileHeight 'TODO remove
			Local speed:Float = Float(data[6].Trim()) * tileWidth
			Local movingPlatform:MovingPlatform = New MovingPlatform(theme, New Vec2(originTopLeftX, originTopLeftY), New Vec2(destinationTopLeftX, destinationTopLeftY), 6, tileWidth, tileHeight, speed)
			movingPlatforms.Push(movingPlatform)
		End
	End
	
	Method SetMapWidthAndMapHeight()
		Local rows:String[] = LayoutFileString().Split("~n")
		mapHeight = rows.Length()
		mapWidth = rows[0].Split(",").Length()
	End
	
	Method TileRectFromTileCoord:Rect(coord:Vec2Di)
		Return New Rect(coord.x * tileWidth, coord.y * tileHeight, tileWidth, tileHeight)
	End
	
	Method Reset()
		For Local movingPlatform := Eachin movingPlatforms
			movingPlatform.Reset()
		End
		stopWatch.Reset()
	End
End
