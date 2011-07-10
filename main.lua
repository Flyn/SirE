require "character_sprite"
require "tile"
require "level1"
require "anims"

function love.load()
	level = Level1.create()
    
	zoom = 2
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		level.mainChar:moveLeft()
	end
	if love.keyboard.isDown("right") then
		level.mainChar:moveRight()
	end
	if love.keyboard.isDown("up") then
		level.mainChar.ypos = level.mainChar.ypos-1
	end
	if love.keyboard.isDown("down") then
		level.mainChar.ypos = level.mainChar.ypos+1
	end
	if love.keyboard.isDown("escape") then
		os.exit(0)
	end
	if love.keyboard.isDown("d") then
		debug:debug()
	end
	
	level.mainChar:physicsStep(level.tiles)
	level.mainChar:update(dt)
	
end

function love.keypressed(key)
	if key == " " then
		level.mainChar:jump()
	end
end

function love.keyreleased(key)
	if key == " " then
		level.mainChar:stopJump()
	end
end

function love.mousereleased(x, y, button)
	if button == "r" then
		zoom = 2/zoom
	end
	if button == "l" then
		level.mainChar.xpos = x/zoom
		level.mainChar.ypos = y/zoom
	end
end

function love.draw()
	love.graphics.scale(zoom,zoom)

	love.graphics.print("Physics demo\nLeft/Right to move\nLeft click to spawn player\nRight Click to zoom\nEscape to quit", 0, 0)
	love.graphics.print("Speed:"..level.mainChar.grndspd.."\nXpos:"..level.mainChar.xpos.."\nYpos:"..level.mainChar.ypos, 200, 200)
	level:render()
end
