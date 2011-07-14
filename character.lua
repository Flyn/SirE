require "mixin"
require "sensor_rect"
Character = Mixin:create()

Character.xpos = 0
Character.ypos = 0
Character.acc = 0.046875
Character.dec = 0.5
Character.grndspd = 0
Character.xspd = 0
Character.yspd = 0
Character.maxYspd = 10
Character.maxspd = 6
Character.angle = 0
Character.isMoving = false
Character.airborne = true
Character.air = 0.09375
Character.facing = 1
Character.rolling = false
Character.height = 40

function Character.create(sprite)
	local newChar = {}
	Character:mixin(newChar)
	
	newChar.sprite = sprite

	return newChar
end

function Character:jump()
    if not self.airborne then
		self.xspd = self.xspd -(6.5*-math.sin(math.rad(-self.angle)))
        self.yspd = self.yspd -(6.5*math.cos(math.rad(-self.angle)))
        self.angle = 0
        self.airborne = true
        self:roll(true)
    end
end

function Character:roll(force)
	if not self.rolling then
		if (not self.airborne and (math.abs(self.xspd) > 0.53125)) or force then
			self.rolling = true
			self.ypos = self.ypos + 5
			self.height = 30
		end
	end
end

function Character:unroll()
	self.rolling = false
	self.ypos = self.ypos - 5
	self.height = 40
end

function Character:stopJump()
    if self.airborne and self.yspd < -4 then
        self.yspd = -4
    end
end

function Character:moveRight()
    if self.airborne then
        self:moveRightAirborne()
    else
        self:moveRightOnGround()
    end
end

function Character:moveLeft()
    if self.airborne then
        self:moveLeftAirborne()
    else
        self:moveLeftOnGround()
    end
end

function Character:moveRightOnGround()
	self.isMoving = true
	self.facing = 1
	if self.grndspd < 0 then
		if self.rolling then
			self.grndspd = self.grndspd + 0.125
		else
			self.grndspd = self.grndspd + 0.5
		end
	elseif self.grndspd < self.maxspd and not self.rolling then
		self.grndspd = self.grndspd + self.acc
		if self.grndspd > self.maxspd then
			self.grndspd = self.maxspd
		end
	end
end

function Character:moveLeftOnGround()
	self.isMoving = true
	self.facing = -1
	if self.grndspd > 0 then
		if self.rolling then
			self.grndspd = self.grndspd - 0.125
		else
			self.grndspd = self.grndspd - 0.5
		end
	elseif self.grndspd > -self.maxspd and not self.rolling then
		self.grndspd = self.grndspd - self.acc
		if self.grndspd < -self.maxspd then
			self.grndspd = -self.maxspd
		end
	end
end

function Character:moveRightAirborne()
	self.facing = 1
    if self.xspd < self.maxspd then
		self.xspd = self.xspd + self.air
		if self.xspd > self.maxspd then
			self.xspd = self.maxspd
		end
	end
end

function Character:moveLeftAirborne()
	self.facing = -1
    if self.xspd > -self.maxspd then
		self.xspd = self.xspd - self.air
		if self.xspd < -self.maxspd then
			self.xspd = -self.maxspd
        end
    end
end

function Character:updateAirPos()

    self.xspd = self.xspd * math.cos(self.angle)
    self.yspd = self.yspd + 0.21875
    
    self.yspd = math.min(self.yspd, self.maxYspd)

	self.xpos = self.xpos + self.xspd
	self.ypos = self.ypos + self.yspd
	self.isMoving = false
end

function Character:updateGroundPos()
	if self.rolling and math.abs(self.xspd) < 0.5 and self.angle < 30 then
		self:unroll()
	end
	if (not self.isMoving) or self.rolling then
		local sign = 1
		if self.grndspd < 0 then
			sign = -1
		end
		
		local friction = self.acc
		if self.rolling then friction = friction / 2 end
		
		self.grndspd = self.grndspd - math.min(math.abs(self.grndspd), friction) * sign
	end
	
	if self.grndspd ~= 0 or math.abs(self.angle)>30 then
		self.grndspd = self.grndspd + 0.125*math.sin(math.rad(-self.angle))
	elseif self.rolling then
		if math.getSign(self.grndspd) ~= math.getSign(-self.angle) then
			self.grndspd = self.grndspd + 0.078125*math.sin(math.rad(-self.angle))
		else
			self.grndspd = self.grndspd + 0.3125*math.sin(math.rad(-self.angle))
		end
	end
	
	self.xspd = self.grndspd * math.cos(math.rad(-self.angle))
	self.yspd = self.grndspd * -math.sin(math.rad(-self.angle))
    
    self.yspd = math.min(self.yspd, self.maxYspd)
    
	self.xpos = self.xpos + self.xspd
	self.ypos = self.ypos + self.yspd
	self.isMoving = false
end

