local YourReality = Class{__includes=Memory}

function YourReality:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Your Reality"
	self.desc = [[The 2020 Dodge Charger is a 4 door]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconyourreality.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return YourReality