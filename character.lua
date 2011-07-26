require "mixin"
require "sensor_rect"
require "mode_air"
require "mode_ground"
require "mode_rightwall"
require "mode_leftwall"
require "mode_ceiling"
Character = Mixin:create()

Character.xpos = 0
Character.ypos = 0
Character.grndspd = 0
Character.xspd = 0
Character.yspd = 0
Character.maxYspd = 10
Character.angle = 0
Character.facing = 1
Character.rolling = false
Character.height = 40
Character.lock = 0
Character.layer = 1

function Character.create(sprite)
	local newChar = {}
	Character:mixin(newChar)
	
	newChar.sprite = sprite
	newChar.modeAir = ModeAir.create(newChar)
	newChar.modeGround = ModeGround.create(newChar)
	newChar.modeRightWall = ModeRightWall.create(newChar)
	newChar.modeLeftWall = ModeLeftWall.create(newChar)
	newChar.modeCeiling = ModeCeiling.create(newChar)
	newChar.mode = newChar.modeAir

	return newChar
end

function Character:setAirborne()
	self.mode = self.modeAir
end

function Character:setOnFloor()
	self.mode = self.modeGround
end

function Character:jump()
	self.mode:jump()
end

function Character:roll()
	self.mode:roll()
end

function Character:unroll()
	self.rolling = false
	self.ypos = self.ypos - 5
	self.height = 40
end

function Character:stopJump()
	self.mode:stopJump()
end

function Character:moveRight()
	if self.lock == 0 then
		self.mode:moveRight()
	end
end

function Character:moveLeft()
	if self.lock == 0 then
		self.mode:moveLeft()
	end
end

function Character:isBumpingTiles(tiles)
	if self.mode == self.modeAir or self.mode == self.modeGround then
		local wallSensorBar = SensorRect.create(self,-10,10,4,4)
		for i,tile in ipairs(tiles) do
			if wallSensorBar:collidingLeft(tile) then
				self.xpos = tile.xpos+tile.width+10
				self.grndspd = 0
				self.xspd = 0
			elseif wallSensorBar:collidingRight(tile) then
				self.xpos = tile.xpos-10
				self.grndspd = 0
				self.xspd = 0
			end
		end
	end
end

function Character:checkForCeiling(tiles)
	local sensorray = 9
	if self.rolling then sensorray = 7 end
	local ceilingSensorBar1 = SensorRect.create(self,-sensorray,-sensorray,-(self.height/2)-15,0)
	local ceilingSensorBar2 = SensorRect.create(self,sensorray,sensorray,-(self.height/2)-15,0)
	local touchCeiling = false
	for i,tile in ipairs(tiles) do
		if self.ypos < (tile.ypos + tile.height -1 + (self.height/2)) then
			local touchCeiling1 = ceilingSensorBar1:isColliding(tile)
			local touchCeiling2 = ceilingSensorBar2:isColliding(tile)
			if(touchCeiling1 or touchCeiling2) then
					self.ypos = tile.ypos + tile.height + 1 + (self.height/2)
	                self.yspd = 0
			end
			touchCeiling = touchCeiling or touchCeiling1 or touchCeiling2
		end
	end
end

function Character:physicsStep(tiles)
	self.mode:updatePos()
    self:isBumpingTiles(tiles[self.layer])
    self:checkForCeiling(tiles[self.layer])
    self.mode:checkForGround(tiles[self.layer])
end

function Character:updateSprite(dt)
	if (self.grndspd == 0) then
		self.sprite:setState("idle")
	else
		self.sprite:setState("walk")
		self.sprite:setAnimSpeed(8+math.abs(self.grndspd))
	end
	
	if self.rolling then
		self.sprite:setState("roll")
		self.sprite:setAnimSpeed(5+math.abs(self.grndspd))
	end
	
	self.sprite:setRotation(math.rad(-self.angle))
	if math.abs(self.angle) < 20 or self.rolling then self.sprite:setRotation(0) end
	
	self.sprite:update(dt)
end

function Character:renderSprite()
	self.sprite:render(self)
end
