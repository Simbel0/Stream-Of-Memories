local TubePath = Class{__include=Object}

function TubePath:init(x, y, path_pos)
	Object.init(self, x, y)
	
	self.nodes = {}
	for i,node in ipairs(path_pos) do
		local x, y = node[1], node[2]
		table.insert(self.nodes, TubeNode(x, y))
	end
end

function TubePath:getNodeAmount()
	return #self.nodes
end

function TubePath:getNode(index)
	return self.nodes[index]
end

function TubePath:getNodePos(index)
	local node = self:getNode(index)
	return {node.x, node.y}
end

return TubePath