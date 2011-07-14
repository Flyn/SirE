require "sensor_rect"
require "character"
CharacterSprite = Mixin:create()

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
	
	newChar.rotation = 0

	return newChar
end

function CharacterSprite:update(dt)
	
end

function CharacterSprite:render(charObj)
	self.currentAnim:draw(charObj.xpos, charObj.ypos, self.rotation, charObj.facing, 1, self.currentAnim:getWidth()/2, self.currentAnim:getHeight()-(charObj.height/2))
end
