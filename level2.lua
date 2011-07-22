require "level"
Level2 = Level:create()

Level2.title = "Wall Level"

function Level2:createTiles()

	local tileImg = love.graphics.newImage("level2_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	self.tilesetBatch = love.graphics.newSpriteBatch(tileImg, 150)
	
	local defaulthm = TileHeightmap.create({15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15}, 0)
	
	local floor_chunk = TileChunk.create(5, 6)
    
    floor_top = Tile.createTemplate(TileSprite.create(tileImg, 16, 0, 16, 16), defaulthm)
    floor_body = Tile.createTemplate(TileSprite.create(tileImg, 16, 16, 16, 16))
    
    for x = 0,4 do
	    floor_chunk:setTile(x, 0, floor_top)
	    for y = 1,5 do
			floor_chunk:setTile(x, y, floor_body)
		end
    end
    
    self.chunks[1][15] = floor_chunk
    self.chunks[6][15] = floor_chunk
    
    slope_chunk = TileChunk.create(4, 4)
    
	slope_0_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*0, 16*3, 16, 16), TileHeightmap.create({15,15,15,15,15,15,15,15,15,15,14,14,14,14,13,13}, 6))
	slope_1_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*1, 16*3, 16, 16), TileHeightmap.create({13,13,12,12,12,11,11,11,10,10, 9, 9, 8, 8, 7, 7}, 23))
	slope_2_2 = Tile.createTemplate(TileSprite.create(tileImg, 16*2, 16*2, 16, 16), TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,16,15,14,13,12,11}, 45))
	slope_2_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*2, 16*3, 16, 16), TileHeightmap.create({ 6, 6, 5, 4, 4, 4, 3, 2, 2, 1, 0, 0, 0, 0, 0, 0}, 34))
	slope_3_0 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 0, 16, 16), TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,16,16,16,14,10, 0}, 84))
	slope_3_1 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 16, 16, 16), TileHeightmap.create({16,16,16,16,16,16,16,14,12,10, 8, 6, 3, 0, 0, 0}, 68))
	slope_3_2 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 16*2, 16, 16), TileHeightmap.create({11,10, 8, 7, 5, 4, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0}, 56))
	slope_3_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 16*3, 16, 16))
	
	slope_chunk:setTile(0, 3, slope_0_3)
	slope_chunk:setTile(1, 3, slope_1_3)
	slope_chunk:setTile(2, 2, slope_2_2)
	slope_chunk:setTile(2, 3, slope_2_3)
	slope_chunk:setTile(3, 0, slope_3_0)
	slope_chunk:setTile(3, 1, slope_3_1)
	slope_chunk:setTile(3, 2, slope_3_2)
	slope_chunk:setTile(3, 3, slope_3_3)

	self.chunks[11][12] = slope_chunk
	
	wall_chunk = TileChunk.create(4, 5)
	for x = 0,4 do
		for y = 0,4 do
			wall_chunk:setTile(x, y, floor_body)
		end
	end
	
	self.chunks[11][16] = wall_chunk
	self.chunks[15][7] = wall_chunk
	self.chunks[15][12] = wall_chunk
	self.chunks[15][16] = wall_chunk
	
end

function Level2:createObjects()
	self.objects = {}
	local mainCharSprite = CharacterSprite.create("ninja")
	local mainChar = Character.create(mainCharSprite)
	table.insert(self.objects, mainChar)
	self.mainChar = mainChar
end

function Level2:populateLevel()
	self.mainChar.xpos = 20
	self.mainChar.ypos = 20
end
