require "mixin"
ModeAir = Mixin:create()

ModeAir.air = 0.09375
ModeAir.maxspd = 6

function ModeAir.create(char)
	local newMode = {}
	ModeAir:mixin(newMode)
	
	newMode.character = char

	return newMode
end

function ModeAir:jump()

end

function ModeAir:roll()
	if not self.character.rolling then
		self.character.rolling = true
		self.character.ypos = self.character.ypos + 5
		self.character.height = 30
	end
end

function ModeAir:stopJump()
    if self.character.yspd < -4 then
        self.character.yspd = -4
    end
end

function ModeAir:moveRight()
	self.character.facing = 1
    if self.character.xspd < self.maxspd then
		self.character.xspd = self.character.xspd + self.air
		if self.character.xspd > self.maxspd then
			self.character.xspd = self.maxspd
		end
	end
end

function ModeAir:moveLeft()
    self.character.facing = -1
    if self.character.xspd > -self.maxspd then
		self.character.xspd = self.character.xspd - self.air
		if self.character.xspd < -self.maxspd then
			self.character.xspd = -self.maxspd
        end
    end
end

function ModeAir:updatePos()
	if self.character.angle ~= 0 then
		self.character.angle = self.character.angle - 3*math.getSign(self.character.angle)
	end
    self.character.yspd = self.character.yspd + 0.21875
    
    self.character.yspd = math.min(self.character.yspd, self.character.maxYspd)

	self.character.xpos = self.character.xpos + self.character.xspd
	self.character.ypos = self.character.ypos + self.character.yspd
end

function ModeAir:checkForGround(tiles)
	local sensorray = 9
	if self.character.rolling then sensorray = 7 end
	local groundSensorBar1 = SensorRect.create(self.character,-sensorray,-sensorray,0,(self.character.height/2)+15)
	local groundSensorBar2 = SensorRect.create(self.character,sensorray,sensorray,0,(self.character.height/2)+15)
    local onGround = false
    local minY = nil

    if (self.character.yspd >= 0) then
		for i,tile in ipairs(tiles) do
			local onGround1 = false
			local onGround2 = false
			if self.character.ypos > tile.ypos-(self.character.height/2) then
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
				end
				if onGround2 then
					if not minY then minY = tileypos2 end
					if ((tileypos2) <= minY) then
						minY = tileypos2
						self.character.angle = tile.angle
					end
				end
				if onGround1 or onGround2 then
					self.character.ypos = minY-(self.character.height/2)
					if self.character.angle > -20 and self.character.angle < 20 then
						self.character.grndspd = self.character.xspd
					elseif (self.character.angle >= 20 and self.character.angle < 45) or (self.character.angle <= -20 and self.character.angle > -45) then
						if math.abs(self.character.xspd) > self.character.yspd then
							self.character.grndspd = self.character.xspd
						else
							self.character.grndspd = self.character.yspd*0.5*-math.getSign(math.cos(math.rad(-self.character.angle)))
						end
					elseif (self.character.angle >= 45 and self.character.angle < 90) or (self.character.angle <= -45 and self.character.angle > -90) then
						if math.abs(self.character.xspd) > self.character.yspd then
							self.character.grndspd = self.character.xspd
						else
							self.character.grndspd = self.character.yspd*-math.getSign(math.cos(math.rad(-self.character.angle)))
						end
					end
	                self.character:setOnFloor()
					self.character:unroll()
				end
	        end
	        onGround = onGround or onGround1 or onGround2
	    end
    end
end
