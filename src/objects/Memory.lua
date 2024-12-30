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

	self.nameTextAlpha = 0
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
	Signal.emit("game-memoryInNeuro", self)
end

function Memory:update()
	TubeTrailObject.update(self)

	if self:mouseHovered(love.mouse:getPosition()) then
		self.nameTextAlpha = self.nameTextAlpha + 1*DT
	else
		self.nameTextAlpha = self.nameTextAlpha - 1*DT
	end
	if self.nameTextAlpha > 1 then self.nameTextAlpha = 1 elseif
	   self.nameTextAlpha < 0 then self.nameTextAlpha = 0 end

end

function Memory:draw()
	love.graphics.setColor(self:getColor())
	local tex = self:getGameTexture()
	local x, y = self:getPositionCenteredToTexture()
	if tex then
		love.graphics.draw(tex, x, y, 0, MEMORY_SCALE, MEMORY_SCALE)
	end

	local r, g, b = self:getColor()
	love.graphics.setColor(r, g, b, self.nameTextAlpha)
	love.graphics.print(self:getName(), x, y-32)

	if DEBUG_VIEW and tex then
		local x, y = self:getPosition()
		local w, h = tex:getDimensions()

		x = x - (w*MEMORY_SCALE)/2
		y = y - (h*MEMORY_SCALE)/2



		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line", x, y, w*MEMORY_SCALE, h*MEMORY_SCALE)
	end

	love.graphics.setColor(0, 0, 1, 1)
	TubeTrailObject.draw(self)
end

function Memory:onMousePressed(mX, mY, button, istouch, presses)
	TubeTrailObject.onMousePressed(self, mX, mY, button, istouch, presses)
	if button == 1 then

		if self:mouseHovered(mX, mY) then
			self:remove()
		end
	end
end

function Memory:mouseHovered(mX, mY)
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

	x = x - (w*MEMORY_SCALE)/2
	y = y - (h*MEMORY_SCALE)/2

	--print(x, y, mX, mY, self:getRelativePosition())

	return mX > x and
		   mX < x+(w*MEMORY_SCALE) and
		   mY > y and
		   mY < y+(h*MEMORY_SCALE)
end

return Memory