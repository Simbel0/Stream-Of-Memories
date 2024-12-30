local Gymbag = Class{__includes=Memory}

function Gymbag:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Abandoned Archive"
	self.desc = [[At this point, wouldn't that just be a fake memory?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconhoponabandonedarchive.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return Gymbag