require "mixin"
TileHeightmap = Mixin:create()

TileHeightmap.heights = nil
TileHeightmap.angle = 0

function TileHeightmap.create(heights, angle)
	local newTileHeightmap = {}
	TileHeightmap:mixin(newTileHeightmap)
	
	newTileHeightmap.heights = heights
	newTileHeightmap.angle = angle or 0

	return newTileHeightmap
end
