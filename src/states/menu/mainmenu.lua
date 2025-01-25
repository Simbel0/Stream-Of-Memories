local menu = {}

local MainMenu = require("src.states.menu.substates.menu_main")
local PlayMode = require("src.states.menu.substates.play_mode")

function menu:init()
	print("Init Menu State")

	self.screen_light = love.graphics.newImage("assets/sprites/ui/screen_light.png")

	self.bg_fade = love.graphics.newImage("assets/sprites/ui/fade.png")
	self.bg_star = love.graphics.newImage("assets/sprites/ui/star.png")
	self.bg_alpha = 0

	self.timer = 0
	self.stars = {}

	self.transition_state = "NONE"
	self.transition_callback = nil
	self.transition_options = {}
	self.transition_fader_alpha = 0

	self.verFont = love.graphics.newFont("assets/fonts/coffee.ttf", 16)

	self.stateMachine = SubStateMachine(self)
	self.stateMachine:addState("MAIN", MainMenu)
	self.stateMachine:addState("PLAYMODE", PlayMode)
	self.stateMachine:changeState("MAIN")
end

function menu:enter()
	print("Entered Menu State")
end

function menu:startTransition(mode, callback, alpha, options)
	if mode == nil then
		self.transition_state = "NONE"
		return
	end

	options = options or {}
	self.transition_options = {
		update = options["update"] or nil,
		preDraw = options["preDraw"] or nil,
		postDraw = options["postDraw"] or nil,
	}

	self.transition_callback = callback

	self.transition_state = mode
	if alpha then
		self.transition_fader_alpha = alpha
	end
end

function menu:stopTransition(reset_alpha)
	if reset_alpha == true or reset_alpha == nil then
		self.transition_fader_alpha = self.transition_state == "IN" and 0 or 1
	end

	self.transition_state = "NONE"
	self.transition_options = {}
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
	self.timer = self.timer + DTMULT
	if self.bg_alpha < 0.7 then
		self.bg_alpha = self.bg_alpha + DT*0.5
	end

	if math.floor(self.timer)%10 == 0 then
		self:addBGStar(love.math.random(0, SCREEN_WIDTH), love.math.random(SCREEN_HEIGHT+10, SCREEN_HEIGHT+50), love.math.random(1, 3))
	end

	for i=#self.stars, 1, -1 do
		local star_data = self.stars[i]
		star_data.timer = star_data.timer - DTMULT

		star_data.x = star_data.x + star_data.speed * star_data.accel * DTMULT
		star_data.y = star_data.y - star_data.speed * DTMULT
		star_data.accel = star_data.accel + (love.math.random()*Utils.RandomNegation()) * (DTMULT*0.1)

		star_data.rotation = star_data.rotation + star_data.speed * DTMULT

		if star_data.timer < 0 then
			star_data.alpha = star_data.alpha - DT*2

			if star_data.alpha <= 0 then
				table.remove(self.stars, i)
			end
		end
	end
	--[[if self.state == "MAIN" then
		if self.logo_alpha < 1 then
			self.logo_alpha = self.logo_alpha + 10*DT
		end
	end]]

	if self.transition_state == "IN" then
		self.transition_fader_alpha = self.transition_fader_alpha - 5*DT

		if self.transition_options["update"] then
			self.transition_options["update"](self)
		end

		if self.transition_fader_alpha <= 0 then
			self:stopTransition()
			if self.transition_callback then
				self.transition_callback(self)
				self.transition_callback = nil
			end
		end
	elseif self.transition_state == "OUT" then
		self.transition_fader_alpha = self.transition_fader_alpha + 1*DT

		if self.transition_options["update"] then
			self.transition_options["update"](self)
		end

		if self.transition_fader_alpha >= 1 then
			print("B", self.transition_callback)
			self:stopTransition()
			if self.transition_callback then
				self.transition_callback(self)
				self.transition_callback = nil
			end
		end
	end
end

function menu:mousepressed( x, y, button, istouch, presses )

end

function menu:keypressed(key)
	print(key)
end

function menu:addBGStar(x, y, speed)
	table.insert(self.stars, {
		x=x,
		y=y,
		speed=speed,
		accel=love.math.random()*Utils.RandomNegation(),
		alpha=1,
		rotation=love.math.random(0, 380),
		timer=love.math.random(60, 240)
	})
end

function menu:draw()
	love.graphics.setColor(106/255, 51/255, 231/255, 0.6)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	for i,star_data in ipairs(self.stars) do
		local star = self.bg_star
		local self = star_data
		love.graphics.setColor(1, 1, 1, self.alpha)
		love.graphics.draw(star, self.x, self.y, math.rad(self.rotation))
	end

	love.graphics.setColor(1, 1, 1, self.bg_alpha)
	love.graphics.draw(self.bg_fade, 0, 0)
end

function menu:postDraw()
	love.graphics.setColor(1, 0.2, 1, 0.7)
	love.graphics.setFont(self.verFont)
	local w = main_font:getWidth("v"..tostring(VERSION))
	love.graphics.print("v"..tostring(VERSION), 0, 0)

	love.graphics.setColor(1,1,1,0.3)
	love.graphics.draw(self.screen_light, 0, 0)

	if self.transition_options["preDraw"] then
		self.transition_options["preDraw"](self)
	end
	love.graphics.setColor(0, 0, 0, self.transition_fader_alpha)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	if self.transition_options["postDraw"] then
		self.transition_options["postDraw"](self)
	end
end

return menu