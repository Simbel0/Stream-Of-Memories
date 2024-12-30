local AbberDemon = Class{__includes=Memory}

function AbberDemon:init(path, speed)
	Memory.init(self, path, speed)

	self.name = "Abber Demon"
	self.desc = [[When Evil Neuro's TTS program goes a bit haywire, Evil
starts making strange demonic-like sounds, from incoherent yells to a
sudden radio filter or even getting a male voice. ASMR to some people's
ears!
According to Evil, that's just a demon that possess her. Oh well, guess
that explains it!]]

	self.gameTexture = love.graphics.newImage("assets/sprites/memories/iconabberdemon.png")

	self.streamTexture = nil
	self.clipLink = ""

	self.isReal = true
end

return AbberDemon