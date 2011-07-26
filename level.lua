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

	self.tiles = {{},{}}
	self.tileCollisions = {{},{}}

	for worldx,xchunks in pairs(self.chunks) do
		for worldy,chunk in pairs(xchunks) do
			for x, tilesx in pairs(chunk.tiles) do
				for y, tile in pairs(tilesx) do
					local absx = (x - 1) + (worldx - 1)
					local absy = (y - 1) + (worldy - 1)
					local newTile = Tile.create(tile, absx*16, absy*16, chunk.flipx[x][y], chunk.flipy[x][y], chunk.priority[x][y], chunk.layers[1][x][y], chunk.layers[2][x][y])
					table.insert(self.tiles[newTile.priority], newTile)
					for layer, appear in ipairs(newTile.layers) do
						if appear then
							table.insert(self.tileCollisions[layer], newTile)
						end
					end
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
		for priority, batch in pairs(self.tilesetBatch) do
	        batch:clear()
	    
	        for i,tile in pairs(self.tiles[priority]) do
	        
				local scalex = 1
				local scaley = 1
				if tile.flipx then scalex = -1 end
				if tile.flipy then scaley = -1 end
	        
				if (tile.xpos >= gameCamera.xpos-20 and tile.xpos < gameCamera.xpos+gameCamera:getZoomedWidth()+20)
				and (tile.ypos >= gameCamera.ypos-20 and tile.ypos < gameCamera.ypos+gameCamera:getZoomedHeight()+20) then
					batch:addq(tile.sprite.quad, tile.xpos+tile.width/2, tile.ypos+tile.height/2, nil, scalex, scaley, tile.width/2, tile.height/2)
	            end
	        end
        end
    end
end

function Level:render()

    if self.tilesetBatch then
		if self.tilesetBatch[1] then
			love.graphics.setColor(200,200,200)
			gameCamera:draw(self.tilesetBatch[1])
			love.graphics.setColor(255,255,255)
        end
    end

    for i,object in ipairs(self.objects) do
		object:renderSprite()
    end
    
    if self.tilesetBatch then
		if self.tilesetBatch[2] then
			gameCamera:draw(self.tilesetBatch[2])
        end
    end
end
