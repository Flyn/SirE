require "mixin"
LayerTrigger = Mixin:create()

function LayerTrigger.create(xpos, ypos, width, height, layerLeft, layerRight)
	local newTrigger = {}
	LayerTrigger:mixin(newTrigger)
	
	newTrigger.xpos = xpos or 0
	newTrigger.ypos = ypos or 0
	newTrigger.width = width or 16
	newTrigger.height = height or 16
	newTrigger.layerLeft = layerLeft or 1
	newTrigger.layerRight = layerRight or 1

	return newTrigger
end

function LayerTrigger:setTarget(object)
	self.target = object
end

function LayerTrigger:trigger()
	if self.target.xspd < 0 then
		self.target.layer = self.layerLeft
	elseif self.target.xspd > 0 then
		self.target.layer = self.layerRight
	end
end
