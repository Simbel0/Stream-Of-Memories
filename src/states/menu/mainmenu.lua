local menu = {}

local MainMenu = require("src.states.menu.substates.menu_main")

function menu:init()
	print("Init Menu State")

	self.screen_light = love.graphics.newImage("assets/sprites/ui/screen_light.png")

	self.verFont = love.graphics.newFont("assets/fonts/coffee.ttf", 16)

	self.stateMachine = SubStateMachine(self)
	self.stateMachine:addState("MAIN", MainMenu)
	self.stateMachine:changeState("MAIN")
end

function menu:enter()
	print("Entered Menu State")
end

local function mouseHovered(obj)
	local w, h
	if obj.getDimensions then
		w, h = obj:getDimensions()
	end

	local x, y = (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2

	local mX, mY = love.mouse.getPosition()

	return mX > x and
		   mX < x+(w) and
		   mY > y and
		   mY < y+(h)
end

function menu:update()
	--[[if self.state == "MAIN" then
		if self.logo_alpha < 1 then
			self.logo_alpha = self.logo_alpha + 10*DT
		end
	end]]
end

function menu:mousepressed( x, y, button, istouch, presses )

end

function menu:keypressed(key)
	print(key)
end

function menu:draw()
	love.graphics.setColor(106/255, 51/255, 231/255, 0.6)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
end

function menu:postDraw()
	love.graphics.setColor(1, 0.2, 1, 0.7)
	love.graphics.setFont(self.verFont)
	local w = main_font:getWidth("v"..tostring(VERSION))
	love.graphics.print("v"..tostring(VERSION), 0, 0)

	love.graphics.setColor(1,1,1,0.3)
	love.graphics.draw(self.screen_light, 0, 0)
end

return menu