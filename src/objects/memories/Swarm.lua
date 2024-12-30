local Swarm = Class{__includes=Memory}

function Swarm:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Swarm"
	self.desc = [[Neuro's fans and army to take over the world!
A legion of drones that may exterminate the world once if the twins so desire...
For now, they just spam emotes in chat.]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconswarm.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return Swarm