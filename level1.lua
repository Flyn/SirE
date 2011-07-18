require "mixin"
require "tile_heightmap"
require "tile_chunk"
require "tile_sprite"
require "tile"
Level1 = Mixin:create()

Level1.title = "Test Level"

function Level1.create()
	local newLevel1 = {}
	Level1:mixin(newLevel1)
	
	newLevel1.chunks = {}
	for i=1,50 do
		newLevel1.chunks[i]={}
	end
	
	newLevel1:createTiles()
	newLevel1:generateTiles()
	newLevel1:createObjects()
	newLevel1:populateLevel()

	return newLevel1
end

function Level1:createTiles()

	local tileImg = love.graphics.newImage("level1_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	self.tilesetBatch = love.graphics.newSpriteBatch(tileImg, 150)
	
	local defaulthm = TileHeightmap.create({5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}, 0)
	
	local basic_chunk = TileChunk.autoCreate(tileImg, 0, 0, 2, 3, defaulthm)

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
    slopes_hm[1] = TileHeightmap.create({16,15,14,13,13,12,12,11,11,11,11,10,10,10,10,10}, 15)
    slopes_hm[2] = TileHeightmap.create({10,10,10,10,10, 9, 9, 9, 9, 9, 9 ,9, 9, 9, 9, 9}, 5)
    slopes_hm[3] = TileHeightmap.create({ 9, 9, 9, 9,10,10,10,10,10,11,11,12,12,12,13,14}, -15)
    slopes_hm[4] = TileHeightmap.create({15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16}, 2)
    slopes_hm[5] = TileHeightmap.create({16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16}, 2)
    
    local slopes_chunk = TileChunk.create(5, 3)
    
    local slopes_sprites = {}
    slopes_sprites[1] = TileSprite.create(tileImg, 2*16, 0, 16, 48)
    slopes_sprites[2] = TileSprite.create(tileImg, 3*16, 0, 16, 48)
    slopes_sprites[3] = TileSprite.create(tileImg, 4*16, 0, 16, 48)
    slopes_sprites[4] = TileSprite.create(tileImg, 5*16, 0, 16, 48)
    
    local slopes_tiles = {}
    slopes_tiles[1] = Tile.createTemplate(slopes_sprites[1], slopes_hm[1])
    slopes_tiles[2] = Tile.createTemplate(slopes_sprites[2], slopes_hm[2])
    slopes_tiles[3] = Tile.createTemplate(slopes_sprites[3], slopes_hm[3])
    slopes_tiles[4] = Tile.createTemplate(slopes_sprites[4], slopes_hm[4])
    slopes_tiles[5] = Tile.createTemplate(slopes_sprites[4], slopes_hm[5])
    
    slopes_chunk:setTile(0, 0, slopes_tiles[5])
    slopes_chunk:setTile(1, 0, slopes_tiles[1])
    slopes_chunk:setTile(2, 0, slopes_tiles[2])
    slopes_chunk:setTile(3, 0, slopes_tiles[3])
    slopes_chunk:setTile(4, 0, slopes_tiles[4])
    
    for i = 8,40,5 do
        self.chunks[i][15] = slopes_chunk
	end
	
end

function Level1:generateTiles()

	self.tiles = {}

	for worldx,xchunks in pairs(self.chunks) do
		for worldy,chunk in pairs(xchunks) do
			for x, tilesx in pairs(chunk.tiles) do
				for y, tile in pairs(tilesx) do
					local absx = (x - 1) + (worldx - 1)
					local absy = (y - 1) + (worldy - 1)
					table.insert(self.tiles, Tile.create(tile, absx*16, absy*16))
				end
			end
		end
    end
    
    self.chunks = nil
end

function Level1:createObjects()
	self.objects = {}
	local mainCharSprite = CharacterSprite.create("ninja")
	local mainChar = Character.create(mainCharSprite)
	mainChar.xpos = 20
	mainChar.ypos = 20
	table.insert(self.objects, mainChar)
	self.mainChar = mainChar
end

function Level1:populateLevel()
	self.mainChar.xpos = 20
	self.mainChar.ypos = 20
end

function Level1:preRendering()
	self.tilesetBatch:clear()

	for i,tile in pairs(self.tiles) do
		self.tilesetBatch:addq(tile.sprite.quad, tile.xpos, tile.ypos)
    end
end

function Level1:render()
    for i,object in ipairs(self.objects) do
		object:renderSprite()
    end
    
    love.graphics.draw(self.tilesetBatch)
end
