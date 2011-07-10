require "mixin"
Tile = Mixin:create()

Tile.xpos = 0
Tile.ypos = 0
Tile.width = 0
Tile.height = 0
Tile.image = nil
Tile.quad = nil

function Tile.create(image, x, y, w, h, heightmap)
	local newTile = {}
	Tile:mixin(newTile)
	
	newTile.width = w
	newTile.height = h
	newTile.image = image
	newTile.quad = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())
	newTile.heightmap = heightmap

	return newTile
end

function Tile:getAbsoluteHeight(x)
	if not x or not self.heightmap then
		return self.ypos
	else
		local relx = math.floor(x-self.xpos)
		if (relx < 1) then relx = 1 end
		return self.ypos + self.heightmap[relx]
	end
end

function Tile:draw()
	love.graphics.drawq(tileImg, self.quad, self.xpos, self.ypos)
end
