local menu = Class{__includes=SubState}

function menu:init()
	SubState.init(self)
	print("Main Menu State Started")

	self.logo = love.graphics.newImage("assets/sprites/logo.png")
	self.logo_alpha = 0

	self.timer = 0

	self.transition_state = "IN"
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
end

function menu:draw()
	love.graphics.push()

	local w, h = self.logo:getDimensions()

	love.graphics.translate(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	love.graphics.scale(0.35)
	love.graphics.rotate(math.rad(math.sin(self.timer*5)*2))
	love.graphics.setColor(1, 1, 1, self.logo_alpha)
	love.graphics.draw(self.logo, -(w/2), -(h/2), 0)
	love.graphics.pop()
end

return menu