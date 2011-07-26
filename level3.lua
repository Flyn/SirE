require "level"
Level3 = Level:create()

Level3.title = "Jump Level"

function Level3:createTiles()

	local tileImg = love.graphics.newImage("level1_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	self.tilesetBatch = {love.graphics.newSpriteBatch(tileImg, 150)}
		
	local defaulthm = TileHeightmap.create({5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}, 0)
	
	local basic_chunk = TileChunk.autoCreate(tileImg, 0, 0, 2, 3, defaulthm)

	self.chunks[11][6] = basic_chunk
	self.chunks[22][7] = basic_chunk
	self.chunks[1][10] = basic_chunk
	
end

function Level3:createObjects()
	self.objects = {}
	local mainCharSprite = CharacterSprite.create("ninja")
	local mainChar = Character.create(mainCharSprite)
	table.insert(self.objects, mainChar)
	self.mainChar = mainChar
end

function Level3:populateLevel()
	self.mainChar.xpos = 20
	self.mainChar.ypos = 20
end
