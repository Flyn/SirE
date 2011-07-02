require "mainchar"

function love.load()
	--love.graphics.setMode(1280, 720, false, true, 0)
	tileImg = love.graphics.newImage("tile.tga")
	tileImg:setFilter("nearest","nearest")
	ninjaChar = MainChar.create("ninja")
	ninjaChar.xpos = 20
	ninjaChar.ypos = 100
	tile = {}
	tile.xpos = 350
	tile.ypos = 100
	zoom = false
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
	
	ninjaChar:updatePos()
	ninjaChar:isBumpingTiles({tile})
	
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
	 love.graphics.print("Speed:"..ninjaChar.xspd.."\nXpos:"..ninjaChar.xpos.."\nYpos"..ninjaChar.ypos, 200, 200)
	 love.graphics.line(0,ninjaChar.ypos+4,500,ninjaChar.ypos+4)
	 ninjaChar:draw()
	 love.graphics.draw(tileImg, tile.xpos, tile.ypos)
end
