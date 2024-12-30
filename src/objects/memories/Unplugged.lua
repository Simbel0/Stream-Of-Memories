local Unplugged = Class{__includes=Memory}

function Unplugged:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Unplugged"
	self.desc = [[Surely this day will never happen, right?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconunplugged.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = false
end

return Unplugged