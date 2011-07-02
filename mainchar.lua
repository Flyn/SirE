MainChar = {}

MainChar.__index = MainChar

function MainChar.create(name)
	local newChar = {}
	setmetatable(newChar, MainChar)
	newChar.image = love.graphics.newImage(name .. ".tga")
	newChar.image:setFilter("nearest","nearest")
	newChar.xpos = 0
	newChar.ypos = 0
	return newChar
end

function MainChar:moveRight()
	self.xpos = self.xpos + 1
end

function MainChar:moveLeft()
	self.xpos = self.xpos - 1
end

function MainChar:draw()
	love.graphics.draw(self.image, self.xpos, self.ypos, 0, 1, 1, 20, 20)
end
