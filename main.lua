require "main_char"
require "anims"

function love.load()
	tileImg = love.graphics.newImage("tile.tga")
	tileImg:setFilter("nearest","nearest")
	ninjaChar = MainChar.create("ninja")
	ninjaChar.xpos = 20
	ninjaChar.ypos = 20
    tiles = {}
    for i = 1,25 do
        local tile = {}
        tile.xpos = 16*i
        tile.ypos = 112
        tile.width = 16
        tile.height = 16
        table.insert(tiles, tile)
	end
    local obstacle = {}
	obstacle.xpos = 100
	obstacle.ypos = 96
    obstacle.width = 16
	obstacle.height = 16
    table.insert(tiles, obstacle)
    local obstacle = {}
	obstacle.xpos = 350
	obstacle.ypos = 105
    obstacle.width = 16
	obstacle.height = 16
    table.insert(tiles, obstacle)
    local obstacle = {}
	obstacle.xpos = 10
	obstacle.ypos = 80
    obstacle.width = 16
	obstacle.height = 16
    table.insert(tiles, obstacle)
    
	zoom = true
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		ninjaChar:moveLeft()
	end
	if love.keyboard.isDown("right") then
		ninjaChar:moveRight()
	end
	if love.keyboard.isDown("up") then
		ninjaChar.ypos = ninjaChar.ypos-1
	end
	if love.keyboard.isDown("down") then
		ninjaChar.ypos = ninjaChar.ypos+1
	end
	if love.keyboard.isDown("escape") then
		os.exit(0)
	end
	
	ninjaChar:physicsStep(tiles)
	ninjaChar:update(dt)
	
end

function love.keypressed(key)
	if key == " " then
		ninjaChar:jump()
	end
end

function love.keyreleased(key)
	if key == " " then
		ninjaChar:stopJump()
	end
end

function love.mousereleased(x, y, button)
	if button == "r" then
		zoom = not zoom
	end
end

function love.draw()
	if zoom then
		love.graphics.scale(2,2)
	end
	love.graphics.print("Ninja physics demo\nLeft/Right to move\nRight Click to zoom\nEscape to quit", 0, 200)
	love.graphics.print("Speed:"..ninjaChar.grndspd.."\nXpos:"..ninjaChar.xpos.."\nYpos:"..ninjaChar.ypos, 200, 200)
	ninjaChar:draw()
    for i,tile in ipairs(tiles) do
        love.graphics.draw(tileImg, tile.xpos, tile.ypos)
    end
	love.graphics.setColor(255,255,0,255)
	love.graphics.line(ninjaChar.xpos-9,ninjaChar.ypos,ninjaChar.xpos-9,ninjaChar.ypos+20)
	love.graphics.line(ninjaChar.xpos+9,ninjaChar.ypos,ninjaChar.xpos+9,ninjaChar.ypos+20)
	love.graphics.setColor(0,255,0,255)
	love.graphics.line(ninjaChar.xpos-10,ninjaChar.ypos+4,ninjaChar.xpos+10,ninjaChar.ypos+4)
	love.graphics.setColor(255,255,255,255)
end
