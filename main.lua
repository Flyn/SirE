require "character_sprite"
require "tile"
require "anims"

function love.load()
	tileImg = love.graphics.newImage("level1_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	ninjaChar = CharacterSprite.create("ninja")
	ninjaChar.xpos = 20
	ninjaChar.ypos = 20
	local defaulthm = {5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}
    tiles = {}
    for i = 2,10 do
        local tile = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
        tile.xpos = 32*i
        tile.ypos = 112
        tile.width = 32
        tile.height = 48
        table.insert(tiles, tile)
	end
	local hm = {}
	hm[1] = {10, 9, 8, 7, 7, 6, 6, 5, 5, 5, 5, 4, 4, 4, 4, 4}
	hm[2] = { 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}
	hm[3] = { 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8}
	hm[4] = { 9, 9,10,10,10,10,10,10,10,10,10,10,10,10,10,10}
    for i = 1,50 do
		a = (i-1)%4
        local tile = Tile.create(tileImg, (2+a)*16, 0, 16, 48, hm[a+1])
        tile.xpos = 16*i
        tile.ypos = 250
        table.insert(tiles, tile)
	end
    local obstacle = Tile.create(tileImg, 32, 0, 16, 48, {15,14,14,13,13,12,12,11,10,9,9,8,7,7,6,6})
	obstacle.xpos = 100
	obstacle.ypos = 96
    table.insert(tiles, obstacle)
    local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
	obstacle.xpos = 116
	obstacle.ypos = 96
    table.insert(tiles, obstacle)
    local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
	obstacle.xpos = 350
	obstacle.ypos = 105
    table.insert(tiles, obstacle)
    local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
	obstacle.xpos = 10
	obstacle.ypos = 200
    table.insert(tiles, obstacle)
    
	zoom = 2
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
	if love.keyboard.isDown("d") then
		debug:debug()
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
		zoom = 2/zoom
	end
	if button == "l" then
		ninjaChar.xpos = x/zoom
		ninjaChar.ypos = y/zoom
	end
end

function love.draw()
	love.graphics.scale(zoom,zoom)

	love.graphics.print("Physics demo\nLeft/Right to move\nLeft click to spawn player\nRight Click to zoom\nEscape to quit", 0, 0)
	love.graphics.print("Speed:"..ninjaChar.grndspd.."\nXpos:"..ninjaChar.xpos.."\nYpos:"..ninjaChar.ypos, 200, 200)
	ninjaChar:draw()
    for i,tile in ipairs(tiles) do
        tile:draw()
        for i = 0, (tile.width-1) do
			love.graphics.setColor(0,0,255)
			love.graphics.point(tile.xpos+i, tile:getAbsoluteHeight(tile.xpos+i))
			love.graphics.setColor(255,255,255)
        end
    end
end
