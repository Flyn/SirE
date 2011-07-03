require "sensorrect"
MainChar = {}

MainChar.__index = MainChar

function MainChar.create(name)
	local newChar = {}
	setmetatable(newChar, MainChar)
	newChar.image = love.graphics.newImage(name .. ".tga")
	newChar.image:setFilter("nearest","nearest")
	newChar.xpos = 0
	newChar.ypos = 0
	newChar.acc = 0.046875
	newChar.dec = 0.5
	newChar.xspd = 0
	newChar.maxSpd = 6
	newChar.isMoving = false
	return newChar
end

function MainChar:moveRight()
	self.isMoving = true
	if self.xspd < 0 then
		self.xspd = self.xspd + 0.5
	elseif self.xspd < self.maxSpd then
		self.xspd = self.xspd + self.acc
		if self.xspd > self.maxSpd then
			self.xspd = self.maxSpd
		end
	end
end

function MainChar:moveLeft()
	self.isMoving = true
	if self.xspd > 0 then
		self.xspd = self.xspd - 0.5
	elseif self.xspd > -self.maxSpd then
		self.xspd = self.xspd - self.acc
		if self.xspd < -self.maxSpd then
			self.xspd = -self.maxSpd
		end
	end
end

function MainChar:updatePos()
	if not self.isMoving then
		local sign = 1
		if self.xspd ~= 0 then
			sign = (math.abs(self.xspd)/self.xspd)
		end
		self.xspd = self.xspd - math.min(math.abs(self.xspd), self.acc) * sign
	end
	self.xpos = self.xpos + self.xspd
	self.isMoving = false
end

function MainChar:isBumpingTiles(tiles)
	wallSensorBar = SensorRect.create(self,-10,10,4,4)
	for i,tile in ipairs(tiles) do
		if wallSensorBar:collidingLeft(tile) then
			self.xpos = tile.xpos+tile.width+11
			self.xspd = 0
		elseif wallSensorBar:collidingRight(tile) then
				self.xpos = tile.xpos-11
				self.xspd = 0
		end
	end
end

function MainChar:draw()
	love.graphics.draw(self.image, self.xpos, self.ypos, 0, 1, 1, 20, 20)
end
