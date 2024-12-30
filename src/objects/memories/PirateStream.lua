local PirateStream = Class{__includes=Memory}

function PirateStream:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Pirate Stream"
	self.desc = [[Ahoy! One of the twins' first themed stream.
A funny concept overall made funnier by them trying to talk like true pirates.
That's also when we discovered Evil was possessed by a demon! Is it also
part of the pirate spirit???
Yarr!]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconpiratestream.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return PirateStream