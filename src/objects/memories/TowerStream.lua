local Tower = Class{__includes=Memory}

function Tower:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Tower Stream"
	self.desc = [[Did Neuro ever ended up at the top of a tower with the wind blowing up everyone's ears?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/icontowerstream.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return Tower