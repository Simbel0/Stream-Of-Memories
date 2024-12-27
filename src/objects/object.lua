--- The base object class I think

local Object = Class()

local function SortChildren(obj)
	-- I think table.sort is costly, so let's not waste power on it if there's no children to sort
	if #obj.children == 0 then return end
	table.sort( obj.children, function(a, b) return a.layer < b.layer end )
end

function Object:init(x, y)
	self.x = x
	self.y = y

	self.children = {}
	self.parent = nil

	self.layer = 100
end

function Object:setLayer(layer)
	self.layer = layer
	SortChildren(self)
end

return Object