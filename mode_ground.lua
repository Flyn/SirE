require "mixin"
ModeGround = Mixin:create()

ModeGround.acc = 0.046875
ModeGround.dec = 0.5
ModeGround.maxspd = 6
ModeGround.isAccelerating = false
ModeGround.name = "Ground" -- Just used for debug

function ModeGround.create(char)
	local newMode = {}
	ModeGround:mixin(newMode)
	
	newMode.character = char

	return newMode
end

function ModeGround:jump()
	self.character.xspd = self.character.xspd -(6.5*math.sin(math.rad(self.character.angle)))
	self.character.yspd = self.character.yspd -(6.5*math.cos(math.rad(self.character.angle)))
	self.character.angle = 0
	self.character:setAirborne()
	self.character:roll()
end

function ModeGround:roll()
	if not self.character.rolling then
		if (math.abs(self.character.xspd) > 0.53125) then
			self.character.rolling = true
			self.character.ypos = self.character.ypos + 5
			self.character.height = 30
		end
	end
end

function ModeGround:stopJump()

end

function ModeGround:moveRight()
	self.isAccelerating = true
	self.character.facing = 1
	if self.character.grndspd < 0 then
		if self.character.rolling then
			self.character.grndspd = self.character.grndspd + 0.125
		else
			self.character.grndspd = self.character.grndspd + 0.5
		end
	elseif self.character.grndspd < self.maxspd and not self.character.rolling then
		self.character.grndspd = self.character.grndspd + self.acc
		if self.character.grndspd > self.maxspd then
			self.character.grndspd = self.maxspd
		end
	end
end

function ModeGround:moveLeft()
	self.isAccelerating = true
	self.character.facing = -1
	if self.character.grndspd > 0 then
		if self.character.rolling then
			self.character.grndspd = self.character.grndspd - 0.125
		else
			self.character.grndspd = self.character.grndspd - 0.5
		end
	elseif self.character.grndspd > -self.maxspd and not self.character.rolling then
		self.character.grndspd = self.character.grndspd - self.acc
		if self.character.grndspd < -self.maxspd then
			self.character.grndspd = -self.maxspd
		end
	end
end

function ModeGround:updatePos()
    if self.character.lock > 0 then
		self.character.lock = self.character.lock - 1
    end
	if self.character.rolling and math.abs(self.character.xspd) < 0.5 then
		self.character:unroll()
	end
	if (not self.isAccelerating) or self.character.rolling then
		local sign = 1
		if self.character.grndspd < 0 then
			sign = -1
		end
		
		local friction = self.acc
		if self.character.rolling then friction = friction / 2 end
		
		self.character.grndspd = self.character.grndspd - math.min(math.abs(self.character.grndspd), friction) * sign
	end
	
	if self.character.grndspd ~= 0 then
		self.character.grndspd = self.character.grndspd + 0.125*math.sin(math.rad(-self.character.angle))
	elseif self.character.rolling then
		if math.getSign(self.character.grndspd) ~= math.getSign(self.character.angle) then
			self.character.grndspd = self.character.grndspd + 0.078125*math.sin(math.rad(-self.character.angle))
		else
			self.character.grndspd = self.character.grndspd + 0.3125*math.sin(math.rad(-self.character.angle))
		end
	end
	
	self.character.xspd = self.character.grndspd * math.cos(math.rad(self.character.angle))
	self.character.yspd = self.character.grndspd * -math.sin(math.rad(self.character.angle))
    
    self.character.yspd = math.min(self.character.yspd, self.character.maxYspd)
    
	self.character.xpos = self.character.xpos + self.character.xspd
	self.character.ypos = self.character.ypos + self.character.yspd
	self.isAccelerating = false
	
	if self.character.angle > 45 then
		self.character.mode = self.character.modeRightWall
	elseif self.character.angle < -45 then
		self.character.mode = self.character.modeLeftWall
	end
end

function ModeGround:checkForGround(tiles)

	local sensorray = 9
	if self.character.rolling then sensorray = 7 end
	local groundSensorBar1 = SensorRect.create(self.character,-sensorray,-sensorray,0,(self.character.height/2)+15)
	local groundSensorBar2 = SensorRect.create(self.character,sensorray,sensorray,0,(self.character.height/2)+15)
    local onGround = false
    local minY = nil

	for i,tile in ipairs(tiles) do
		local onGround1 = false
		local onGround2 = false
		local tileypos = false
		local tileypos2 = false
		onGround1, tileypos = groundSensorBar1:isColliding(tile)
		onGround2, tileypos2 = groundSensorBar2:isColliding(tile)
		if onGround1 then
			if not minY then minY = tileypos end
			if (tileypos <= minY) then
				minY = tileypos
				self.character.angle = tile.angle
			end
			self.character.ypos = minY-(self.character.height/2)
		end
		if onGround2 then
			if not minY then minY = tileypos2 end
			if (tileypos2 <= minY) then
				minY = tileypos2
				self.character.angle = tile.angle
			end
			self.character.ypos = minY - (self.character.height/2)
		end
        onGround = onGround or onGround1 or onGround2
    end
    if not onGround then
        self.character:setAirborne()
        self.character.angle = 0
    end
end
