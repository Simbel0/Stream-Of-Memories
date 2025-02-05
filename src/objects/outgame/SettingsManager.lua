local SettingsManager = Class()

function SettingsManager:init(state)
	self.menu = state

	self.settings = {}

	self.state = "SELECT" -- SELECT, CHANGE

	self.selected = 1

	self.normal_color = {0.7, 0.7, 0.7}
	self.selected_color = {1, 1, 1}

	if not GlobalData.Settings then GlobalData.Settings = {} end
end

--[[local function checkvalue(mode, value)
	local ok = true
	if mode == "options" and type(value) == "number" then
		ok = false
	elseif (mode == "number" or mode == "slider") and type(value) == "string" then
		ok = false
	elseif mode == "options" and type(value) == "string" then
		for
end]]

function SettingsManager:addSetting(name, value, default, options, functions)
	if options == nil or #options == 0 then
		error("SettingsManager: no options provided.")
	end
	local data = {}
	if options[1] == "_slider" then
		data.mode = options[1]:sub(2)
	elseif options[1] == "_number" then
		data.mode = options[1]:sub(2)
	elseif #options > 1 then
		data.mode = "options"
		data.options = options
	else
		error("SettingsManager: unknown mode provided!", 1)
	end
	data["name"] = name
	data["functions"] = functions
	data["key"] = value
	data["value"] = GlobalData.Settings[value] or default
	--checkvalue(data.options, data["value"])

	table.insert(self.settings, data)
end

function SettingsManager:update()
	if self.state == "CHANGE" then
	end
end

function SettingsManager:keypressed(key, scancode, is_repeat)
	if self.state == "SELECT" then
		if key == "down" then
			self.selected = Utils.clamp(self.selected + 1, 1, #self.settings)
		elseif key == "up" then
			self.selected = Utils.clamp(self.selected - 1, 1, #self.settings)
		elseif key == "return" then
			self.state = "CHANGE"
		end
	elseif self.state == "CHANGE" then
		if key == "left" or key == "right" then
			local newvalue = self.settings[self.selected].functions.onNumberChange(self.settings[self.selected].value, key == "left" and -1 or 1)
			self.settings[self.selected].value = newvalue
			GlobalData.Settings[self.settings[self.selected].key] = newvalue
		end
	end
end

function SettingsManager:draw()
	for i,data in ipairs(self.settings) do
		love.graphics.setColor(unpack(self.selected == i and self.selected_color or self.normal_color))
		if self.state == "CHANGE" and self.selected_color == i then
			love.graphics.setColor(0.7, 0.2, 0.6)
		end
		local y = 100+(i-1)*45
		love.graphics.print(data.name, 50, y)

		if data.mode == "number" then
			love.graphics.print(data.functions.getValueString(data.value), 250, y)
		elseif data.mode == "options" then
			love.graphics.print(data.value, 250, y)
		end
	end
end

return SettingsManager