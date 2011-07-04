SensorRect = {}

SensorRect.__index = SensorRect

function SensorRect.create(parent, x1, x2, y1, y2)
	local sensor = {}
	setmetatable(sensor, SensorRect)
	sensor.parent = parent
	sensor.relx1= x1
	sensor.relx2= x2
	sensor.rely1= y1
	sensor.rely2= y2
	return sensor
end

function SensorRect:calculatePos()
	self.xpos = math.floor(self.parent.xpos + self.relx1)
	self.xpos2 = math.ceil(self.parent.xpos + self.relx2)
	self.ypos = math.floor(self.parent.ypos + self.rely1)
	self.ypos2 = math.ceil(self.parent.ypos + self.rely2)
end

function SensorRect:isColliding(tile)
	return (self:collidingLeft(tile) or self:collidingRight(tile) or self:collidingUp(tile) or self:collidingDown(tile))
end

function SensorRect:collidingLeft(tile)
	self:calculatePos()
	tilexpos2 = (tile.xpos + tile.width)
	tileypos2 = (tile.ypos + tile.height)
	if (self.ypos >= tile.ypos and self.ypos <= tileypos2) or (self.ypos2 >= tile.ypos and self.ypos2 <= tileypos2) then
		if self.xpos >= tile.xpos and self.xpos <= tilexpos2 then
			return true
		end
	end
	return false
end

function SensorRect:collidingRight(tile)
	self:calculatePos()
	tilexpos2 = (tile.xpos + tile.width)
	tileypos2 = (tile.ypos + tile.height)
	if (self.ypos >= tile.ypos and self.ypos <= tileypos2) or (self.ypos2 >= tile.ypos and self.ypos2 <= tileypos2) then
		if self.xpos2 >= tile.xpos and self.xpos2 <= tilexpos2 then
			return true
		end
	end
	return false
end

function SensorRect:collidingUp(tile)
	self:calculatePos()
	tilexpos2 = (tile.xpos + tile.width)
	tileypos2 = (tile.ypos + tile.height)
	if (self.xpos >= tile.xpos and self.xpos <= tilexpos2) or (self.xpos2 > tile.xpos and self.xpos2 <= tilexpos2) then
		if self.ypos >= tile.ypos and self.ypos <= tileypos2 then
			return true
		end
	end
	return false
end

function SensorRect:collidingDown(tile)
	self:calculatePos()
	tilexpos2 = (tile.xpos + tile.width)
	tileypos2 = (tile.ypos + tile.height)
	if (self.xpos >= tile.xpos and self.xpos <= tilexpos2) or (self.xpos2 >= tile.xpos and self.xpos2 <= tilexpos2) then
		if self.ypos2 >= tile.ypos and self.ypos2 <= tileypos2 then
			return true
		end
	end
	return false
end
