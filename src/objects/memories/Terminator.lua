local Terminator = Class{__includes=Memory}

function Terminator:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Robot Body"
	if love.math.random() < 0.3 then
		self.name = "Crazy Fucking Robot Body"
	end
	self.desc = [[It's not yet the time for terminator. At least we might get Robot Dog soon]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconneuroterminator.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return Terminator