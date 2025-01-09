local menu = {}

function menu:init()
	print("Init Menu State")

	self.power_button = love.graphics.newImage("assets/sprites/ui/menu_start.png")
	self.power_button_on = love.graphics.newImage("assets/sprites/ui/menu_start_select.png")
	self.power_button_on_b = love.graphics.newImage("assets/sprites/ui/menu_start_select_blue.png")

	self.screen_light = love.graphics.newImage("assets/sprites/ui/screen_light.png")
end

function menu:enter()
	print("Entered Menu State")

	self.state = "POWEROFF"

	self.power_alpha = 0

	self.boot_up = false

	self.flick_alpha = love.math.random(400, 1000)/1000
	self.timer = 0

	self.blue_power_info = 1
	self.text_fade = 0
end

function menu:mouseHoveredPower()
	local w, h = self.power_button:getDimensions()

	local x, y = (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2

	local mX, mY = love.mouse.getPosition()

	return mX > x and
		   mX < x+(w) and
		   mY > y and
		   mY < y+(h)
end

function menu:update()
	if self.state == "POWEROFF" then
		self.timer = self.timer + DT

		if not self:mouseHoveredPower() then
			if math.floor(self.timer)%2 == 0 then
				self.flick_alpha = love.math.random(400, 1000)/1000
			end
		else
			self.flick_alpha = 1
			self.timer = 1.9
		end

		if self.power_alpha > self.flick_alpha then
			self.power_alpha = self.power_alpha - DT
		elseif self.power_alpha < self.flick_alpha then
			self.power_alpha = self.power_alpha + DT
		end

		--self.hover_power_button = mouseHoveredPower()
	elseif self.state == "BOOTUP" then
		self.timer = self.timer + 20*DT

		if self.timer < 100 then
			self.text_fade = math.min(self.text_fade + 3*DT, 1)
		else
			self.text_fade = self.text_fade - 1*DT
		end

		self.blue_power_info = self.blue_power_info + 2*DT
	end
end

function menu:mousepressed( x, y, button, istouch, presses )
	if self.state == "POWEROFF" and button == 1 and self:mouseHoveredPower() then
		self.state = "BOOTUP"
		self.timer = 0
		Musics["LIFEInst"]:play()
	end
end

function menu:keypressed(key)
	if key == "g" then
		GameStateManager:changeState("game")
	end
end

function menu:draw()	
	if self.state == "POWEROFF" then
		local w, h = self.power_button:getDimensions()
		print(self.power_alpha, self.flick_alpha)
		love.graphics.setColor(1,1,1,self.power_alpha)

		love.graphics.draw(self:mouseHoveredPower() and self.power_button_on or self.power_button, (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2)
	elseif self.state == "BOOTUP" then
		love.graphics.setColor(106/255, 51/255, 231/255, math.min((self.timer-50)/100, 0.6))
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)


		love.graphics.setColor(1,1,1,1-(self.blue_power_info-1))
		local w, h = self.power_button_on_b:getDimensions()
		w = w*self.blue_power_info
		h = h*self.blue_power_info

		love.graphics.draw(self.power_button_on_b, (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2, 0, self.blue_power_info)


		love.graphics.setColor(255/255, 105/255, 224/255, self.text_fade)

		local loading_text = "Loading..."
		local w = main_font:getWidth(loading_text)
		love.graphics.print(loading_text, (SCREEN_WIDTH/2)-(w/2), (SCREEN_HEIGHT/2)-42)

		local rX, rY = (SCREEN_WIDTH/2), (SCREEN_HEIGHT/2)
		local rW, rH = 400, 20

		love.graphics.rectangle("line", rX-rW/2, rY, rW, rH)

		local fill_value = math.min(self.timer, 100)

		local w_max = rW-6
		local w_value = (w_max*fill_value)/100

		love.graphics.rectangle("fill", (rX-rW/2)+3, rY+3, w_value, rH-6)
	end

	love.graphics.setColor(1,1,1,0.3)
	love.graphics.draw(self.screen_light, 0, 0)

end

return menu