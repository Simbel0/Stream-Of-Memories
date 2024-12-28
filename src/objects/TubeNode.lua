local TubeNode = Class{__includes=Object}

function TubeNode:init(x, y)
	Object.init(self, x, y)
	self.class_id = "TubeNode"

	self.color = {0, 1, 0}
	self.alpha = 0.3
end

function TubeNode:draw()
	Object.draw(self)

	if DEBUG_VIEW then
		local r, g, b = self:getColor()
		love.graphics.setColor(r, g, b, self.alpha+0.3)

		local x, y = self:getPosition()
		love.graphics.print(self.parent:getNodeNumber(self), x, y)
	end
end

return TubeNode