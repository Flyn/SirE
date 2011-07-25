require "level"
Level2 = Level:create()

Level2.title = "Wall Level"

function Level2:createTiles()

	local tileImg = love.graphics.newImage("level2_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	self.tilesetBatch = love.graphics.newSpriteBatch(tileImg, 250)
	
	local floorhm = TileHeightmap.create({15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15}, 0)
	
	local floor_chunk = TileChunk.create(5, 6)
    
    floor_top = Tile.createTemplate(TileSprite.create(tileImg, 16, 0, 16, 16), floorhm, TileHeightmap.create({16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, 0))
    floor_body = Tile.createTemplate(TileSprite.create(tileImg, 16, 16, 16, 16))
    
    for x = 0,4 do
	    floor_chunk:setTile(x, 0, floor_top)
	    for y = 1,5 do
			floor_chunk:setTile(x, y, floor_body)
		end
    end
    
    self.chunks[1][20] = floor_chunk
    self.chunks[6][20] = floor_chunk
    self.chunks[11][20] = floor_chunk
    
    slope_chunk = TileChunk.create(4, 4)
    
	slope_0_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*0, 16*3, 16, 16), TileHeightmap.create({15,15,15,15,15,15,15,15,15,15,14,14,14,14,13,13}, 6))
	slope_1_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*1, 16*3, 16, 16), TileHeightmap.create({13,13,12,12,12,11,11,11,10,10, 9, 9, 8, 8, 7, 7}, 23))
	slope_2_2 = Tile.createTemplate(TileSprite.create(tileImg, 16*2, 16*2, 16, 16), TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,16,15,14,13,12,11}, 45),TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,15,14,13,12,11,10}, 45))
	slope_2_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*2, 16*3, 16, 16), TileHeightmap.create({ 6, 6, 5, 4, 4, 4, 3, 2, 2, 1, 0, 0, 0, 0, 0, 0}, 34))
	slope_3_0 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 0, 16, 16), TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,16,16,16,14,10, 0}, 84),TileHeightmap.create({15,15,15,15,15,15,15,15,14,14,14,14,14,13,13,13}, 84))
	slope_3_1 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 16, 16, 16), TileHeightmap.create({16,16,16,16,16,16,16,14,12,10, 8, 6, 3, 0, 0, 0}, 68),TileHeightmap.create({13,13,12,12,12,11,11,11,10,10, 9, 9, 8, 8, 7, 7}, 68))
	slope_3_2 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 16*2, 16, 16), TileHeightmap.create({11,10, 8, 7, 5, 4, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0}, 56),TileHeightmap.create({ 7, 7, 6, 5, 5, 4, 3, 2, 2, 1, 0, 0, 0, 0, 0, 0}, 56))
	slope_3_3 = Tile.createTemplate(TileSprite.create(tileImg, 16*3, 16*3, 16, 16))
	
	slope_chunk:setTile(0, 3, slope_0_3)
	slope_chunk:setTile(1, 3, slope_1_3)
	slope_chunk:setTile(2, 2, slope_2_2)
	slope_chunk:setTile(2, 3, slope_2_3)
	slope_chunk:setTile(3, 0, slope_3_0)
	slope_chunk:setTile(3, 1, slope_3_1)
	slope_chunk:setTile(3, 2, slope_3_2)
	slope_chunk:setTile(3, 3, slope_3_3)

	self.chunks[15][17] = slope_chunk
	
	slope_chunk2 = TileChunk.create(4, 4)
	
	slope_chunk2:setTile(0, 0, slope_0_3, false, true)
	slope_chunk2:setTile(1, 0, slope_1_3, false, true)
	slope_chunk2:setTile(2, 1, slope_2_2, false, true)
	slope_chunk2:setTile(2, 0, slope_2_3, false, true)
	slope_chunk2:setTile(3, 3, slope_3_0, false, true)
	slope_chunk2:setTile(3, 2, slope_3_1, false, true)
	slope_chunk2:setTile(3, 1, slope_3_2, false, true)
	slope_chunk2:setTile(3, 0, slope_3_3, false, true)
	
	self.chunks[15][7] = slope_chunk2
	
	rwall_chunk = TileChunk.create(4, 5)
	for x = 0,4 do
		for y = 0,4 do
			rwall_chunk:setTile(x, y, floor_body)
		end
	end
	
	self.chunks[15][21] = rwall_chunk
	self.chunks[19][12] = rwall_chunk
	self.chunks[19][17] = rwall_chunk
	self.chunks[19][21] = rwall_chunk
	self.chunks[19][7] = rwall_chunk
	
	ceil_chunk = TileChunk.create(4, 5)
	for x = 0,4 do
		for y = 0,4 do
			ceil_chunk:setTile(x, y, floor_body, false, true)
		end
	end
	
	self.chunks[19][2] = ceil_chunk
	self.chunks[15][2] = ceil_chunk
	self.chunks[11][2] = ceil_chunk
	self.chunks[7][2] = ceil_chunk
	
	slope_chunk3 = TileChunk.create(4, 4)
	
	slope_chunk3:setTile(3, 0, slope_0_3, true, true)
	slope_chunk3:setTile(2, 0, slope_1_3, true, true)
	slope_chunk3:setTile(1, 1, slope_2_2, true, true)
	slope_chunk3:setTile(1, 0, slope_2_3, true, true)
	slope_chunk3:setTile(0, 3, slope_3_0, true, true)
	slope_chunk3:setTile(0, 2, slope_3_1, true, true)
	slope_chunk3:setTile(0, 1, slope_3_2, true, true)
	slope_chunk3:setTile(0, 0, slope_3_3, true, true)
	
	self.chunks[7][7] = slope_chunk3
	
	lwall_chunk = TileChunk.create(4, 5)
	for x = 0,4 do
		for y = 0,4 do
			lwall_chunk:setTile(x, y, floor_body, true, false)
		end
	end
	
	self.chunks[3][2] = lwall_chunk
	self.chunks[3][7] = lwall_chunk
	self.chunks[3][11] = lwall_chunk
	self.chunks[3][16] = lwall_chunk
	
	slope_chunk4 = TileChunk.create(4, 4)
	
	slope_chunk4:setTile(3, 3, slope_0_3, true, false)
	slope_chunk4:setTile(2, 3, slope_1_3, true, false)
	slope_chunk4:setTile(1, 2, slope_2_2, true, false)
	slope_chunk4:setTile(1, 3, slope_2_3, true, false)
	slope_chunk4:setTile(0, 0, slope_3_0, true, false)
	slope_chunk4:setTile(0, 1, slope_3_1, true, false)
	slope_chunk4:setTile(0, 2, slope_3_2, true, false)
	slope_chunk4:setTile(0, 3, slope_3_3, true, false)
	
	self.chunks[7][17] = slope_chunk4
	
end

function Level2:createObjects()
	self.objects = {}
	local mainCharSprite = CharacterSprite.create("ninja")
	local mainChar = Character.create(mainCharSprite)
	table.insert(self.objects, mainChar)
	self.mainChar = mainChar
end

function Level2:populateLevel()
	self.mainChar.xpos = 200
	self.mainChar.ypos = 200
end
