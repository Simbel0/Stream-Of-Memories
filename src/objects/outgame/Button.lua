local Button = Class()

local __EMPTY = function() end

local function mouseHovered(obj)
	if obj.selected then return true end

	local w, h
	if obj.getDimensions then
		w, h = obj:getDimensions()
	elseif obj.width and obj.height then
		w, h = obj.width, obj.height
	end

	local x, y = obj.x, obj.y

	local mX, mY = love.mouse.getPosition()

	return mX > x and
		   mX < x+(w) and
		   mY > y and
		   mY < y+(h)
end

function Button:init(handler, title, x, y, w, h, options)
	local options = options or {}

	self.handler = handler

	self.x = x
	self.y = y

	self.width = w
	self.height = h

	self.title = title or ""

	self.isHovering = false
	self.selected = false

	self.color = options["color"] or {1, 1, 1}
	self.hovered_color = options["hovered_color"] or Utils.copy(self.color) or {0.5, 0.5, 0.5}
	for i=1,3 do
		self.hovered_color[i] = Utils.clamp(self.hovered_color[i] + 0.2, 0, 1)
	end

	self.delay = options["delay"] or 0
	self.alpha = options["startAlpha"] or (self.delay <= 0 and 1 or 0)
	self.endAlpha = options["endAlpha"] or 1

	self.speed = (options["fadeSpeed"] or 5)/60

	self.onHover = options["onHover"] or __EMPTY
	self.onClicked = options["onClicked"] or __EMPTY
	self.onPostFade = options["onPostFade"] or __EMPTY
end

function Button:update()
	if self.delay > 0 then
		self.delay = self.delay - DTMULT
	else
		if self.alpha < self.endAlpha then
			self.alpha = self.alpha + self.speed*DTMULT
		end
	end

	if mouseHovered(self) then
		if love.mouse.isDown(1) and self:canClick() then
			self.selected = true
			self.handler:handleButtonClick(self)
		end


	end
end

function Button:canClick()
	return self.alpha >= self.endAlpha and self.onClicked
end

function Button:getColor()
	local r, g, b = unpack(mouseHovered(self) and self.hovered_color or self.color)
	return r, g, b, self.alpha
end

function Button:getSecondColor()
	local r, g, b, a = self:getColor()
	local light_value = 0.2
	return r+light_value, g+light_value, b+light_value, a
end

function Button:getLineColor()
	local r, g, b = 1, 0.8, 1
	if mouseHovered(self) then
		g = 1
	end
	return r, g, b, self.alpha
end

function Button:draw()
	love.graphics.setColor(self:getColor())
	love.graphics.setLineWidth(5)

	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	love.graphics.setColor(self:getSecondColor())
	love.graphics.polygon("fill", 
		self.x, self.y+self.height,
		self.x+self.width, self.y+self.height,
		self.x+self.width-self.width/4, self.y,
		self.x+self.width/4, self.y
	)

	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.printf(self.title, self.x, self.y+(self.height/2)-16, self.width, "center")

	local corner_width, corner_height = BUTTON_CORNER_TEXTURE:getDimensions()

	love.graphics.setColor(self:getLineColor())

	-- Dear fucking god I hate this

	-- top-left
	love.graphics.draw(BUTTON_CORNER_TEXTURE, self.x-corner_width/2, self.y-corner_height/2)

	local x, y = self.x+corner_width/2, (self.y-corner_height/2)+4.5
	love.graphics.line(x, y, x+(self.width-corner_width), y)

	-- top-right
	love.graphics.draw(BUTTON_CORNER_TEXTURE, x+self.width, (self.y-corner_height/2)+1, math.rad(90))

	local x2, y2 = x+(self.width-corner_width/2)+1.5, self.y+corner_height-5
	love.graphics.line(x2, y2, x2, y2+(self.height-corner_height))

	-- bottom-right
	love.graphics.draw(BUTTON_CORNER_TEXTURE, (x2+corner_width/2)-3, (y2+(self.height))-1, math.rad(90*2))

	local x3, y3 = self.x+self.width-corner_width/2, self.y+self.height+2
	love.graphics.line(x3, y3, self.x+corner_width/2, y3)

	-- bottom-left
	love.graphics.draw(BUTTON_CORNER_TEXTURE, (self.x-corner_width/2)-0.4, ((self.y+self.height)+corner_height/2)-1, math.rad(90*3))

	love.graphics.line((self.x-corner_width/2)+3.5, (self.y+self.height)-corner_height/2, (self.x-corner_width/2)+3.5, self.y+corner_height/2)
end

return Button