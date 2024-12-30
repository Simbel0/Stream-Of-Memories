local AdoptCat = Class{__includes=Memory}

function AdoptCat:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Adopted cat"
	self.desc = [[If Vedal adopts a cat, would that make it Neuro's cat as well? Would the cat interact with her?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconneuroadoptscat.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return AdoptCat