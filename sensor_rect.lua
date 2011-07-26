SensorRect = {}

SensorRect.__index = SensorRect

function SensorRect.create(parent, x1, x2, y1, y2)
	local sensor = {}
	setmetatable(sensor, SensorRect)
	sensor.parent = parent
	sensor.relx1= x1 or -parent.width/2
	sensor.relx2= x2 or parent.width/2
	sensor.rely1= y1 or -parent.height/2
	sensor.rely2= y2 or parent.height/2
	return sensor
end

function SensorRect:calculatePos()
	self.xpos = math.floor(self.parent.xpos + self.relx1)
	self.xpos2 = math.floor(self.parent.xpos + self.relx2)
	self.ypos = math.floor(self.parent.ypos + self.rely1)
	self.ypos2 = math.floor(self.parent.ypos + self.rely2)
end

function SensorRect:isCollidingObject(obj)
	self:calculatePos()
	objxpos = obj.xpos
	objypos = obj.ypos
	objxpos2 = (obj.xpos + obj.width - 1)
	objypos2 = (obj.ypos + obj.height - 1)
	if (self.xpos >= objxpos and self.xpos <= objxpos2) or (self.xpos2 >= objxpos and self.xpos2 <= objxpos2) or (objxpos >= self.xpos and objxpos <= self.xpos2) or (objxpos2 >= self.xpos and objxpos2 <= self.xpos2) then
		if (self.ypos >= objypos and self.ypos <= objypos2) or (self.ypos2 >= objypos and self.ypos2 <= objypos2) or (objypos >= self.ypos and objypos <= self.ypos2) or (objypos2 >= self.ypos and objypos2 <= self.ypos2) then
			return true
		end
	end
	return false
end

function SensorRect:isColliding(tile)
	self:calculatePos()
	tilexpos = tile.xpos
	tileypos = tile:getAbsoluteHeight(self.xpos)
	if not tileypos then return false end
	tilexpos2 = (tile.xpos + tile.width - 1)
	tileypos2 = (tile.ypos + tile.height - 1)
	if (self.xpos >= tilexpos and self.xpos <= tilexpos2) or (self.xpos2 >= tilexpos and self.xpos2 <= tilexpos2) or (tilexpos >= self.xpos and tilexpos <= self.xpos2) or (tilexpos2 >= self.xpos and tilexpos2 <= self.xpos2) then
		if (self.ypos >= tileypos and self.ypos <= tileypos2) or (self.ypos2 >= tileypos and self.ypos2 <= tileypos2) or (tileypos >= self.ypos and tileypos <= self.ypos2) or (tileypos2 >= self.ypos and tileypos2 <= self.ypos2) then
			return true, tileypos
		end
	end
	return false
end

function SensorRect:isCollidingWall(tile)
	self:calculatePos()
	tilexpos = tile:getAbsoluteWidth(self.ypos)
	tileypos = tile.ypos
	if not tilexpos then return false end
	tilexpos2 = (tile.xpos + tile.width - 1)
	tileypos2 = (tile.ypos + tile.height - 1)
	if (self.xpos >= tilexpos and self.xpos <= tilexpos2) or (self.xpos2 >= tilexpos and self.xpos2 <= tilexpos2) or (tilexpos >= self.xpos and tilexpos <= self.xpos2) or (tilexpos2 >= self.xpos and tilexpos2 <= self.xpos2) then
		if (self.ypos >= tileypos and self.ypos <= tileypos2) or (self.ypos2 >= tileypos and self.ypos2 <= tileypos2) or (tileypos >= self.ypos and tileypos <= self.ypos2) or (tileypos2 >= self.ypos and tileypos2 <= self.ypos2) then
			return true, tilexpos
		end
	end
	return false
end

function SensorRect:collidingLeft(tile)
	self:calculatePos()
	tileypos = tile:getAbsoluteHeight(self.xpos)
	if not tileypos then return false end
	tilexpos2 = (tile.xpos + tile.width - 1)
	tileypos2 = (tile.ypos + tile.height - 1)
	if (self.ypos >= tileypos and self.ypos <= tileypos2) or (self.ypos2 >= tileypos and self.ypos2 <= tileypos2) then
		if self.xpos >= tile.xpos and self.xpos <= tilexpos2 then
			return true
		end
	end
	return false
end

function SensorRect:collidingRight(tile)
	self:calculatePos()
	tileypos = tile:getAbsoluteHeight(self.xpos2)
	if not tileypos then return false end
	tilexpos2 = (tile.xpos + tile.width - 1)
	tileypos2 = (tile.ypos + tile.height - 1)
	if (self.ypos >= tileypos and self.ypos <= tileypos2) or (self.ypos2 >= tileypos and self.ypos2 <= tileypos2) then
		if self.xpos2 >= tile.xpos and self.xpos2 <= tilexpos2 then
			return true
		end
	end
	return false
end

function SensorRect:collidingUp(tile)
	self:calculatePos()
	tileypos = tile:getAbsoluteHeight(self.xpos)
	if not tileypos then return false end
	tilexpos2 = (tile.xpos + tile.width - 1)
	tileypos2 = (tile.ypos + tile.height - 1)
	if (self.xpos >= tile.xpos and self.xpos <= tilexpos2) or (self.xpos2 >= tile.xpos and self.xpos2 <= tilexpos2) then
		if self.ypos >= tileypos and self.ypos <= tileypos2 then
			return true, tileypos
		end
	end
	return false
end

function SensorRect:collidingDown(tile)
	self:calculatePos()
	tileypos = tile:getAbsoluteHeight(self.xpos)
	if not tileypos then return false end
	tilexpos2 = (tile.xpos + tile.width - 1)
	tileypos2 = (tile.ypos + tile.height - 1)
	if (self.xpos >= tile.xpos and self.xpos <= tilexpos2) or (self.xpos2 >= tile.xpos and self.xpos2 <= tilexpos2) then
		if self.ypos2 >= tileypos and self.ypos2 <= tileypos2 then
			return true, tileypos
		end
	end
	return false
end
