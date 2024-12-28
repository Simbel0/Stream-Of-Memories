local TubeNode = Class{__includes=Object}

function TubeNode:init(x, y)
	Object.init(self, x, y)
end

function TubeNode:draw()
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.circle("fill", self.x, self.y, 5)
end

return TubeNode