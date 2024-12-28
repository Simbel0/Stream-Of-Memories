local Gymbag = Class{__includes=Memory}

function Gymbag:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Tower"
	self.desc = [[Did Neuro ever climb a tower?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/nono.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return Gymbag