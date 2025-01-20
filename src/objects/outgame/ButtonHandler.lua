local ButtonHandler = Class()

BUTTON_CORNER_TEXTURE = love.graphics.newImage("assets/sprites/ui/button_corner.png")

function ButtonHandler:init(state)
	self.state = state

	self.timer = 0

	self.alpha = 1

	self.buttons = {}
	self.clickedButton = nil

	self.delay = 30

	--self.id = Utils.generateBS()
	--Signal.register(self.id.."-shoot")
end

function ButtonHandler:getSubStateMachine()
	return self.state and self.state.machine or nil
end

function ButtonHandler:update()
	self.timer = self.timer + DTMULT

	if self.clickedButton then
		self.delay = self.delay - DTMULT

		if self.delay <= 0 then
			self.clickedButton.alpha = self.clickedButton.alpha - 4*DT

			if self.clickedButton.alpha <= 0 then
				self.clickedButton:onPostFade(self)
			end
		end
	end

	for i,button in ipairs(self.buttons) do
		if not self.clickedButton then
			button:update()
		end
		if self.clickedButton and self.clickedButton ~= button then
			button.alpha = button.alpha - 4*DT
		end
	end
end

function ButtonHandler:draw()
	for i,button in ipairs(self.buttons) do
		button:draw()
	end
end

function ButtonHandler:addButton(title, x, y, w, h, options)
	table.insert(self.buttons, Button(self, title, x, y, w, h, options))
end

function ButtonHandler:handleButtonClick(button)
	for i,button in ipairs(self.buttons) do
		if button.delay > 0 then
			return
		end
	end
	self.clickedButton = button
	button:onClicked(self)
end

return ButtonHandler