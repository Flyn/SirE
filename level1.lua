require "mixin"
Level1 = Mixin:create()

Level1.title = "Test Level"

function Level1.create()
	local newLevel1 = {}
	Level1:mixin(newLevel1)
	
	newLevel1:createTiles()
	newLevel1:createObjects()

	return newLevel1
end

function Level1:createTiles()

	local tileImg = love.graphics.newImage("level1_tiles.tga")
	tileImg:setFilter("nearest","nearest")
	self.tiles = {}
		local defaulthm = {5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}
    tiles = {}
    for i = 2,10 do
        local tile = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
        tile.xpos = 32*i
        tile.ypos = 112
        tile.width = 32
        tile.height = 48
        table.insert(self.tiles, tile)
	end
	local hm = {}
	hm[1] = {10, 9, 8, 7, 7, 6, 6, 5, 5, 5, 5, 4, 4, 4, 4, 4}
	hm[2] = { 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}
	hm[3] = { 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8}
	hm[4] = { 9, 9,10,10,10,10,10,10,10,10,10,10,10,10,10,10}
	angles = {}
	angles[1] = 15
	angles[2] = 5
	angles[3] = -15
	angles[4] = -2
    for i = 1,50 do
		a = (i-1)%4
        local tile = Tile.create(tileImg, (2+a)*16, 0, 16, 48, hm[a+1], angles[a+1])
        tile.xpos = 64+16*i
        tile.ypos = 250
        table.insert(self.tiles, tile)
	end
	for i = 1,3 do
		local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
		obstacle.xpos = 16*i
		obstacle.ypos = 255
		table.insert(self.tiles, obstacle)
	end
    local obstacle = Tile.create(tileImg, 32, 0, 16, 48, {15,14,14,13,13,12,12,11,10,9,9,8,7,7,6,6}, 33)
	obstacle.xpos = 140
	obstacle.ypos = 102
    table.insert(self.tiles, obstacle)
    local obstacle = Tile.create(tileImg, 32, 0, 16, 48, {15,14,14,13,13,12,12,11,10,9,9,8,7,7,6,6}, 33)
	obstacle.xpos = 156
	obstacle.ypos = 93
    table.insert(self.tiles, obstacle)
    local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
	obstacle.xpos = 172
	obstacle.ypos = 93
    table.insert(self.tiles, obstacle)
    local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
	obstacle.xpos = 350
	obstacle.ypos = 105
    table.insert(self.tiles, obstacle)
    local obstacle = Tile.create(tileImg, 0, 0, 32, 48, defaulthm)
	obstacle.xpos = 8
	obstacle.ypos = 205
    table.insert(self.tiles, obstacle)
    
    self.tilesetBatch = love.graphics.newSpriteBatch(tileImg, #self.tiles)

end

function Level1:createObjects()
	self.objects = {}
	local ninjaChar = CharacterSprite.create("ninja")
	ninjaChar.xpos = 20
	ninjaChar.ypos = 20
	table.insert(self.objects, ninjaChar)
	self.mainChar = ninjaChar
end

function Level1:render()
    for i,tile in ipairs(self.tiles) do
        self.tilesetBatch:clear()
        self.tilesetBatch:addq(tile.quad, tile.xpos, tile.ypos)
        love.graphics.draw(self.tilesetBatch)
    end
    for i,object in ipairs(self.objects) do
		object:render()
    end
end