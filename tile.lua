require "mixin"
Tile = Mixin:create()

function Tile.createTemplate(sprite, heightmap, widthmap)
	local newTemplate = {}
	
	newTemplate.sprite = sprite
	newTemplate.heightmap = heightmap
	newTemplate.widthmap = widthmap

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
	newTile.widthmap = template.widthmap or {}
	newTile.angle = newTile.heightmap.angle or 0
	newTile.angleWall = newTile.widthmap.angle or 90

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
		rely = self.heightmap.heights[relx]
		if rely >= self.sprite.height then
			return nil
		end
		return self.ypos + rely
	end
end

function Tile:getAbsoluteWidth(y)
	if not y or not self.widthmap.heights then
		return self.xpos
	else
		rely = math.floor(y-self.ypos) + 1
		if (rely < 1 or rely > self.sprite.height) then
			return nil
		end
		relx = self.widthmap.heights[rely]
		if relx >= self.sprite.width then
			return nil
		end
		return self.xpos + relx
	end
end
