local TubePath = Class{__include=Object}

function TubePath:init(x, y)
	Object.init(self, x, y)
	self.path = {{100, 100}}
end

return TubePath