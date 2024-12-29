--- The base object class I think

local Object = Class()

local function SortChildren(obj)
	-- I think table.sort is costly, so let's not waste power on it if there's no children to sort
	if #obj.children == 0 then return end
	table.sort( obj.children, function(a, b) return a.layer < b.layer end )
end

function Object:init(x, y, w, h)
	self.x = x or 0
	self.y = y or 0

	self.width = w or 0
	self.height = h or 0

	self.class_id = "Object"

	self.children = {}
	self.parent = nil

	self.layer = 100

	self.color = {1, 1, 1}
	self.alpha = 1
end

function Object:setLayer(layer)
	self.layer = layer
	if self.parent then
		SortChildren(self.parent)
	end
end

function Object:addChild(obj)
	if not obj then
		error("No object was given to Object:addChild()")
	end
	table.insert(self.children, obj)
	if obj.parent ~= nil then
		obj.parent:removeChild(obj)
	end
	obj.parent = self
	SortChildren(self)
end

function Object:removeChild(obj)
	for i,child in ipairs(self.children) do
		if child == obj then
			table.remove(self.children, i)
			child.parent = nil
		end
	end
end

function Object:remove()
	if self.parent then
		self.parent:removeChild(self)
	end

	for i,child in ipairs(self.children) do
		child:remove()
	end
end

function Object:getPosition()
    if self.parent then
        local px, py = self.parent:getPosition()
        return self.x + px, self.y + py
    else
        return self.x, self.y
    end
end

function Object:getRelativePosition()
	return self.x, self.y
end

function Object:getColor()
	return self.color[1], self.color[2], self.color[3], self.alpha
end

function Object:update()
	for i,child in ipairs(self.children) do
		child:update()
	end
end

function Object:draw()
	for i,child in ipairs(self.children) do
		child:draw()
	end

	if DEBUG_VIEW then
		local x, y = self:getPosition()
		love.graphics.setColor(self:getColor())
		love.graphics.circle("fill", x, y, 5)
	end
end

return Object