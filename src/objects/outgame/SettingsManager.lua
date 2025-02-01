local SettingsManager = Class()

function SettingsManager:init(state)
	self.menu = state

	self.settings = {}

	self.state = "SELECT" -- SELECT, CHANGE

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

function SettingsManager:draw()
	for i,data in ipairs(self.settings) do
		love.graphics.print(data.name, 50, 100+(i-1)*45)
	end
end

return SettingsManager