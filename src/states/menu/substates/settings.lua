local menu = Class{__includes=SubState}

function menu:init()
	SubState.init(self)
	print("Settings State Started")

	self.button_handler = ButtonHandler(self)
	self.button_handler:addButton("Back", SCREEN_WIDTH/2-100, SCREEN_HEIGHT-70-30, 200, 70, {
		delay = 20,
		color = {0.5, 0.5, 0.5},
	})

	self.settings_manager = SettingsManager(self)
	self.settings_manager:addSetting("Volume", "volume", 100, {"_slider"}, {
		onSliderChange = function(value, mult)
			return value+10*mult
		end
	})
	self.settings_manager:addSetting("Background", "menu_bg", "Basic", {"Evil", "Neuro", "Basic", "LIFE"})
	self.settings_manager:addSetting("Window Scale", "win_scale", 1, {"_number"}, {
		onNumberChange = function(value, dir)
			if value == 1 and dir == "left" then
				return value
			end

			local mult = dir == "left" and -1 or 1
			local new_value = value*(2*mult)
		end
	})
end

function menu:enter()
	print("Settings State Entered")
end

function menu:update()

	--self.settings_manager:update()
end

function menu:draw()
	self.settings_manager:draw()
end

return menu