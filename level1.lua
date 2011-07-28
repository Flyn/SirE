require "level"
Level1 = Level:create()

Level1.title = "Slope Level"

function Level1:createTiles()

	local tileImg = love.graphics.newImage("level1_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	self.tilesetBatch = {nil, love.graphics.newSpriteBatch(tileImg, 150)}
	
	local defaulthm = TileHeightmap.create({5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5})

	local basic_chunk = TileChunk.autoCreate(tileImg, 0, 0, 2, 3, 0, defaulthm, 2)

	for i = 3,10 do
		self.chunks[i*2][8] = basic_chunk
	end
	for i = 1,3 do
		self.chunks[i*2][16] = basic_chunk
	end
	
	self.chunks[11][6] = basic_chunk
	self.chunks[22][7] = basic_chunk
	self.chunks[1][13] = basic_chunk
    
    local slopes_hm = {}
    slopes_hm[1] = TileHeightmap.create({16,15,14,13,13,12,12,11,11,11,11,10,10,10,10,10})
    slopes_hm[2] = TileHeightmap.create({10,10,10,10,10, 9, 9, 9, 9, 9, 9 ,9, 9, 9, 9, 9})
    slopes_hm[3] = TileHeightmap.create({ 9, 9, 9, 9,10,10,10,10,10,11,11,12,12,12,13,14})
    slopes_hm[4] = TileHeightmap.create({15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16})
    slopes_hm[5] = TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16})
    
    local slopes_chunk = TileChunk.create(5, 3)
    
    local slopes_sprites = {}
    slopes_sprites[1] = TileSprite.create(tileImg, 2*16, 0, 16, 48)
    slopes_sprites[2] = TileSprite.create(tileImg, 3*16, 0, 16, 48)
    slopes_sprites[3] = TileSprite.create(tileImg, 4*16, 0, 16, 48)
    slopes_sprites[4] = TileSprite.create(tileImg, 5*16, 0, 16, 48)
    
    local slopes_tiles = {}
    slopes_tiles[1] = Tile.createTemplate(slopes_sprites[1], 15, slopes_hm[1])
    slopes_tiles[2] = Tile.createTemplate(slopes_sprites[2], 5, slopes_hm[2])
    slopes_tiles[3] = Tile.createTemplate(slopes_sprites[3], -15, slopes_hm[3])
    slopes_tiles[4] = Tile.createTemplate(slopes_sprites[4], 2, slopes_hm[4])
    slopes_tiles[5] = Tile.createTemplate(slopes_sprites[4], 2, slopes_hm[5])
    
    slopes_chunk:setTile(0, 0, slopes_tiles[5], nil, nil, 2)
    slopes_chunk:setTile(1, 0, slopes_tiles[1], nil, nil, 2)
    slopes_chunk:setTile(2, 0, slopes_tiles[2], nil, nil, 2)
    slopes_chunk:setTile(3, 0, slopes_tiles[3], nil, nil, 2)
    slopes_chunk:setTile(4, 0, slopes_tiles[4], nil, nil, 2)
    
    for i = 8,40,5 do
        self.chunks[i][15] = slopes_chunk
	end
	
end

function Level1:createObjects()
	self.objects = {}
	local mainCharSprite = CharacterSprite.create("ninja")
	local mainChar = Character.create(mainCharSprite)
	table.insert(self.objects, mainChar)
	self.mainChar = mainChar
end

function Level1:populateLevel()
	self.mainChar.xpos = 20
	self.mainChar.ypos = 20
end
