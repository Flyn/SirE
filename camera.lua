require "mixin"
Camera = Mixin:create()

Camera.xpos = 0
Camera.ypos = 0
Camera.zoom = 1

function Camera.create(width, height, winWidth, winHeight)
	local newCamera = {}
	Camera:mixin(newCamera)

	newCamera.width 	= width
	newCamera.height 	= height
	newCamera.winWidth 	= winWidth
	newCamera.winHeight	= winHeight
	newCamera.leftBorder = width/2
	newCamera.rightBorder = width/2
	newCamera.topBorder = height/2
	newCamera.bottomBorder = height/2

	local ratiox = math.max(width/winWidth, winWidth/width)
	local ratioy = math.max(height/winHeight, winHeight/height)

	newCamera.ratio = math.min(ratiox, ratioy)

	return newCamera
end

function Camera:windowToWorld(x, y)
	return self.xpos + x/self:getZoomedRatio(), self.ypos + y/self:getZoomedRatio()
end

function Camera:getZoomedRatio()
	return self.ratio*self.zoom
end

function Camera:getZoomedWidth()
	return self.width/self.zoom
end

function Camera:getZoomedHeight()
	return self.height/self.zoom
end

function Camera:centerOn(x, y)
    if x then
        self.xpos = x - (self.width/self.zoom) / 2
    end
    if y then
        self.ypos = y - (self.height/self.zoom) / 2
    end

	if self.xpos < 0 then self.xpos = 0 end
	if self.ypos < 0 then self.ypos = 0 end
end

function Camera:moveToward(x, y)
	if x then
		local diff = math.abs(x - gameCamera.xpos)
		if diff ~= (self.width/self.zoom) / 2 then
			self.xpos = self.xpos+math.max(math.min(diff-(self.width/self.zoom) / 2, 6),-6)
		end
	end
	if y then
		local diff = math.abs(y - gameCamera.ypos)
		if diff ~= (self.height/self.zoom) / 2 then
			self.ypos = self.ypos+math.max(math.min(diff-(self.height/self.zoom) / 2, 6),-6)
		end
	end
end

function Camera:follow(x, y)
	if x then
		if x <= self.xpos + (self.leftBorder/self.zoom) then
			self.xpos = x - (self.leftBorder/self.zoom)
		end
		if x > self.xpos + (self.rightBorder)/self.zoom then
			self.xpos = x - self.rightBorder/self.zoom
		end
	end
	if y then
		if y <= self.ypos + (self.topBorder/self.zoom) then
			self.ypos = y - (self.topBorder/self.zoom)
		end
		if y > self.ypos + self.bottomBorder/self.zoom then
			self.ypos = y - self.bottomBorder/self.zoom
		end
	end

	if self.xpos < 0 then self.xpos = 0 end
	if self.ypos < 0 then self.ypos = 0 end
end

function Camera:draw(drawable, x, y, ...)
	x = x or 0
	y = y or 0
	love.graphics.draw(drawable, x - self.xpos, y - self.ypos, ...)
end

function Camera:drawAnim(anim, x, y, ...)
	x = x or 0
	y = y or 0
	anim:draw(x - self.xpos, y - self.ypos, ...)
end

function Camera:point(x, y, ...)
	x = x or 0
	y = y or 0
	love.graphics.points(x - self.xpos, y - self.ypos, ...)
end

function Camera:rectangle(x, y, ...)
	x = x or 0
	y = y or 0
	love.graphics.rectangle("fill", x - self.xpos, y - self.ypos, ...)
end
