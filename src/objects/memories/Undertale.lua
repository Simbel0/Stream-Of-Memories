local Undertale = Class{__includes=Memory}

function Undertale:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Undertale"
	self.desc = [[Could an AI kill Papyrus?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconneuroundertale.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return Undertale