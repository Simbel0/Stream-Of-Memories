local Karaoke = Class{__includes=Memory}

function Karaoke:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Karaoke"
	self.desc = [[Probably the most popular type of streams for Neuro and Evil (and Vedal that one time).
With more than 600 songs covered, everyone has been able to see the evolution of the twins' voice
over those last 2 years.]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconkaraoke.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return Karaoke