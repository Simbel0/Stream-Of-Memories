local Music = {}

Music.sources = {}

local mode = "stream"
if love.system.getOS() == "Web" then
	mode = "static"
end

function Music:load(path, volume, pitch, key)
	local source
	if type(path) ~= "string" then
		source = path
	else
		source = love.audio.newSource("assets/music/"..path..".ogg", mode)
	end
	if GlobalData.Settings and GlobalData.Settings.volume then
		source:setVolume(volume*(GlobalData.Settings["volume"]/100))
	end
	source:setPitch(pitch)
	self.sources[key or path] = {
		source = source,
		baseVolume = volume
	}

	return self.sources[path]
end

function Music:getSourceData(id)
	return self.sources[id]
end

function Music:getSource(id)
	return self.sources[id].source
end

function Music:setVolume(id, volume)
	local source = self:getSource(id)

	if not volume then
		volume = self:getBaseVolume(id)
	else
		self:getSourceData(id).baseVolume = volume
	end

	source:setVolume(volume*(GlobalData.Settings["volume"]/100))
end

function Music:getVolume(id)
	return self:getSource(id):getVolume()
end

function Music:getBaseVolume(id)
	return self:getSourceData(id).baseVolume
end

function Music:setLooping(id, loop)
	return self:getSource(id):setLooping(loop)
end

function Music:release(id)
	if not id then
		for key,sourceData in pairs(self.sources) do
			sourceData.source:release()
		end
		self.sources = {}
	else
		self:getSource(id):release()
		self.sources[id] = nil
	end
end

setmetatable(Music, {
	__index = function(self, key)
		return self:getSource(key)
	end,
	__newindex = function(self, key, value)
		return self:load(value, 1, 1, key)
	end
})

return Music