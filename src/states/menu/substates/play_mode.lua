local menu = Class{__includes=SubState}

function menu:init()
	SubState.init(self)
	print("Play Mode State Started")

	self.info_text = ""

	self.button_handler = ButtonHandler(self)
	self.button_handler:addButton("Normal Mode", 50, 100, 250, 250, {
		delay = 0,
		color = {0.7, 0.3, 0.3},
		onHover = function(button)
			self.info_text = "The game as it was presented during the Game Jam.\nIt's real time based, which means it might be difficult for Neuro to play this mode.\n\nAs such, it can also be called the \"Human mode\"."
		end,
		onUnHover = function(button)
			self.info_text = ""
		end,
	})
	self.button_handler:addButton("Neuro Mode", SCREEN_WIDTH-50-250, 100, 250, 250, {
		delay = 10,
		color = {1, 0.5, 1},
		onHover = function(button)
			self.info_text = "A turn-based version of the game. Made specifically for Neuro to play. The game will send information to Neuro during gameplay if this mode is chosen.\n\nEasier for humans to play I guess."
		end,
		onUnHover = function(button)
			self.info_text = ""
		end,
		onPostFade = function(button, handler)
			local SSMachine = handler:getSubStateMachine()
		end,
	})
	self.button_handler:addButton("Back", SCREEN_WIDTH/2-100, 30, 200, 70, {
		delay = 20,
		color = {0.5, 0.5, 0.5},
		onPostFade = function(button, handler)
			local SSMachine = handler:getSubStateMachine()
			if not SSMachine then
				error("Couldn't find the SubState Machine")
			end
			SSMachine:changeState("MAIN")
			--GameStateManager:changeState("game")
		end,
	})
end

function menu:update()
	self.button_handler:update()
end

function menu:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.info_text, 0, SCREEN_HEIGHT-32*4, SCREEN_WIDTH, "center")

	self.button_handler:draw()
end

return menu