require "main_char"

function love.load()
	tileImg = love.graphics.newImage("tile.tga")
	tileImg:setFilter("nearest","nearest")
	ninjaChar = MainChar.create("ninja")
	ninjaChar.xpos = 20
	ninjaChar.ypos = 100
	tile = {}
	tile.xpos = 350
	tile.ypos = 100
	tile.width = 16
	tile.height = 16
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
	if ninjaChar:isOnGround({tile}) then
		ground = "yes"
	else
		ground = "no"
	end
	love.graphics.print("Ninja physics demo\nLeft/Right to move\nRight Click to zoom\nEscape to quit", 0, 200)
	love.graphics.print("Speed:"..ninjaChar.grndspd.."\nXpos:"..ninjaChar.xpos.."\nYpos:"..ninjaChar.ypos.."\nTouch ground:"..ground, 200, 200)
	ninjaChar:draw()
	love.graphics.draw(tileImg, tile.xpos, tile.ypos)
	love.graphics.setColor(255,255,0,255)
	love.graphics.line(ninjaChar.xpos-9,ninjaChar.ypos,ninjaChar.xpos-9,ninjaChar.ypos+20)
	love.graphics.line(ninjaChar.xpos+9,ninjaChar.ypos,ninjaChar.xpos+9,ninjaChar.ypos+20)
	love.graphics.setColor(0,255,0,255)
	love.graphics.line(ninjaChar.xpos-10,ninjaChar.ypos+4,ninjaChar.xpos+10,ninjaChar.ypos+4)
	love.graphics.setColor(255,255,255,255)
end
