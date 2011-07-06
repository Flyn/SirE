require "sensor_rect"
MainChar = {}

MainChar.__index = MainChar

function MainChar.create(name)
	local newChar = {}
	setmetatable(newChar, MainChar)
	local idleImage = love.graphics.newImage(name .. ".tga")
	idleImage:setFilter("nearest","nearest")
	newChar.idleAnim = newAnimation(idleImage, 32, 40, 0.1, 0)
	local walkImage = love.graphics.newImage(name .. "_walking.tga")
	walkImage:setFilter("nearest","nearest")
	newChar.walkAnim = newAnimation(walkImage, 48, 40, 1, 0)
	newChar.currentAnim = newChar.idleAnim
	newChar.xpos = 0
	newChar.ypos = 0
	newChar.acc = 0.046875
	newChar.dec = 0.5
	newChar.grndspd = 0
    newChar.xspd = 0
    newChar.yspd = 0
	newChar.maxspd = 6
	newChar.angle = 0
	newChar.isMoving = false
    newChar.airborne = true
    newChar.air = 0.09375
    newChar.facing = 1
	return newChar
end

function MainChar:jump()
    if not self.airborne then
        self.yspd = -6.5
        self.airborne = true
    end
end

function MainChar:stopJump()
    if self.airborne and self.yspd < -4 then
        self.yspd = -4
    end
end

function MainChar:moveRight()
    if self.airborne then
        self:moveRightAirborne()
    else
        self:moveRightOnGround()
    end
end

function MainChar:moveLeft()
    if self.airborne then
        self:moveLeftAirborne()
    else
        self:moveLeftOnGround()
    end
end

function MainChar:moveRightOnGround()
	self.isMoving = true
	self.facing = 1
	if self.grndspd < 0 then
		self.grndspd = self.grndspd + 0.5
	elseif self.grndspd < self.maxspd then
		self.grndspd = self.grndspd + self.acc
		if self.grndspd > self.maxspd then
			self.grndspd = self.maxspd
		end
	end
end

function MainChar:moveLeftOnGround()
	self.isMoving = true
	self.facing = -1
	if self.grndspd > 0 then
		self.grndspd = self.grndspd - 0.5
	elseif self.grndspd > -self.maxspd then
		self.grndspd = self.grndspd - self.acc
		if self.grndspd < -self.maxspd then
			self.grndspd = -self.maxspd
		end
	end
end

function MainChar:moveRightAirborne()
    if self.grndspd < self.maxspd then
		self.grndspd = self.grndspd + self.air
		if self.grndspd > self.maxspd then
			self.grndspd = self.maxspd
		end
	end
end

function MainChar:moveLeftAirborne()
    if self.grndspd > -self.maxspd then
		self.grndspd = self.grndspd - self.air
		if self.grndspd < -self.maxspd then
			self.grndspd = -self.maxspd
        end
    end
end

function MainChar:updateAirPos()

    self.xspd = self.grndspd * math.cos(self.angle)
    self.yspd = self.yspd + 0.21875

	self.xpos = self.xpos + self.xspd
	self.ypos = self.ypos + self.yspd
	self.isMoving = false
end

function MainChar:updateGroundPos()
	if not self.isMoving then
		local sign = 1
		if self.grndspd ~= 0 then
			sign = (math.abs(self.grndspd)/self.grndspd)
		end
		self.grndspd = self.grndspd - math.min(math.abs(self.grndspd), self.acc) * sign
	end
	
	self.xspd = self.grndspd * math.cos(self.angle)
	self.yspd = self.grndspd * -math.sin(self.angle)
    
	self.xpos = self.xpos + self.xspd
	self.ypos = self.ypos + self.yspd
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

function MainChar:checkForGround(tiles)
	local groundSensorBar1 = SensorRect.create(self,-9,-9,0,20)
	local groundSensorBar2 = SensorRect.create(self,9,9,0,20)
    local onGround = false
    local maxY=0
	for i,tile in ipairs(tiles) do
		local onGround1 = groundSensorBar1:isColliding(tile)
		local onGround2 = groundSensorBar2:isColliding(tile)
        if(onGround1 or onGround2) then
            if self.ypos < tile.ypos then
                self.ypos = tile.ypos-20
                self.airborne = false
            end
        end
        onGround = onGround or onGround1 or onGround2
    end
    
    if not onGround then
        self.airborne = true
    end
    
end

function MainChar:physicsStep(tiles)
    if self.airborne then
        self:updateAirPos()
    else
        self:updateGroundPos()
    end
    self:isBumpingTiles(tiles)
    self:checkForGround(tiles)
end

function MainChar:update(dt)
	local oldAnim = self.currentAnim
	if (self.grndspd == 0) then
		self.currentAnim = self.idleAnim
	elseif (self.grndspd > 0) then
		self.currentAnim = self.walkAnim
		self.currentAnim:setSpeed(5+math.abs(self.grndspd))
	elseif (self.grndspd < 0) then
		self.currentAnim = self.walkAnim
		self.currentAnim:setSpeed(5+math.abs(self.grndspd))
	end
	
	if oldAnim ~= self.currentAnim then
		self.currentAnim:reset()
	end
	
	self.currentAnim:update(dt)
end

function MainChar:draw()
	--love.graphics.draw(self.image, self.xpos, self.ypos, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()-20)
	self.currentAnim:draw(self.xpos, self.ypos, 0, self.facing, 1, self.currentAnim:getWidth()/2, self.currentAnim:getHeight()-20)
end
