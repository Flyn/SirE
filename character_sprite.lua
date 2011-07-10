require "sensor_rect"
require "character"
CharacterSprite = Mixin:create(Character)

function CharacterSprite.create(name)
	local newChar = {}
	CharacterSprite:mixin(newChar)
	local idleImage = love.graphics.newImage(name .. "_idle.tga")
	idleImage:setFilter("nearest","nearest")
	newChar.idleAnim = newAnimation(idleImage, 30, 40, 0.1, 0)
	local walkImage = love.graphics.newImage(name .. "_walking.tga")
	walkImage:setFilter("nearest","nearest")
	newChar.walkAnim = newAnimation(walkImage, 48, 40, 1, 0)
	local rollImage = love.graphics.newImage(name .. "_rolling.tga")
	rollImage:setFilter("nearest","nearest")
	newChar.rollAnim = newAnimation(rollImage, 32, 32, 0.5, 0)
	
	newChar.currentAnim = newChar.idleAnim

	return newChar
end

function CharacterSprite:update(dt)
	local oldAnim = self.currentAnim
	if (self.grndspd == 0) then
		self.currentAnim = self.idleAnim
	else
		self.currentAnim = self.walkAnim
		self.currentAnim:setSpeed(5+math.abs(self.grndspd))
	end
	
	if self.rolling then
		self.currentAnim = self.rollAnim
		self.currentAnim:setSpeed(5+math.abs(self.grndspd))
	end

	if oldAnim ~= self.currentAnim then
		self.currentAnim:reset()
	end
	
	self.currentAnim:update(dt)
end

function CharacterSprite:render()
	self.currentAnim:draw(self.xpos, self.ypos, 0, self.facing, 1, self.currentAnim:getWidth()/2, self.currentAnim:getHeight()-(self.height/2))
end
