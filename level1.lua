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
	
	defaulthm = TileHeightmap.create({5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}, 0)
	
	local basic_chunk = TileChunk.autoCreate(tileImg, 0, 0, 2, 3, defaulthm)

	for i = 2,10 do
		self.chunks[i*2][8] = basic_chunk
	end
	for i = 1,3 do
		self.chunks[i*2][16] = basic_chunk
	end
	
	self.chunks[11][6] = basic_chunk
	self.chunks[22][7] = basic_chunk
	self.chunks[1][13] = basic_chunk
	
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
    love.graphics.draw(self.tilesetBatch)

    for i,object in ipairs(self.objects) do
		object:renderSprite()
    end
end
