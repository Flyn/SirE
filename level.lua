require "mixin"
require "tile_heightmap"
require "tile_chunk"
require "tile_sprite"
require "tile"
Level = Mixin:create()

Level.title = "Default Level"

function Level:init()
	self.chunks = {}
	for i=1,50 do
		self.chunks[i]={}
	end
	
	self:createTiles()
	self:generateTiles()
	self:createObjects()
	self:populateLevel()
end

function Level:createTiles()
        
end

function Level:generateTiles()

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

function Level:createObjects()
	self.objects = {}
	local mainCharSprite = CharacterSprite.create("ninja")
	local mainChar = Character.create(mainCharSprite)
	table.insert(self.objects, mainChar)
	self.mainChar = mainChar
end

function Level:populateLevel()
	self.mainChar.xpos = 50
	self.mainChar.ypos = 50
end

function Level:preRendering()
    if self.tilesetBatch then
        self.tilesetBatch:clear()
    
        for i,tile in pairs(self.tiles) do
            self.tilesetBatch:addq(tile.sprite.quad, tile.xpos, tile.ypos)
        end
        
    end
end

function Level:render()
    for i,object in ipairs(self.objects) do
		object:renderSprite()
    end
    
    if self.tilesetBatch then
        love.graphics.draw(self.tilesetBatch)
    end
end
