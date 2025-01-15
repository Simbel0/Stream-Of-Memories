local Button = Class()

local __EMPTY = function() end

local function mouseHovered(obj)
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

	self.color = options["color"] or {1, 1, 1}

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

	if love.mouse.isDown(1) and mouseHovered(self) and self:canClick() then
		self.handler:handleButtonClick(self)
	end
end

function Button:canClick()
	return self.alpha >= self.endAlpha and self.onClicked
end

function Button:getColor()
	local r, g, b = unpack(self.color)
	return r, g, b, self.alpha
end

function Button:draw()
	love.graphics.setColor(self:getColor())
	love.graphics.setLineWidth(5)

	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	local corner_width, corner_height = BUTTON_CORNER_TEXTURE:getDimensions()

	love.graphics.setColor(1, 0.8, 1, self.alpha)

	-- Dear fucking god I hate this

	-- top-left
	love.graphics.draw(BUTTON_CORNER_TEXTURE, self.x-corner_width/2, self.y-corner_height/2)

	local x, y = self.x+corner_width/2, (self.y-corner_height/2)+4.5
	love.graphics.line(x, y, x+(self.width-corner_width), y)

	-- top-right
	love.graphics.draw(BUTTON_CORNER_TEXTURE, x+self.width, self.y-corner_height/2, math.rad(90))

	local x2, y2 = x+(self.width-corner_width/2)+1.5, self.y+corner_height-5
	love.graphics.line(x2, y2, x2, y2+(self.height-corner_height))

	-- bottom-right
	love.graphics.draw(BUTTON_CORNER_TEXTURE, (x2+corner_width/2)-3, y2+(self.height), math.rad(90*2))

	local x3, y3 = self.x+self.width-corner_width/2, self.y+self.height+2
	love.graphics.line(x3, y3, self.x+corner_width/2, y3)

	-- bottom-left
	love.graphics.draw(BUTTON_CORNER_TEXTURE, self.x-corner_width/2, (self.y+self.height)+corner_height/2, math.rad(90*3))

	love.graphics.line((self.x-corner_width/2)+3.5, (self.y+self.height)-corner_height/2, (self.x-corner_width/2)+3.5, self.y+corner_height/2)
end

return Button