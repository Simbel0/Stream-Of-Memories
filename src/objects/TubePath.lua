local TubePath = Class{__includes=Object}

function TubePath:init(path_pos)
	Object.init(self, 0, 0)

	self.color = {1, 0, 0}
	self.class_id = "TubePath"
	
	self.nodes = {}
	for i,node in ipairs(path_pos) do
		local x, y = node[1], node[2]
		local nodeClass = TubeNode(x, y)
		table.insert(self.nodes, nodeClass)
		self:addChild(nodeClass)
	end
end

function TubePath:getNodeAmount()
	return #self.nodes
end

function TubePath:getNodeNumber(node)
	for i,n in ipairs(self.nodes) do
		if n == node then
			return i
		end
	end
	return -1
end

function TubePath:getNode(index)
	return self.nodes[index]
end

function TubePath:getNodePos(index)
	return {self:getNode(index):getPosition()}
end

return TubePath