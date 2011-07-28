require "mixin"
TileHeightmap = Mixin:create()

TileHeightmap.heights = nil

function TileHeightmap.create(heights)
	local newTileHeightmap = {}
	TileHeightmap:mixin(newTileHeightmap)
	
	newTileHeightmap.heights = heights

	return newTileHeightmap
end


function TileHeightmap:getWidthmap()
    local widths = {}
    
    for i = 1,#self.heights do
        widths[i] = #self.heights
    end
    
    local found = false
    for y, width in ipairs(widths) do
        for x, height in ipairs(self.heights) do
            if height < y and not found then
                widths[y] = x-1
                found = true
            end
        end
        found = false
    end
    
    return TileHeightmap.create(widths)
end
