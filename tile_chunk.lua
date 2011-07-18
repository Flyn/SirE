require "mixin"
TileChunk = Mixin:create()

TileChunk.width = 0
TileChunk.height = 0

function TileChunk.create(w, h)
	local newTileChunk = {}
	TileChunk:mixin(newTileChunk)
	
	newTileChunk.width  = w
	newTileChunk.height = h
    newTileChunk.tiles = {}
	
	for x = 1, w do
		newTileChunk.tiles[x] = {}
	end

	return newTileChunk
end

function TileChunk.autoCreate(tileImage, xmin, ymin, width, height, heightmap)
	local newTileChunk = TileChunk.create(width, height)
	
	for x=0, width-1 do
		for y=0, height-1 do
		local tilespr = TileSprite.create(tileImage, (xmin+x)*16, (ymin+y)*16, 16, 16)
		local temptile = Tile.createTemplate(tilespr)
		if y==0 then
			temptile = Tile.createTemplate(tilespr, heightmap)
		end
		newTileChunk:setTile(x, y, temptile)
		end
	end

	return newTileChunk
end

function TileChunk:setTile(x, y, tile)
	if (x < self.width) and (y < self.height) then
		x = x+1
		y = y+1
		self.tiles[x][y] = tile
	end
end
