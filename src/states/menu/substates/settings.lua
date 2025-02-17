local menu = Class{__includes=SubState}

function menu:init()
	SubState.init(self)
	print("Settings State Started")

	self.button_handler = ButtonHandler(self)
	self.button_handler:addButton("Back", SCREEN_WIDTH/2-100, SCREEN_HEIGHT-70-30, 200, 70, {
		delay = 0,
		color = {0.5, 0.5, 0.5},
	})

	self.settings_manager = SettingsManager(self)
	self.settings_manager:addSetting("Volume", "volume", 40, {"_number"}, {
		onNumberChange = function(value, mult)
			return Utils.clamp(value+10*mult, 0, 100)
		end,
		getValueString = function(value)
			return value.."%"
		end
	})
	self.settings_manager:addSetting("Background Menu", "menu_bg", "Basic", {--[["Evil",]] "Neuro", "Basic", "LIFE"})
	self.settings_manager:addSetting("Window Scale", "win_scale", 1, {"_number"}, {
		onNumberChange = function(value, mult)
			if value == 1 and mult == -1 then
				return value
			end

			local _, _, flags = love.window.getMode()

			local new_value = value+1*mult
			local pc_width, pc_height = love.window.getDesktopDimensions(flags.display or 1)
			if SCREEN_WIDTH*new_value > pc_width or SCREEN_HEIGHT*new_value > pc_height then
				return value
			end

			return new_value
		end,
		getValueString = function(value)
			return value.."x"
		end
	})
	self.settings_manager:addSetting("Fullscreen", "fullscreen", false, {"_bool"})
	self.settings_manager:addSetting("Skip Boot", "introSkip", false, {"_bool"})
end

function menu:enter()
	print("Settings State Entered")
end

function menu:update()
	self.button_handler:update()
	self.settings_manager:update()
end

function menu:keypressed(...)
	self.settings_manager:keypressed(...)
end

function menu:draw()
	self.button_handler:draw()
	self.settings_manager:draw()
end

return menu