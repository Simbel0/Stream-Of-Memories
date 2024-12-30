local OSU = Class{__includes=Memory}

function OSU:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "OSU!"
	self.desc = [[Even before her Vtuber debut in 2022, Neuro-sama's original purpose was to play OSU!.
While she has overgrown her original purpose and can play many other games now,
She became so good at OSU she was able to fight multiple professional players and hold her ground!
Maybe she'll play this game again one day!]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconosu.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return OSU