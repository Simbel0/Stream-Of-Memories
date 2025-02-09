local SettingsManager = Class()

function SettingsManager:init(state)
	self.menu = state

	self.settings = {}

	self.state = "SELECT" -- SELECT, CHANGE

	self.selected = 1

	self.settings_x = 50

	self.normal_color = {0.7, 0.7, 0.7}
	self.selected_color = {1, 1, 1}
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

function SettingsManager:setSettingsX()
	local largest_width = 0
	for i,data in ipairs(self.settings) do
		local width = main_font:getWidth(data.name)
		if width > largest_width then
			largest_width = width
		end
	end

	self.settings_x = 50 + largest_width + 10
end

function SettingsManager:addSetting(name, key, default, options, functions)
	if options == nil or #options == 0 then
		error("SettingsManager: no options provided.")
	end
	local data = {}
	if options[1] == "_slider" then
		data.mode = options[1]:sub(2)
	elseif options[1] == "_number" then
		data.mode = options[1]:sub(2)
	elseif options[1] == "_bool" then
		data.mode = options[1]:sub(2)
	elseif #options > 1 then
		data.mode = "options"
		data.options = options
	else
		error("SettingsManager: unknown mode provided!", 1)
	end
	data["name"] = name
	data["functions"] = functions
	data["key"] = key
	data["value"] = GlobalData.Settings[key] or default
	--checkvalue(data.options, data["key"])

	table.insert(self.settings, data)
	self:setSettingsX()
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
			if self.settings[self.selected].mode == "bool" then
				local invertValue = not self.settings[self.selected].value
				self.settings[self.selected].value = invertValue
				GlobalData.Settings[self.settings[self.selected].key] = invertValue
				return
			end

			self.state = "CHANGE"
		end
	elseif self.state == "CHANGE" then
		if key == "left" or key == "right" then
			local newvalue
			if self.settings[self.selected].mode == "number" then
				newvalue = self.settings[self.selected].functions.onNumberChange(self.settings[self.selected].value, key == "left" and -1 or 1)
			elseif self.settings[self.selected].mode == "options" then
				local getNearValue = key == "left" and Utils.getPreviousValueInArray or Utils.getNextValueInArray
				newvalue = getNearValue(self.settings[self.selected].options, self.settings[self.selected].value)
			end
			self.settings[self.selected].value = newvalue
			GlobalData.Settings[self.settings[self.selected].key] = newvalue
		elseif key == "return" then
			self.state = "SELECT"
		end
	end
end

function SettingsManager:draw()
	for i,data in ipairs(self.settings) do
		love.graphics.setColor(unpack(self.selected == i and self.selected_color or self.normal_color))
		if self.state == "CHANGE" and self.selected == i then
			love.graphics.setColor(1, 0.5, 1)
		end
		local y = 100+(i-1)*45
		love.graphics.print(data.name, 50, y)

		if data.mode == "number" then
			love.graphics.print(data.functions.getValueString(data.value), self.settings_x, y)
		elseif data.mode == "options" then
			love.graphics.print(data.value, self.settings_x, y)
		elseif data.mode == "bool" then
			love.graphics.print(data.value and "Yes" or "No~", self.settings_x, y)
		end

		if self.state == "CHANGE" and self.selected == i and data.mode == "options" then
			local corners_padding = 10
			local between_padding = 20

			local max_width = corners_padding * 2

			for i,option in ipairs(data.options) do
				max_width = max_width + main_font:getWidth(option) + between_padding
			end
			max_width = max_width - between_padding

			local x = self.settings_x-max_width/2
			love.graphics.setColor(1, 0.3, 1)
			love.graphics.rectangle("line", x, y, max_width, main_font:getHeight())
			love.graphics.setColor(1, 0.9, 1)
			love.graphics.rectangle("fill", x, y, max_width, main_font:getHeight())

			local option_x = x+corners_padding
			for i,option in ipairs(data.options) do
				if option == data["value"] then
					love.graphics.setColor(1, 0.7, 1)
				else
					love.graphics.setColor(1, 0.3, 1)
				end
				love.graphics.print(option, option_x, y)
				option_x = option_x + main_font:getWidth(option) + between_padding
			end
		end
	end
end

return SettingsManager