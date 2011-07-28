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
    newTileChunk.flipx = {}
    newTileChunk.flipy = {}
    newTileChunk.priority = {}
    newTileChunk.layers = {{},{}}
	
	for x = 1, w do
		newTileChunk.tiles[x] = {}
		newTileChunk.flipx[x] = {}
		newTileChunk.flipy[x] = {}
		newTileChunk.priority[x] = {}
		newTileChunk.layers[1][x] = {}
		newTileChunk.layers[2][x] = {}
	end

	return newTileChunk
end

function TileChunk.autoCreate(tileImage, xmin, ymin, width, height, angle, heightmap, priority, layer1, layer2)
	local newTileChunk = TileChunk.create(width, height)
	
	for x=0, width-1 do
		for y=0, height-1 do
		local tilespr = TileSprite.create(tileImage, (xmin+x)*16, (ymin+y)*16, 16, 16)
		local temptile = Tile.createTemplate(tilespr)
		if y==0 then
			temptile = Tile.createTemplate(tilespr, angle, heightmap)
		end
		newTileChunk:setTile(x, y, temptile, nil, nil, priority, layer1, layer2)
		end
	end

	return newTileChunk
end

function TileChunk:setTile(x, y, tile, flipx, flipy, priority, layer1, layer2)
	if (x < self.width) and (y < self.height) then
		x = x+1
		y = y+1
		self.tiles[x][y] = tile
		self.flipx[x][y] = flipx or false
		self.flipy[x][y] = flipy or false
		self.priority[x][y] = priority or 1
		if layer1 == nil then layer1 = true end
		if layer2 == nil then layer2 = false end
		self.layers[1][x][y] = layer1
		self.layers[2][x][y] = layer2
	end
end