function Character:isBumpingTiles(tiles)
	local wallSensorBar = SensorRect.create(self,-10,10,4,4)
	for i,tile in ipairs(tiles) do
		if wallSensorBar:collidingLeft(tile) then
			self.xpos = tile.xpos+tile.width-1+11
			self.grndspd = 0
			self.xspd = 0
		elseif wallSensorBar:collidingRight(tile) then
			self.xpos = tile.xpos-11
			self.grndspd = 0
			self.xspd = 0
		end
	end
end

function Character:checkForCeiling(tiles)
	if self.airborne and self.yspd < 0 then
		local sensorray = 9
		if self.rolling then sensorray = 7 end
		local groundSensorBar1 = SensorRect.create(self,-sensorray,-sensorray,0,-(self.height/2)-15)
		local groundSensorBar2 = SensorRect.create(self,sensorray,sensorray,0,-(self.height/2)-15)
		local onGround = false
		local maxY=0
		for i,tile in ipairs(tiles) do
			if self.ypos < (tile.ypos + tile.height -1 + (self.height/2)) then
				local onGround1 = groundSensorBar1:isColliding(tile)
				local onGround2 = groundSensorBar2:isColliding(tile)
		        if(onGround1 or onGround2) then
						self.ypos = tile.ypos + tile.height -1 + (self.height/2)
		                self.yspd = 0
		        end
		        onGround = onGround or onGround1 or onGround2
			end
	    end
	end
end

function Character:checkForGround(tiles)
	local sensorray = 9
	if self.rolling then sensorray = 7 end
	local groundSensorBar1 = SensorRect.create(self,-sensorray,-sensorray,0,(self.height/2)+15)
	local groundSensorBar2 = SensorRect.create(self,sensorray,sensorray,0,(self.height/2)+15)
    local onGround = false
    local minY = nil
    
    if self.airborne then

	    if (self.yspd >= 0) then
			for i,tile in ipairs(tiles) do
				local onGround1 = false
				local onGround2 = false
				if self.ypos > tile.ypos-(self.height/2) then
					local tileypos = false
					local tileypos2 = false
					onGround1, tileypos = groundSensorBar1:collidingDown(tile)
					onGround2, tileypos2 = groundSensorBar2:collidingDown(tile)
					if onGround1 then
						if not minY then minY = tileypos end
						if (tileypos <= minY) then
							minY = tileypos
							self.angle = tile.angle
						end
		                self.ypos = minY-(self.height/2)
		                self.grndspd = self.xspd
		                self.airborne = false
						self:unroll()
					end
					if onGround2 then
						if not minY then minY = tileypos2-(self.height/2) end
						if ((tileypos2-(self.height/2)) <= minY) then
							minY = tileypos2-(self.height/2)
							self.angle = tile.angle
						end
		                self.ypos = minY
		                self.grndspd = self.xspd
		                self.airborne = false
						self:unroll()
					end
		        end
		        onGround = onGround or onGround1 or onGround2
		    end
	    end
    
    else
		for i,tile in ipairs(tiles) do
			local onGround1 = false
			local onGround2 = false
			local tileypos = false
			local tileypos2 = false
			onGround1, tileypos = groundSensorBar1:collidingDown(tile)
			onGround2, tileypos2 = groundSensorBar2:collidingDown(tile)
			if onGround1 then
				if not minY then minY = tileypos end
				if (tileypos <= minY) then
					minY = tileypos
					self.angle = tile.angle
				end
                self.ypos = minY-(self.height/2)
			end
			if onGround2 then
				if not minY then minY = tileypos2 end
				if (tileypos2 <= minY) then
					minY = tileypos2
					self.angle = tile.angle
				end
                self.ypos = minY - (self.height/2)
			end
	        onGround = onGround or onGround1 or onGround2
	    end
    end
    
    if not onGround then
        self.airborne = true
    end
    
end

function Character:physicsStep(tiles)
    if self.airborne then
        self:updateAirPos()
    else
        self:updateGroundPos()
    end
    self:isBumpingTiles(tiles)
    self:checkForCeiling(tiles)
    self:checkForGround(tiles)
end

function Character:updateSprite(dt)
	local oldAnim = self.sprite.currentAnim
	if (self.grndspd == 0) then
		self.sprite.currentAnim = self.sprite.idleAnim
	else
		self.sprite.currentAnim = self.sprite.walkAnim
		self.sprite.currentAnim:setSpeed(8+math.abs(self.grndspd))
	end
	
	if self.rolling then
		self.sprite.currentAnim = self.sprite.rollAnim
		self.sprite.currentAnim:setSpeed(5+math.abs(self.grndspd))
	end

	if oldAnim ~= self.sprite.currentAnim then
		self.sprite.currentAnim:reset()
	end
	
	self.sprite.currentAnim:update(dt)
	
	self.sprite.rotation = math.rad(-self.angle)
	if math.abs(self.angle) < 30 or self.rolling then self.sprite.rotation = 0 end
end

function Character:renderSprite()
	self.sprite:render(self)
end
