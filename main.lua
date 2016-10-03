require "character_sprite"
require "camera"
require "level1"
require "level2"
require "level3"
require "anims"

function math.getSign(i)
	if (i < 0) then return -1 else return 1 end
end

-- Executed at startup
function love.load()
	-- Loads default font
	love.graphics.setFont(love.graphics.newFont(10))

	-- Initialize levels
	levels = {Level1, Level2, Level3}
	levels[1]:init()
	levels[2]:init()
    levels[3]:init()

	levelnum = 0

	level = levels[1]

    hud = 1
    buffer = 0
    -- We want 60 engine frames per second
    speed = 60

    -- The camera must simulate the resolution from Sonic games
    gameCamera = Camera.create(320, 224, love.graphics.getWidth(), love.graphics.getHeight())
    gameCamera.leftBorder = 144
	gameCamera.rightBorder = 160
	gameCamera.topBorder = 64
	gameCamera.bottomBorder = 128
end

-- Executed each step
function love.update(dt)

    local rate = 1/speed

    -- If delta is too strong we won't take it into account
    if dt < 0.1 then
        buffer = buffer + dt
    end

    -- If rendering is too fast we skip the engine step
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

	        -- Engine physics step
	        level.mainChar:physicsStep(level.tileCollisions)
	        -- Checking triggers
	        level.mainChar:triggerObjects(level.triggers)

	    end
	    -- Updating the character's sprite animation
	    level.mainChar:updateSprite(1/60)

        local yOffset = 0

        -- When rolling, the character is 5 pixels shorter
        if level.mainChar.rolling then yOffset = -5 end

        if level.mainChar.mode == level.mainChar.modeAir then
            gameCamera:follow(level.mainChar.xpos,level.mainChar.ypos+yOffset)
        else
            gameCamera:moveToward(nil, level.mainChar.ypos+yOffset)
            gameCamera:follow(level.mainChar.xpos, nil)
        end

	    buffer = 0

    end

    -- Just for the lulz we put an elastic wall to the far left of the level
    if (level.mainChar.xpos < 0) then
		level.mainChar.xpos = 0
		level.mainChar.xspd = 10
		level.mainChar.grndspd = 10
		level.mainChar.facing = 1
    end

    -- Generating the spritebatchs etc.
    level:preRendering()

end

function love.keypressed(key)
	if key == "space" then
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
        hud = (hud+1)%4
	end
end

function love.keyreleased(key)
	if key == " " then
		level.mainChar:stopJump()
	end
end

function love.mousereleased(x, y, button)
  if button == 2 then
      gameCamera.zoom = 1
  end
	if button == 1 then
		level.mainChar.xpos, level.mainChar.ypos = gameCamera:windowToWorld(x, y)
	end
end

function love.wheelmoved(x, y)
    if y < 0 then
        gameCamera.zoom = gameCamera.zoom-0.1
    end
    if y > 0 then
        gameCamera.zoom = gameCamera.zoom+0.1
    end
end

-- Drawing operations
function love.draw()
	-- We scale the rendering for the camera
	love.graphics.scale(gameCamera:getZoomedRatio())

	level:render()

	-- We unscale for the hud to be the same
	love.graphics.scale(1/gameCamera:getZoomedRatio())

	if hud == 2 then
        love.graphics.print("Physics demo\n"..level.title.." Speed: "..speed.." FPS: "..love.timer.getFPS(), 0, 0)
        love.graphics.print("Speed:"..level.mainChar.grndspd.."\nXpos:"..level.mainChar.xpos.."\nYpos:"..level.mainChar.ypos.."\nMode:"..level.mainChar.mode.name.."\nAngle:"..level.mainChar.angle, 200, 0)
        love.graphics.print("XSpeed:"..level.mainChar.xspd.."\nYSpeed:"..level.mainChar.yspd, 400, 0)

        love.graphics.scale(gameCamera:getZoomedRatio())

		love.graphics.setColor(0,255,0)
        gameCamera:point(level.mainChar.xpos, level.mainChar.ypos+4)
        love.graphics.setColor(255,255,255)

        --
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
    elseif hud == 1 then
		love.graphics.print("Physics demo\n"..level.title.." Speed: "..speed.." FPS: "..love.timer.getFPS().."\nF1 to switch levels, R to reload level".."\nLeft/Right to move, Down to roll, Space to jump\nLeft click to spawn player\nMouse Wheel to zoom\nRight Click to reset zoom\nH to switch HUD, Escape to quit", 0, 0)
    elseif hud == 3 then
    	love.graphics.print("FPS: "..love.timer.getFPS(), 0, 0)
    end
end
