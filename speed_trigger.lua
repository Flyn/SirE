require "mixin"
SpeedTrigger = Mixin:create()

function SpeedTrigger.create(xpos, ypos, width, height, speed)
	local newTrigger = {}
	SpeedTrigger:mixin(newTrigger)
	
	newTrigger.xpos = xpos or 0
	newTrigger.ypos = ypos or 0
	newTrigger.width = width or 16
	newTrigger.height = height or 16
	newTrigger.speed = speed or 6

	return newTrigger
end

function SpeedTrigger:setTarget(object)
	self.target = object
end

function SpeedTrigger:trigger()
	self.target.grndspd = self.speed*math.getSign(self.target.grndspd)
end
