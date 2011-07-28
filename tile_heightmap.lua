require "mixin"
TileHeightmap = Mixin:create()

TileHeightmap.heights = nil

function TileHeightmap.create(heights)
	local newTileHeightmap = {}
	TileHeightmap:mixin(newTileHeightmap)
	
	newTileHeightmap.heights = heights

	return newTileHeightmap
end
