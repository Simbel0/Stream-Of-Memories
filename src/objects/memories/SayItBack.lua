local SayItBack = Class{__includes=Memory}

function SayItBack:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Say It Back fr"
	self.desc = [[While some people will argue he did say it back
He never said it back for real without getting tricked in some way.]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconsayitback.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return SayItBack