require "mixin"
TileSprite = Mixin:create()

TileSprite.width = 0
TileSprite.height = 0
TileSprite.quad = nil

function TileSprite.create(image, x, y, w, h)
	local newTileSprite = {}
	TileSprite:mixin(newTileSprite)
	
	newTileSprite.width = w
	newTileSprite.height = h
	newTileSprite.quad = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())

	return newTileSprite
end
