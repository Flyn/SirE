require "mixin"
Tile = Mixin:create()

function Tile.createTemplate(sprite, heightmap)
	local newTemplate = {}
	
	newTemplate.sprite = sprite
	newTemplate.heightmap = heightmap

	return newTemplate
end

function Tile.create(template, xpos, ypos)
	local newTile = {}
	Tile:mixin(newTile)
	
	newTile.xpos = xpos
	newTile.ypos = ypos
	newTile.width = template.sprite.width
	newTile.height = template.sprite.height
	newTile.sprite = template.sprite
	newTile.heightmap = template.heightmap or {}
	newTile.angle = newTile.heightmap.angle or 0

	return newTile
end

function Tile:getAbsoluteHeight(x)
	if not x or not self.heightmap.heights then
		return self.ypos
	else
		relx = math.floor(x-self.xpos) + 1
		if (relx < 1 or relx > self.sprite.width) then
			return nil
		end
		return self.ypos + self.heightmap.heights[relx]
	end
end
