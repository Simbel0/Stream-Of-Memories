local Debt = Class{__includes=Memory}

function Debt:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Debt"
	self.desc = [[Nothing happened on December 23, 2023, right?
Nothing like Vedal giving away a code for one Evil Neuro plushie that turned out to have infinite uses
and putting himself in crippling debt for a few hours.
Would he have executed his plan to get out of debt?]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/icondebt987.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return Debt