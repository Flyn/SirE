function love.load()
   -- love.graphics.setMode(1280, 720, false, true, 0)
   ninja = love.graphics.newImage("ninja.tga")
   ninja:setFilter("nearest","nearest")
   tile = love.graphics.newImage("tile.tga")
   tile:setFilter("nearest","nearest")
   xpos = 20
   ypos = 100
   tilexpos = 160
   tileypos = 100
end

function love.update(dt)
   if love.keyboard.isDown("left") then
      xpos = xpos - 1
   end
   if love.keyboard.isDown("right") then
      xpos = xpos + 1
   end
   
end

function love.draw()
    love.graphics.print("Ninja physics demo", 400, 300)
    love.graphics.draw(ninja, xpos, ypos, 0, 1, 1, 20, 20)
    love.graphics.draw(tile, tilexpos, tileypos)
end
