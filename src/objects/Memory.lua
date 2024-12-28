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

	Signal.emit("memoryInNeuro")
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

function Memory:draw()
	love.graphics.setColor(self:getColor())
	local tex = self:getGameTexture()
	if tex then
		local x, y = self:getPosition()
		love.graphics.draw(tex, x, y, 0, 0.5, 0.5)
	end

	TubeTrailObject.draw(self)
end

return Memory