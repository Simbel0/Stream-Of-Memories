local Memory = Class{__includes=TubeTrailObject}

function Memory:init(path, speed)
	TubeTrailObject.init(self, path, speed)
	print("Memory creation")

	self.color = {1, 1, 1}

	self.name = "Memory"
	self.desc = "Memory Description"

	self.gameTexture = nil

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

function Memory:getName()
	return self.name
end

function Memory:getDescription()
	return self.desc
end

function Memory:getGameTexture()
	return self.gameTexture
end

function Memory:getStreamTexture()
	return self.streamTexture
end

function Memory:getClipID()
	return self.clipLink
end

function Memory:getYoutubeClipLink()
	return "https://youtube.com/watch?w="..self:getClipID()
end

function Memory:getPositionCenteredToTexture()
	local tex = self:getGameTexture()
	local x, y = self:getPosition()

	if tex == nil then
		return x, y
	end

	local w, h = tex:getDimensions()

	return x-(w*MEMORY_SCALE)/2, y-(h*MEMORY_SCALE)/2
end

function Memory:onPathCompleted()
	TubeTrailObject.onPathCompleted(self)

	print("Memory "..self:getName().." has done its path")
	Signal.emit("memoryInNeuro", self)
end

function Memory:draw()
	love.graphics.setColor(self:getColor())
	local tex = self:getGameTexture()
	if tex then
		local x, y = self:getPositionCenteredToTexture()
		love.graphics.draw(tex, x, y, 0, MEMORY_SCALE, MEMORY_SCALE)
	end

	love.graphics.setColor(0, 0, 1, 1)
	TubeTrailObject.draw(self)
end

function Memory:onMousePressed(mX, mY, button, istouch, presses)
	print("Running Memory's onMousePressed")
	TubeTrailObject.onMousePressed(self, mX, mY, button, istouch, presses)
	if button == 1 then

		if self:isClickedOn(mX, mY) then
			print("Clicked")
			self:remove()
		end
	end
end

function Memory:isClickedOn(mX, mY)
	local x, y = self:getPosition()
	local tex = self:getGameTexture()

	local w, h
	if tex then
		w, h = tex:getDimensions()
	elseif self.width and self.height then
		w, h = self.width, self.height
	else
		return false
	end

	print(x, y, mX, mY, self:getRelativePosition())

	return mX > x and
		   mX < x+(w*MEMORY_SCALE) and
		   mY > y and
		   mY < y+(h*MEMORY_SCALE)
end

return Memory