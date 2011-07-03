require "sensor_rect"
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
	newChar.grndspd = 0
	newChar.maxspd = 6
	newChar.angle = 0
	newChar.isMoving = false
	return newChar
end

function MainChar:moveRight()
	self.isMoving = true
	if self.angle ~= math.rad(0) then
		self.grndspd = -self.grndspd
		self.angle = math.rad(0)
	end
	self:run()
end

function MainChar:moveLeft()
	self.isMoving = true
	if self.angle ~= math.rad(180) then
		self.grndspd = -self.grndspd
		self.angle = math.rad(180)
	end
	self:run()
end

function MainChar:run()
	if self.grndspd < 0 then
		self.grndspd = self.grndspd + 0.5
	elseif self.grndspd < self.maxspd then
		self.grndspd = self.grndspd + self.acc
		if self.grndspd > self.maxspd then
			self.grndspd = self.maxspd
		end
	end
end

function MainChar:updatePos()
	if not self.isMoving then
		local sign = 1
		if self.grndspd ~= 0 then
			sign = (math.abs(self.grndspd)/self.grndspd)
		end
		self.grndspd = self.grndspd - math.min(math.abs(self.grndspd), self.acc) * sign
	end
	
	local xspd = self.grndspd * math.cos(self.angle)
	local yspd = self.grndspd * -math.sin(self.angle)
	
	self.xpos = self.xpos + xspd
	self.ypos = self.ypos + yspd
	self.isMoving = false
end

function MainChar:isBumpingTiles(tiles)
	local wallSensorBar = SensorRect.create(self,-10,10,4,4)
	for i,tile in ipairs(tiles) do
		if wallSensorBar:collidingLeft(tile) then
			self.xpos = tile.xpos+tile.width+11
			self.grndspd = 0
		elseif wallSensorBar:collidingRight(tile) then
				self.xpos = tile.xpos-11
				self.grndspd = 0
		end
	end
end

function MainChar:isOnGround(tiles)
	local groundSensorBar1 = SensorRect.create(self,-9,-9,0,20)
	local groundSensorBar2 = SensorRect.create(self,9,9,0,20)
	local onGround1 = false
	local onGround2 = false
	for i,tile in ipairs(tiles) do
		onGround1 = groundSensorBar1:isColliding(tile) or onGround1
		onGround2 = groundSensorBar2:isColliding(tile) or onGround2
	end
	
	return onGround1 or onGround2
end

function MainChar:draw()
	love.graphics.draw(self.image, self.xpos, self.ypos, 0, 1, 1, 20, 20)
end
