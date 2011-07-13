require "character_sprite"
require "tile"
require "level1"
require "anims"

function love.load()
	level = Level1.create()
    
	zoom = 2
    hud = true
    buffer = 0
    speed = 60
end

function love.update(dt)

    local rate = 1/speed
    
    buffer = buffer + dt
    
    if (buffer>=rate) then

    for i = 1, math.floor((buffer/rate)+0.5) do
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
        if love.keyboard.isDown("kp+") then
            speed = speed+1
        end
        if love.keyboard.isDown("kp-") then
            speed = speed-1
        end
        
        speed = math.max(10, speed)
        speed = math.min(600, speed)
        
        level.mainChar:physicsStep(level.tiles)
    
    end
    level.mainChar:update(1/60)
    
    buffer = 0
    
    end
	
end

function love.keypressed(key)
	if key == " " then
		level.mainChar:jump()
	end
	if key == "h" then
        hud = not hud
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

	level:render()
    

	if hud then
        love.graphics.print("Physics demo Speed: "..speed.." FPS: "..love.timer.getFPS().."\nLeft/Right to move\nLeft click to spawn player\nRight Click to zoom\nEscape to quit", 0, 0)
        love.graphics.print("Speed:"..level.mainChar.grndspd.."\nXpos:"..level.mainChar.xpos.."\nYpos:"..level.mainChar.ypos, 200, 200)
        for i,tile in ipairs(level.tiles) do
            for i = 0, (tile.width-1) do
                love.graphics.setColor(0,0,255)
                love.graphics.point(tile.xpos+i, tile:getAbsoluteHeight(tile.xpos+i))
                love.graphics.setColor(255,255,255)
            end
        end
    end
end
