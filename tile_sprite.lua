require "mixin"
TileSprite = Mixin:create()

TileSprite.width = 0
TileSprite.height = 0
TileSprite.quad = nil

function TileSprite.create(image, x, y, w, h)
	local newTileSprite = {}
	TileSprite:mixin(newTile)
	
	newTileSprite.width = w
	newTileSprite.height = h
	newTileSprite.quad = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())
	newTileSprite.heightmap = heightmap
	newTileSprite.angle = angle or 0

	return newTile
end
