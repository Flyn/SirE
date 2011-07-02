MainChar = {}

MainChar.__index = MainChar

function MainChar.create(name)
	local newChar = {}
	setmetatable(newChar, MainChar)
	newChar.image = love.graphics.newImage(name .. ".tga")
	newChar.image:setFilter("nearest","nearest")
	newChar.xpos = 0
	newChar.ypos = 0
	return newChar
end

function MainChar:moveRight()
	self.xpos = self.xpos + 1
end

function MainChar:moveLeft()
	self.xpos = self.xpos - 1
end

function MainChar:isBumpingTiles(tiles)
	local sensorY = self.ypos+4
	local sensorX1 = self.xpos-10
	local sensorX2 = self.xpos+10
	for i,tile in ipairs(tiles) do
		local tilexpos2 = tile.xpos+16
		local tileypos2 = tile.ypos+16
		if sensorY > tile.ypos and sensorY < tileypos2 then
			if sensorX1 > tile.xpos and sensorX1 < tilexpos2 then
				self.xpos = tilexpos2+11
			elseif sensorX2 > tile.xpos and sensorX2 < tilexpos2 then
				self.xpos = tile.xpos-11
			end
		end
	end
end

function MainChar:draw()
	love.graphics.draw(self.image, self.xpos, self.ypos, 0, 1, 1, 20, 20)
end
