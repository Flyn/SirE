require "mixin"
Tile = Mixin:create()

function Tile.create(sprite, heightmap, angle)
	local newTile = {}
	Tile:mixin(newTile)
	
	newTile.sprite = sprite
	newTile.heightmap = heightmap
	newTile.angle = angle or 0

	return newTile
end

function Tile:getAbsoluteHeight(x)
	if not x or not self.heightmap then
		return self.ypos
	else
		relx = math.floor(x-self.xpos) + 1
		if (relx < 1 or relx > self.width) then
			return nil
		end
		return self.ypos + self.heightmap[relx]
	end
end
