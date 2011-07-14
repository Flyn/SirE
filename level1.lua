require "mixin"
require "tile_sprite"
Level1 = Mixin:create()

Level1.title = "Test Level"

function Level1.create()
	local newLevel1 = {}
	Level1:mixin(newLevel1)
	
	newLevel1:createTiles()
	newLevel1:createObjects()
	newLevel1:populateLevel()

	return newLevel1
end

function Level1:createTiles()


end

function Level1:createObjects()
	self.objects = {}
	local ninjaCharSprite = CharacterSprite.create("ninja")
	local ninjaChar = Character.create(ninjaCharSprite)
	ninjaChar.xpos = 20
	ninjaChar.ypos = 20
	table.insert(self.objects, ninjaChar)
	self.mainChar = ninjaChar
end

function Level1:populateLevel()
	self.mainChar.xpos = 20
	self.mainChar.ypos = 20
end

function Level1:render()

    self.tilesetBatch:clear()
    for i,tile in ipairs(self.tiles) do
        self.tilesetBatch:addq(tile.quad, tile.xpos, tile.ypos)
    end
    love.graphics.draw(self.tilesetBatch)

    for i,object in ipairs(self.objects) do
		object:renderSprite()
    end
end
