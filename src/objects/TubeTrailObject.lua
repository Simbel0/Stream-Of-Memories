local TubeTrailObject = Class{__includes=Object}

function TubeTrailObject:init(path, speed)
	local x, y = path:getNode(1)
	Object.init(self, x, y)
	self.color = {0, 0, 1}

	self.class_id = "TubeTrailObject"

	self.path = path

	self.lerp_speed = speed or MEMORY_SPEED
	self.lerp_progress = 0
	self.current_index = 1

	self.pathDone = false
end

function TubeTrailObject:update()
	Object.update(self)
	if self.path == nil then return end
	if self.pathDone then return end
	if self.current_index >= self.path:getNodeAmount() then
		self:onPathCompleted()
		return
	end

	local currNode = self.path:getNode(self.current_index)
	local nextNode = self.path:getNode(self.current_index+1)

    local x1, y1 = currNode:getPosition()
    local x2, y2 = nextNode:getPosition()

    local dx, dy = x2 - x1, y2 - y1
    local dist = math.sqrt(dx * dx + dy * dy)

    self.lerp_progress = self.lerp_progress + (self.lerp_speed * DT) / dist

    if self.lerp_progress >= 1 then
        self.current_index = self.current_index + 1
        self.lerp_progress = 0
    end

    --print(self:getPosition())
end

function TubeTrailObject:getPosition()
    if self.current_index >= self.path:getNodeAmount() then
        return self.path:getNode(self.path:getNodeAmount()):getPosition()
    end

    local currNode = self.path:getNode(self.current_index)
    local nextNode = self.path:getNode(self.current_index + 1)

    local x1, y1 = currNode:getPosition()
    local x2, y2 = nextNode:getPosition()

    local x = x1 + (x2 - x1) * self.lerp_progress
    local y = y1 + (y2 - y1) * self.lerp_progress

    return x, y
end

function TubeTrailObject:onPathCompleted()
	self.pathDone = true
end

return TubeTrailObject