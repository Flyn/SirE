require "character_sprite"
require "camera"
require "level1"
require "level2"
require "level3"
require "anims"

function math.getSign(i)
	if (i < 0) then return -1 else return 1 end
end

function love.load()
	love.graphics.setFont(love.graphics.newFont(10))
	
	levels = {Level1, Level2, Level3}
	levels[1]:init()
	levels[2]:init()
    levels[3]:init()
	
	levelnum = 0

	level = levels[1]
    
    hud = true
    buffer = 0
    speed = 60
    
    gameCamera = Camera.create(320, 224, love.graphics.getWidth(), love.graphics.getHeight())
    gameCamera.leftBorder = 144
	gameCamera.rightBorder = 160
	gameCamera.topBorder = 64
	gameCamera.bottomBorder = 128
end

function love.update(dt)

    local rate = 1/speed
    
    if dt < 0.1 then
        buffer = buffer + dt
    end
    
    if (buffer>=rate) then

	    for i = 1, math.floor((buffer/rate)+0.5) do
	        if love.keyboard.isDown("left") then
	            level.mainChar:moveLeft()
	        end
	        if love.keyboard.isDown("right") then
	            level.mainChar:moveRight()
	        end
	        if love.keyboard.isDown("down") then
	            level.mainChar:roll()	
	        end
	        if love.keyboard.isDown("escape") then
	            os.exit(0)
	        end
	        if love.keyboard.isDown("kp+") then
	            speed = speed+1
	        end
	        if love.keyboard.isDown("kp-") then
	            speed = speed-1
	        end
	        
	        speed = math.max(10, speed)
	        speed = math.min(600, speed)
	        
	        level.mainChar:physicsStep(level.tileCollisions)
	        level.mainChar:triggerObjects(level.triggers)
	    
	    end
	    level.mainChar:updateSprite(1/60)
        
        local yOffset = 0
	
        if level.mainChar.rolling then yOffset = -5 end

        if level.mainChar.mode == level.mainChar.modeAir then
            gameCamera:follow(level.mainChar.xpos,level.mainChar.ypos+yOffset)
        else
            gameCamera:moveToward(nil, level.mainChar.ypos+yOffset)
            gameCamera:follow(level.mainChar.xpos, nil)
        end
	    
	    buffer = 0
    
    end
    
    -- Just for the lulz
    if (level.mainChar.xpos < 0) then
		level.mainChar.xpos = 0
		level.mainChar.xspd = 10
		level.mainChar.grndspd = 10
		level.mainChar.facing = 1
    end
    
    level:preRendering()

end

function love.keypressed(key)
	if key == " " then
		level.mainChar:jump()
	end
	if key == "d" then
        debug:debug()
    end
	if key == "f1" then
		levelnum = (levelnum+1)%#levels
		level = levels[levelnum+1]
	end
	if key == "r" then
		level:init()
	end
	if key == "tab" then
		level.mainChar.grndspd = level.mainChar.mode.maxspd * level.mainChar.facing
		level.mainChar.xspd = level.mainChar.mode.maxspd * level.mainChar.facing
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
        gameCamera.zoom = 1
    end
    if button == "wd" then
        gameCamera.zoom = gameCamera.zoom-0.1
    end
    if button == "wu" then
        gameCamera.zoom = gameCamera.zoom+0.1
    end
	if button == "l" then
		level.mainChar.xpos, level.mainChar.ypos = gameCamera:windowToWorld(x, y)
	end
end

function love.draw()
	love.graphics.scale(gameCamera:getZoomedRatio())

	level:render()
	
	love.graphics.scale(1/gameCamera:getZoomedRatio())
    
	if hud then
        love.graphics.print("Physics demo\n"..level.title.." Speed: "..speed.." FPS: "..love.timer.getFPS().."\nF1 to switch levels, R to reload level".."\nLeft/Right to move\nLeft click to spawn player\nRight Click to zoom\nEscape to quit", 0, 0)
        love.graphics.print("Speed:"..level.mainChar.grndspd.."\nXpos:"..level.mainChar.xpos.."\nYpos:"..level.mainChar.ypos.."\nMode:"..level.mainChar.mode.name.."\nAngle:"..level.mainChar.angle, 200, 0)
        love.graphics.print("XSpeed:"..level.mainChar.xspd.."\nYSpeed:"..level.mainChar.yspd, 400, 0)
        
        love.graphics.scale(gameCamera:getZoomedRatio())
        
		love.graphics.setColor(0,255,0)
        gameCamera:point(level.mainChar.xpos, level.mainChar.ypos+4)
        love.graphics.setColor(255,255,255)
        
        if level.triggers then
            for i,trigger in ipairs(level.triggers) do
                love.graphics.setColor(0,255,255,60)
                gameCamera:rectangle(trigger.xpos, trigger.ypos, trigger.width, trigger.height)
                love.graphics.setColor(255,255,255,255)
            end
        end
        
        for priority, tiles in ipairs(level.tiles) do
			for i,tile in ipairs(tiles) do
				for i = 0, (tile.width-1) do
                    if tile.heightmap.heights then
                        love.graphics.setColor(0,0,255)
                        gameCamera:point(tile.xpos+i, tile:getAbsoluteHeight(tile.xpos+i))
                    end
                    if tile.widthmap.heights then
                        love.graphics.setColor(0,255,0)
                        gameCamera:point(tile:getAbsoluteWidth(tile.ypos+i), tile.ypos+i)
                    end
                    love.graphics.setColor(255,255,255)
                end
			end
		end
    else
		love.graphics.print("FPS: "..love.timer.getFPS(), 0, 0)
    end
end
