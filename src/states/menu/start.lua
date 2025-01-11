local menu = {}

function menu:init()
	print("Init Menu State")

	self.power_button = love.graphics.newImage("assets/sprites/ui/menu_start.png")
	self.power_button_on = love.graphics.newImage("assets/sprites/ui/menu_start_select.png")
	self.power_button_on_b = love.graphics.newImage("assets/sprites/ui/menu_start_select_blue.png")

	self.screen_light = love.graphics.newImage("assets/sprites/ui/screen_light.png")

	self.jam_logo = love.graphics.newImage("assets/sprites/jam_logo.png")
end

-- Since we'll never come back to this state until the game is restarted, might as well release everything now
function menu:leave()
	print("Leave Menu State")
	print(self.splash_canvas)

	self.power_button:release()
	self.power_button_on:release()
	self.power_button_on_b:release()
	self.screen_light:release()
	self.jam_logo:release()
	self.splash_canvas:release()
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

	self.splash_canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setCanvas(self.splash_canvas)

	local w, h = self.jam_logo:getDimensions()
	local x, y = (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2
	love.graphics.draw(self.jam_logo, x, y)

	love.graphics.setFont(main_font)
	love.graphics.setColor(255/255, 105/255, 224/255, 1)
	love.graphics.printf("Game made for", 0, y, SCREEN_WIDTH, "center")

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setCanvas()

	self.splash_scale = 0.7
	self.splash_alpha = 0
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

			if self.text_fade <= 0 then
				self.state = "SPLASHSCREEN"
				self.timer = 0
			end
		end

		self.blue_power_info = self.blue_power_info + 2*DT
	elseif self.state == "SPLASHSCREEN" then
		self.timer = self.timer + 10*DT

		if self.timer < 20 then
			self.splash_alpha = Utils.clamp(self.splash_alpha + 1.5*DT, 0, 1)
		elseif self.timer > 30 then
			self.splash_alpha = self.splash_alpha - 1.5*DT

			if self.splash_alpha <= 0 then
				GameStateManager:changeState("menu/mainmenu")
			end
		end

		self.splash_scale = self.splash_scale + 0.03*DT
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
		love.graphics.setColor(1,1,1,self.power_alpha)

		love.graphics.draw(self:mouseHoveredPower() and self.power_button_on or self.power_button, (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2)
	elseif self.state == "BOOTUP" then
		love.graphics.setColor(106/255, 51/255, 231/255, Utils.clamp((self.timer-50)/100, 0, 0.6))
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

		love.graphics.setColor(255/255, 105/255, 224/255, self.text_fade)

		local loading_text = "Loading..."
		local w = main_font:getWidth(loading_text)
		love.graphics.print(loading_text, (SCREEN_WIDTH/2)-(w/2), (SCREEN_HEIGHT/2)-42)

		local rX, rY = (SCREEN_WIDTH/2), (SCREEN_HEIGHT/2)
		local rW, rH = 400, 20

		local fill_value = math.min(self.timer, 100)

		local w_max = rW-6
		local w_value = (w_max*fill_value)/100

		love.graphics.rectangle("fill", (rX-rW/2)+3, rY+3, w_value, rH-6)

		if w_value < w_max then

			local color1_r, color1_g, color1_b = 0, 0, 0
			local color2_r, color2_g, color2_b = 106/255, 51/255, 231/255

			local finalColor_r = Utils.preciseLerp(color1_r, color2_r, Utils.clamp((self.timer-50)/100, 0, 0.6))
			local finalColor_g = Utils.preciseLerp(color1_g, color2_g, Utils.clamp((self.timer-50)/100, 0, 0.6))
			local finalColor_b = Utils.preciseLerp(color1_b, color2_b, Utils.clamp((self.timer-50)/100, 0, 0.6))

			love.graphics.setColor(finalColor_r, finalColor_g, finalColor_b, 1)

			love.graphics.push()
			love.graphics.translate(((rX-rW/2)+3)+w_value-15, rY+3)
			love.graphics.rotate(math.rad(-45))
			love.graphics.rectangle("fill", 0, 0, 15, rH+10)
			love.graphics.pop()
		end

		love.graphics.setColor(255/255, 105/255, 224/255, self.text_fade)
		love.graphics.rectangle("line", rX-rW/2, rY, rW, rH)

		love.graphics.setColor(1,1,1,1-(self.blue_power_info-1))
		local w, h = self.power_button_on_b:getDimensions()
		w = w*self.blue_power_info
		h = h*self.blue_power_info

		love.graphics.draw(self.power_button_on_b, (SCREEN_WIDTH/2)-w/2, (SCREEN_HEIGHT/2)-h/2, 0, self.blue_power_info)
	elseif self.state == "SPLASHSCREEN" then
		love.graphics.setColor(106/255, 51/255, 231/255, 0.6)
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

		love.graphics.setColor(1,1,1,self.splash_alpha)

		love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
        love.graphics.scale(self.splash_scale)
		love.graphics.draw(self.splash_canvas, -SCREEN_WIDTH/2, -SCREEN_HEIGHT/2)

		love.graphics.reset()
		love.graphics.scale(1)
	end

	love.graphics.setColor(1,1,1,0.3)
	love.graphics.draw(self.screen_light, 0, 0)

end

return menu