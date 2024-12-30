local CaveStream = Class{__includes=Memory}

function CaveStream:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Cave Stream"
	self.desc = [[It's Neuro! And she's in a cave! And her voice has a echo effect on it!
Isn't that such a great idea? So good we got Cave Stream 2.
Note that losing yourself in a cave for content might not be a good idea
if you're not an AI.]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconcavestream.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return CaveStream