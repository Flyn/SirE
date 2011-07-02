require "mainchar"

function love.load()
   -- love.graphics.setMode(1280, 720, false, true, 0)
   tile = love.graphics.newImage("tile.tga")
   tile:setFilter("nearest","nearest")
   ninjaChar = MainChar.create("ninja")
   ninjaChar.xpos = 20
   ninjaChar.ypos = 100
   tilexpos = 160
   tileypos = 100
end

function love.update(dt)
   if love.keyboard.isDown("left") then
      ninjaChar:moveLeft()
   end
   if love.keyboard.isDown("right") then
      ninjaChar:moveRight()
   end
   
end

function love.draw()
    love.graphics.print("Ninja physics demo", 400, 300)
    --love.graphics.draw(ninja, xpos, ypos, 0, 1, 1, 20, 20)
    ninjaChar:draw()
    love.graphics.draw(tile, tilexpos, tileypos)
end
