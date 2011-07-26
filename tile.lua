require "mixin"
Tile = Mixin:create()

function Tile.createTemplate(sprite, heightmap, widthmap)
	local newTemplate = {}
	
	newTemplate.sprite = sprite
	newTemplate.heightmap = heightmap
	newTemplate.widthmap = widthmap

	return newTemplate
end

function Tile.create(template, xpos, ypos, flipx, flipy)
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
	if flipx then
		newTile.angle = - newTile.angle
		newTile.angleWall = - newTile.angleWall
	end
	if flipy then
        if (newTile.angle >= 0) then
            newTile.angle = 180 - newTile.angle
            newTile.angleWall = 180 - newTile.angleWall
        else
            newTile.angle = - 180 - newTile.angle
            newTile.angleWall = - 180 - newTile.angleWall
        end
	end
	newTile.flipx = flipx or false
	newTile.flipy = flipy or false

	return newTile
end

function Tile:getAbsoluteHeight(x)
	if not x or not self.heightmap.heights then
		if self.flipy then
			return self.ypos + self.sprite.height
		else
			return self.ypos
		end
	else
		relx = math.floor(x-self.xpos) + 1
		if (relx < 1 or relx > self.sprite.width) then
			return nil
		end
		
		if self.flipx then
			relx = self.sprite.width+1 - relx
		end
		
		rely = self.heightmap.heights[relx]
		if rely >= self.sprite.height then
			return nil
		end
		if self.flipy then
			rely = self.sprite.height - rely
		end

		return self.ypos + rely
	end
end

function Tile:getAbsoluteWidth(y)
	if not y or not self.widthmap.heights then
		if self.flipx then
			return self.xpos + self.sprite.width
		else
			return self.xpos
		end
	else
		rely = math.floor(y-self.ypos) + 1
		if (rely < 1 or rely > self.sprite.height) then
			return nil
		end
		if self.flipy then
			rely = self.sprite.height+1 - rely
		end
		relx = self.widthmap.heights[rely]
		if relx >= self.sprite.width then
			return nil
		end
		if self.flipx then
			relx = self.sprite.width - relx
		end
		return self.xpos + relx
	end
end
