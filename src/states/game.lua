local game = {}

function game:init()
	print("Init Game State")
	self.stage = Object()

	self.background = love.graphics.newImage("assets/sprites/neuro_room/backgroundfinal.png")
	self.neuro = love.graphics.newImage("assets/sprites/neuro_room/neurofinal.png")

	self.tubes_lower_in = love.graphics.newImage("assets/sprites/neuro_room/tubesinside2.png")
	self.tubes_lower_out = love.graphics.newImage("assets/sprites/neuro_room/tubesoutside2.png")

	self.tubes_middle_in = love.graphics.newImage("assets/sprites/neuro_room/tubesinside1.png")
	self.tubes_middle_out = love.graphics.newImage("assets/sprites/neuro_room/tubesoutside1.png")

	self.tubes_high_in = love.graphics.newImage("assets/sprites/neuro_room/tubesinside3.png")
	self.tubes_high_out = love.graphics.newImage("assets/sprites/neuro_room/tubesoutside3.png")

	self.health_bar_1 = love.graphics.newImage("assets/sprites/ui/health_bar_1.png")
	self.health_bar_2 = love.graphics.newImage("assets/sprites/ui/health_bar_2.png")
	self.health_bar_health = love.graphics.newImage("assets/sprites/ui/health_bar_health.png")

	local w, h = self.health_bar_health:getDimensions()
	self.health_quad = love.graphics.newQuad(0, 0, w, h, w, h)

	local _, _, w, _ = self.health_quad:getViewport()
	self.health_bar_max_width = w
	self.health_bar_width = self.health_bar_max_width

	self.tubes = {}
	self.tubes_timer = {}

	Signal.register("game-healthChanged", function()
		self.health_bar_width = (self.neuro_life*self.health_bar_max_width)/self.neuro_max_life

		local x, y, w, h = self.health_quad:getViewport()

		self.health_quad:setViewport(x, y, self.health_bar_width, h)
	end)

	Signal.register("game-memoryInNeuro", function(memory)
		print("Signal test for "..memory:getName())

		local score = 20
		local ouch_mult = 1
		if not memory.isReal then
			score = math.floor(score*-1.5)
			ouch_mult = -1
		end

		self.score = self.score + score
		if self.score > self.best_score then
			self.best_score = self.score
		end

		self:changeLife(self.neuro_ouchie*ouch_mult)

		memory:remove()
	end)

	--self.stage:addChild(MemoryFactory:createMemory(self.tubes[1], "gymbag"))

	--[[Timer.after(2, function()
		self.stage:addChild(MemoryFactory:createMemory(self.tubes[1], "tower"))
	end)
	Timer.after(4, function()
		self.stage:addChild(MemoryFactory:createMemory(self.tubes[1], "tower"))
	end)]]
	--[[Timer.after(4, function()
		self:addTube({
			{600, 0},
			{550, 100},
			{500, 140},
			{440, 170},
			{310, 290}
		})
	end)]]
end

function game:enter()
	print("Entered Game State")

	self.stage = Object()

	self.score = 0
	self.best_score = 0

	self.game_timer = 0

	self.neuro_life = 100
	self.neuro_max_life = 100

	self.neuro_ouchie = 10
	self.ouchie_increased = false
	self.neuro_ouchie_reset_timer = nil

	self:resetTubes()
	self:addTube({
		{-40, 240},
		{0, 250},
		{130, 315},
		{200, 350},
		{290, 405},
		{440, 445}
	})
	self:addTube({
		{SCREEN_WIDTH+40, 240},
		{900, 305},
		{810, 360},
		{720, 400},
		{560, 445}
	})
	self:spawnNewMemoryInTube(1)
end

function game:keypressed(key)
	print("Game pressed: "..Utils.dump(key))
    if key == 'a' then
    	print("Pressed a")
        Timer.after(1, function() print("Hello, world!") end)
    elseif key == "k" then
    	self.stage:addChild(MemoryFactory:createMemory(self.tubes[love.math.random(1, #self.tubes)], "tower"))
    elseif key == "g" then
    	self:gameOver()
    end
end

function game:mousepressed( x, y, button, istouch, presses )
	--print(x, y, button, istouch, presses)
	self.stage:onMousePressed(x, y, button, istouch, presses)
end

function game:update()
	self.stage:update()

	self.game_timer = self.game_timer + DT

	if math.floor(self.game_timer)%60 == 0 and not self.ouchie_increased then
		self.neuro_ouchie = self.neuro_ouchie + 1
		self.ouchie_increased = true
		self.neuro_ouchie_reset_timer = Timer.after(1, function() -- what a nice way to do that
			self.ouchie_increased = false
		end)
	end

	for i,timer in ipairs(self.tubes_timer) do
		self.tubes_timer[i] = timer + DT
		--print(i.."-"..timer)
		if timer >= MEMORY_SPAWN_RATE then
			self.tubes_timer[i] = timer - MEMORY_SPAWN_RATE
			self:spawnNewMemoryInTube(i)
		end
	end
end

function game:changeLife(amount)
	self.neuro_life = self.neuro_life + amount

	if self.neuro_life > self.neuro_max_life then
		self.neuro_life = self.neuro_max_life
	end

	if self.neuro_life <= 0 then
		self.neuro_life = 0
		self:gameOver()
	end

	Signal.emit("game-healthChanged")
end

function game:gameOver()
	print("Whoops! You losest!")
	GameStateManager:changeState("gameOver")
end

function game:spawnNewMemoryInTube(index)
	self.stage:addChild(MemoryFactory:createMemory(self.tubes[index], MemoryFactory:getRandomMemory()))
end

function game:addTube(points)
	local tube = TubePath(points)
	self.stage:addChild(tube)
	table.insert(self.tubes, tube)
	table.insert(self.tubes_timer, 0)
end

function game:resetTubes()
	for i=#self.tubes, 1, -1 do
		local tube = table.remove(self.tubes, i)
		tube:remove()
	end
	self.tubes = {}
	self.tubes_timer = {}
end

function game:draw()

	love.graphics.draw(self.background, 0, 0, 0, 1)
	love.graphics.draw(self.neuro, 0, -120, 0, 1)
	
	love.graphics.draw(self.tubes_lower_in, 0, -120, 0, 1)
	love.graphics.draw(self.tubes_lower_out, 0, -120, 0, 1)

	self.stage:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Game text", 100, 199)

	love.graphics.print("Time: "..math.floor(self.game_timer), 20, 100)
	love.graphics.print("Score: "..self.score, 20, 140)
	love.graphics.print("Best Score: "..self.best_score, 20, 180)

	love.graphics.draw(self.health_bar_health, self.health_quad, 59, (SCREEN_HEIGHT-self.health_bar_1:getHeight()-10)+56)
	love.graphics.draw(self.health_bar_1, 0, SCREEN_HEIGHT-self.health_bar_1:getHeight()-10)
	if self.score >= 0 then
		love.graphics.draw(self.health_bar_2, 0, SCREEN_HEIGHT-self.health_bar_1:getHeight()-10)
	end

	local x, y = love.mouse.getPosition()
	love.graphics.print("Mouse Pos: ("..x..","..y..")", 20, 180+32)
end

return game