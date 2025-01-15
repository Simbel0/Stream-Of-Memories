local menu = Class{__includes=SubState}

function menu:init()
	SubState.init(self)
	print("Main Menu State Started")

	self.logo = love.graphics.newImage("assets/sprites/logo.png")
	self.logo_alpha = 0

	self.timer = 0

	self.transition_state = "IN"

	self.button_handler = ButtonHandler(self)
	self.button_handler:addButton("Memories", 50, 300, 200, 70, {
		delay = 0,
		color = {1, 0.3, 1}
	})
	self.button_handler:addButton("Play", 220, 430, 200, 70, {
		delay = 10,
		color = {1, 0.3, 0.3}
	})
	self.button_handler:addButton("Settings", 550, 430, 200, 70, {
		delay = 20,
		color = {0.5, 0.5, 0.5}
	})
	self.button_handler:addButton("Credits", SCREEN_WIDTH-(220+50), 300, 200, 70, {
		delay = 30,
		color = {0.5, 0.5, 1}
	})
end

function menu:enter()
	print("Main Menu State Entered")
end

function menu:update()
	self.timer = self.timer + DT

	if self.transition_state == "IN" then
		if self.logo_alpha < 1 then
			self.logo_alpha = self.logo_alpha + 5*DT
		end
	else
		if self.logo_alpha > 0 then
			self.logo_alpha = self.logo_alpha - 5*DT
		end
	end

	self.button_handler:update()
end

function menu:draw()
	love.graphics.push()

	local w, h = self.logo:getDimensions()

	love.graphics.translate(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	love.graphics.scale(0.35)
	love.graphics.rotate(math.rad(math.sin(self.timer*5)*2))
	love.graphics.setColor(1, 1, 1, self.logo_alpha)
	love.graphics.draw(self.logo, -(w/2), -(h/2)-100)
	love.graphics.pop()

	self.button_handler:draw()
end

return menu