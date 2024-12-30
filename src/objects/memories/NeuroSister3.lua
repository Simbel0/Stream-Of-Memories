local NeuroSister3 = Class{__includes=Memory}

function NeuroSister3:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "3rd Neuro Sister"
	self.desc = [[For now, it's a fake memory. But hey, maybe Vedal and Anny will change that at some point.]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconhappyneurosister.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return NeuroSister3