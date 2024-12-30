local game = {}

function game:init()
	print("Init Game State")
	self.stage = Object()

	self.background = love.graphics.newImage("assets/sprites/neuro_room/backgroundfinal.png")

	self.neuro = love.graphics.newImage("assets/sprites/neuro_room/neurofinal.png")
	self.neuro_hair = love.graphics.newImage("assets/sprites/neuro_room/neurofinalhair.png")

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
		local score = 20
		local ouch_mult = 1
		local add_vol = 0.2
		if not memory.isReal then
			score = math.floor(score*-1.5)
			add_vol = -0.2
			ouch_mult = -2
		end

		self.inst_vol = self.inst_vol + add_vol
		if self.inst_vol > self.max_inst_vol then
			self.inst_vol = self.max_inst_vol
		elseif self.inst_vol < 0 then
			self.inst_vol = 0
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

	MEMORY_SPAWN_RATE = DEFAULT_MEMORY_SPAWN_RATE
	MEMORY_SPEED = DEFAULT_MEMORY_SPEED

	self.stage = Object()

	self.score = 0
	self.best_score = 0

	self.game_timer = 0

	self.neuro_life = 100
	self.neuro_max_life = 100

	self.neuro_ouchie = 10
	self.ouchie_increased = false
	self.neuro_ouchie_reset_timer = nil

	self.inst_vol = 1
	self.voice_vol = 0

	self.max_inst_vol = 1
	self.max_voice_vol = 1

	Musics["LIFEInst"]:play()
	Musics["LIFE"]:play()

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
	self:spawnNewMemoryInTube()
end

function game:leave()
	print("leave")

	Musics["LIFE"]:stop()
	Musics["LIFEInst"]:stop()
end

