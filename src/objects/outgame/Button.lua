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
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Button