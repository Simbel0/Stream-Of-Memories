local Gymbag = Class{__includes=Memory}

function Gymbag:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Gymbag"
	self.desc = [[According to Neuro-sama, she smells like one of those.
	Ever since her insane rant about her smelling like a gymbag, it somehow
	became one of the few representations of the Swarm, sometimes even being a drone!
	Chat reflects the streamer, I guess.]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/gymbag.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return Gymbag