function game:keypressed(key)
	if DEBUG_VIEW and pressedCtrl() then
	    if key == "k" then
	    	self.stage:addChild(MemoryFactory:createMemory(self.tubes[love.math.random(1, #self.tubes)], "tower"))
	    elseif key == "g" then
	    	self:gameOver()
	    end
	end
end

function game:mousepressed( x, y, button, istouch, presses )
	--print(x, y, button, istouch, presses)
	self.stage:onMousePressed(x, y, button, istouch, presses)
end

function game:update()
	self.stage:update()

	Musics["LIFEInst"]:setVolume(math.max(self.inst_vol-self.voice_vol, 0))

	if self.game_timer > 150 then
		self.voice_vol = self.voice_vol + DT/20
		if self.voice_vol > self.max_voice_vol then
			self.voice_vol = self.max_voice_vol
		end
	end

	Musics["LIFE"]:setVolume(self.voice_vol)

	self.game_timer = self.game_timer + DT

	if math.floor(self.game_timer)%15 == 0 and not self.ouchie_increased then
		self.neuro_ouchie = self.neuro_ouchie + 1
		if self.game_timer >= 120 then
			self.neuro_ouchie = self.neuro_ouchie + 1
		end
		self.ouchie_increased = true
		self.neuro_ouchie_reset_timer = Timer.after(1, function() -- what a nice way to do that
			self.ouchie_increased = false
		end)
	end

	if self.game_timer > 60 and #self.tubes == 2 then
		self:addTube({
			{60, -60},
			{75, 0},
			{160, 110},
			{290, 230},
			{430, 350}
		}, true)
		self:addTube({
			{925, -60},
			{915, 0},
			{820, 130},
			{690, 255},
			{570, 350}
		}, true)
	elseif self.game_timer > 120 and #self.tubes == 4 then
		self:addTube({
			{310, -60},
			{320, 0},
			{365, 110},
			{435, 235}
		}, true)
		self:addTube({
			{675, -60},
			{685, 0},
			{630, 120},
			{560, 235}
		}, true)
	end

	if self.game_timer >= 150 then
		if math.floor(self.game_timer)%5 == 0 then
			if MEMORY_SPAWN_RATE > 1 then
				MEMORY_SPAWN_RATE = MEMORY_SPAWN_RATE - 0.15*DT
			end
			if MEMORY_SPEED < 200 then 
				MEMORY_SPEED = MEMORY_SPEED + 5*DT
			end
		end
	end

	for i,timer in ipairs(self.tubes_timer) do
		if not self.tubes[i].drop_anim then
			self.tubes_timer[i] = timer + DT
			--print(i.."-"..timer)
			if timer >= MEMORY_SPAWN_RATE then
				self.tubes_timer[i] = timer - MEMORY_SPAWN_RATE
				self:spawnNewMemoryInTube(i)
			end
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
		return
	end

	Signal.emit("game-healthChanged")
end

function game:gameOver()
	print("Whoops! You losest!")
	GameStateManager:changeState("gameOver")
end

function game:getAvailableTubes()
	local tubes = {}
	for i,tube in ipairs(self.tubes) do
		if not tube.drop_anim then
			table.insert(tubes, tube)
		end
	end

	return tubes
end

function game:spawnNewMemoryInTube(index)
	local available_tubes = self:getAvailableTubes()
	if index == nil then
		index = love.math.random(1, #available_tubes)
	end
	self.stage:addChild(MemoryFactory:createMemory(available_tubes[index], MemoryFactory:getRandomMemory()))
end

function game:addTube(points, drop_anim)
	local tube = TubePath(points)
	tube:setDropAnim(drop_anim or false)
	self.stage:addChild(tube)
	table.insert(self.tubes, tube)
	table.insert(self.tubes_timer, love.math.random(0, MEMORY_SPAWN_RATE))
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
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.background, 0, 0, 0, 1)
	love.graphics.draw(self.neuro, 0, -120, 0, 1)

	if #self.tubes > 4 then
		love.graphics.draw(self.tubes_high_in, 0, self.tubes[5].y-120, 0, 1)
		love.graphics.draw(self.tubes_high_out, 0, self.tubes[5].y-120, 0, 1)

		if not self.tubes[5].drop_anim then
			love.graphics.draw(self.neuro_hair, 0, self.tubes[5].y-120, 0, 1)
		end
	end

	if #self.tubes > 2 then
		love.graphics.draw(self.tubes_middle_in, 0, self.tubes[3].y-120, 0, 1)
		love.graphics.draw(self.tubes_middle_out, 0, self.tubes[3].y-120, 0, 1)
	end

	love.graphics.draw(self.tubes_lower_in, 0, self.tubes[1].y-120, 0, 1)
	love.graphics.draw(self.tubes_lower_out, 0, self.tubes[1].y-120, 0, 1)

	self.stage:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Score: "..self.score, 20, 140)
	love.graphics.print("Best Score: "..self.best_score, 20, 180)
	if DEBUG_VIEW then
		love.graphics.print("Game text", 100, 199)

		love.graphics.print("Time: "..math.floor(self.game_timer), 20, 100)
		love.graphics.print("Ouchie Value: "..self.neuro_ouchie, 20, 220)

		love.graphics.print("MEMORY SPAWN: "..MEMORY_SPAWN_RATE, 20, 240)
		love.graphics.print("MEMORY SPEED: "..MEMORY_SPEED, 20, 280)
	end

	love.graphics.draw(self.health_bar_health, self.health_quad, 59, (SCREEN_HEIGHT-self.health_bar_1:getHeight()-10)+56)
	love.graphics.draw(self.health_bar_1, 0, SCREEN_HEIGHT-self.health_bar_1:getHeight()-10)
	if self.score >= 0 then
		love.graphics.draw(self.health_bar_2, 0, SCREEN_HEIGHT-self.health_bar_1:getHeight()-10)
	end

	printOverlay()

	--local x, y = love.mouse.getPosition()
	--love.graphics.print("Mouse Pos: ("..x..","..y..")", 20, 180+32)
end

return game