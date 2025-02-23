local menu = Class{__includes=SubState}

function menu:init()
	SubState.init(self)
	print("Collection State Started")

	self.button_handler = ButtonHandler(self)
	self.button_handler:addButton("Back", SCREEN_WIDTH/2-50, 10, 100, 70, {
		delay = 0,
		color = {0.5, 0.5, 0.5},
		onPostFade = function(button, handler)
			local SSMachine = handler:getSubStateMachine()
			if not SSMachine then
				error("Couldn't find the SubState Machine")
			end
			SSMachine:changeState("MAIN")
		end,
	})

	self.goodMemories = {}
	self.badMemories = {}
	local path = TubePath({{0, 0}})
	for type,memories in pairs(MemoryFactory.allMemories) do
		for id,memory in pairs(memories) do
			local mem = MemoryFactory:createMemory(path, memory)
			mem.pathDone = true

			mem.x = 0
			mem.y = 0
			mem.setPosition = function(self, x, y)
				self.x = x
				self.y = y
			end
			mem.getPosition = function(self)
				return self.x, self.y
			end
			mem.getPositionCenteredToTexture = function(self)
				return self:getPosition()
			end

			table.insert(type == "good" and self.goodMemories or self.badMemories, mem)
		end
	end

	self.small_font = love.graphics.newFont("assets/fonts/coffee.ttf", 16)
end

function menu:enter()
	print("Collection State Entered")
end

function menu:update()
	self.button_handler:update()
	print(not self.selected_memory and "Nothing" or self.selected_memory.name)

	local mX, mY = love.mouse.getPosition()

	self.selected_memory = nil
	for i,v in ipairs(self.goodMemories) do
		if v:mouseHovered(mX, mY) then
			self.selected_memory = v
			return
		end
	end
	for i,v in ipairs(self.badMemories) do
		if v:mouseHovered(mX, mY) then
			self.selected_memory = v
			return
		end
	end
end

function menu:keypressed(...)
end

function menu:draw()
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setColor(1, 1, 1, 0.3)
	love.graphics.rectangle("fill", 16, 50, 432, SCREEN_HEIGHT)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Good Memories", 24, 55)

	local x, y = 26, 100
	for i,memory in ipairs(self.goodMemories) do
		memory.x = x
		memory.y = y
		memory:draw()

		x = x + 100
		if x >= 432-16 then
			x = 26
			y = y + 120
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Bad Memories", 24, y+120)

	x = 26
	y = y+120+45
	for i,memory in ipairs(self.badMemories) do
		memory.x = x
		memory.y = y
		memory:draw()

		x = x + 100
		if x >= 432-16 then
			x = 26
			y = y + 120
		end
	end

	if self.selected_memory then
		love.graphics.setColor(1, 1, 1, 1)

		love.graphics.draw(self.selected_memory:getGameTexture(), 602, 50)

		love.graphics.print(self.selected_memory:getName(), 480, 250)

		love.graphics.setFont(self.small_font)
		love.graphics.printf(self.selected_memory:getDescription():gsub("\n", " "):gsub("%s+", " "):gsub("<br>", "\n"):gsub("^%s*(.-)%s*$", "%1"), 480, 290, SCREEN_WIDTH-500)
	end

	self.button_handler:draw()
end

return menu