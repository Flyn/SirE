require "mixin"
ModeLeftWall = Mixin:create()

ModeLeftWall.acc = 0.046875
ModeLeftWall.dec = 0.5
ModeLeftWall.maxspd = 6
ModeLeftWall.isAccelerating = false
ModeLeftWall.name = "LeftWall" -- Just used for debug

function ModeLeftWall.create(char)
	local newMode = {}
	ModeLeftWall:mixin(newMode)
	
	newMode.character = char

	return newMode
end

function ModeLeftWall:jump()
	self.character.xspd = self.character.xspd -(6.5*-math.sin(math.rad(-self.character.angle)))
	self.character.yspd = self.character.yspd -(6.5*math.cos(math.rad(-self.character.angle)))
	self.character.angle = 0
	self.character:setAirborne()
	self.character:roll()
end

function ModeLeftWall:roll()
	if not self.character.rolling then
		if (math.abs(self.character.yspd) > 0.53125) then
			self.character.rolling = true
			self.character.ypos = self.character.ypos + 5
			self.character.height = 30
		end
	end
end

function ModeLeftWall:stopJump()

end

function ModeLeftWall:moveRight()
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

function ModeLeftWall:moveLeft()
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

function ModeLeftWall:updatePos()
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
		if math.getSign(self.character.grndspd) ~= math.getSign(-self.character.angle) then
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

	if self.character.angle <= -135 then
		self.character.mode = self.character.modeCeiling
	elseif self.character.angle >= -45 then
		self.character:setOnFloor()
	elseif math.abs(self.character.grndspd) < 2.5 then
		self.character.grndspd = 0
		self.character:setAirborne()
		self.character.lock = 30
	end

end

function ModeLeftWall:checkForGround(tiles)

    local sensorray = 9
	if self.character.rolling then sensorray = 7 end
	local groundSensorBar1 = SensorRect.create(self.character,-(self.character.height/2)-15,0,-sensorray,-sensorray)
	local groundSensorBar2 = SensorRect.create(self.character,-(self.character.height/2)-15,0,sensorray,sensorray)
    local onGround = false
    local minY = nil

	for i,tile in ipairs(tiles) do
		local onGround1 = false
		local onGround2 = false
		local tilexpos = false
		local tilexpos2 = false
		onGround1, tilexpos = groundSensorBar1:isCollidingWall(tile)
		onGround2, tilexpos2 = groundSensorBar2:isCollidingWall(tile)
		if onGround1 then
			if not minY then minY = tilexpos end
			if (tilexpos >= minY) then
				minY = tilexpos
				self.character.angle = tile.angle
			end
			self.character.xpos = minY + (self.character.height/2)
		end
		if onGround2 then
			if not minY then minY = tilexpos2 end
			if (tilexpos2 >= minY) then
				minY = tilexpos2
				self.character.angle = tile.angle
			end
			self.character.xpos = minY + (self.character.height/2)
		end
        onGround = onGround or onGround1 or onGround2
    end
    if not onGround then
        self.character:setAirborne()
    end
end
