local game = {}

function game:init()
	print("Init Game State")
	self.stage = Object()

	self.score = 0
	self.best_score = 0

	self.game_timer = 0

	Signal.register("memoryInNeuro", function(memory)
		print("Signal test for "..memory:getName())

		local score = 20
		if not memory.isReal then
			score = -score
		end

		self.score = self.score + score
		if self.score > self.best_score then
			self.best_score = self.score
		end

		memory:remove()
	end)

	self.tubes = {
		TubePath({
			{100, 0},
			{120, 60},
			{150, 100},
			{250, 250},
			{270, 290}
		})
	}
	self.tubes_timer = {}
	for i,tube in ipairs(self.tubes) do
		self.stage:addChild(tube)
		table.insert(self.tubes_timer, 0)
	end

	self.stage:addChild(MemoryFactory:createMemory(self.tubes[1], "gymbag"))

	--[[Timer.after(2, function()
		self.stage:addChild(MemoryFactory:createMemory(self.tubes[1], "tower"))
	end)
	Timer.after(4, function()
		self.stage:addChild(MemoryFactory:createMemory(self.tubes[1], "tower"))
	end)]]
	Timer.after(4, function()
		self:addTube({
			{600, 0},
			{550, 100},
			{500, 140},
			{440, 170},
			{310, 290}
		})
	end)
end

function game:enter()
	print("Entered Game State")
end

function game:keypressed(key)
	print("Game pressed: "..Utils.dump(key))
    if key == 'a' then
    	print("Pressed a")
        Timer.after(1, function() print("Hello, world!") end)
    end
end

function game:update()
	self.stage:update()

	self.game_timer = self.game_timer + DT

	for i,timer in ipairs(self.tubes_timer) do
		self.tubes_timer[i] = timer + DT
		print(i.."-"..timer)
		if timer >= MEMORY_SPAWN_RATE then
			self.tubes_timer[i] = timer - MEMORY_SPAWN_RATE
			self:spawnNewMemoryInTube(i)
		end
	end
end

function game:spawnNewMemoryInTube(index)
	self.stage:addChild(MemoryFactory:createMemory(self.tubes[index], "gymbag"))
end

function game:addTube(points)
	local tube = TubePath(points)
	self.stage:addChild(tube)
	table.insert(self.tubes, tube)
	table.insert(self.tubes_timer, 0)
end

function game:draw()
	self.stage:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Game text", 100, 199)

	love.graphics.print("Time: "..math.floor(self.game_timer), 20, 100)
	love.graphics.print("Score: "..self.score, 20, 140)
	love.graphics.print("Best Score: "..self.best_score, 20, 180)
end

return game