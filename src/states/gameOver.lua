local gameOver = {}

function gameOver:init()
	self.static_frames = {
		love.graphics.newImage("assets/sprites/static_1.png"),
		love.graphics.newImage("assets/sprites/static_2.png"),
		love.graphics.newImage("assets/sprites/static_3.png"),
		love.graphics.newImage("assets/sprites/static_4.png")
	}

	self.font = love.graphics.newFont("assets/fonts/vcr.ttf", 32)
end

function gameOver:enter(game)
	self.timer = 0

	self.frame = 1
	self.frame_timer = 0

	self.static_alpha = 0.8

	self.text = [[> There is a problem with Neuro's AI.[w:10]
> STOP NEUROSAMA PROGRAM[w:2]
> Calling Vedal...[w:15]
> FAILURE.[w:2]
> Calling Vedal...[w:15]
> FAILURE.[w:20]
> Someone tell Vedal there is a problem with 
  his AI.[w:10] ]]

  	self.text = self.text .. "\n\n> Score: "..game.score
  	self.text = self.text .. "\n> Best Score: "..game.best_score
	self.tText = ""
	self.typewriter = 0
	self.last_typewrite = 0

	self.text_speed = 20

	self.wait_timer = 0

	self.text_end = #self.text

	self.done_typing = false

	self.skip_typewriter = false
	self.skip_text = [[> There is a problem with Neuro's AI.
> STOP NEUROSAMA PROGRAM
> Calling Vedal...
> FAILURE.
> Calling Vedal...
> FAILURE.
> Someone tell Vedal there is a problem with 
  his AI.]]
  	self.skip_text = self.skip_text .. "\n\n> Error Score: "..game.score
end

function gameOver:update()
	self.timer = self.timer + DT*10
	--print(self.timer)

	self.frame_timer = self.frame_timer + 20*DT
	self.frame = math.floor(self.frame_timer) + 1
	if self.frame > #self.static_frames then
		self.frame_timer = 0
		self.frame = 1
	end

	if self.timer > 20 and self.timer <= 55 then
		self.static_alpha = self.static_alpha - DT/5
	elseif self.timer > 70 then
		if self.done_typing then return end
		if self.wait_timer > 0 then
			local speed = self.text_speed-5
			if speed < 1 then speed = 1 end
			self.wait_timer = self.wait_timer - DT*speed
			return
		end

		self.typewriter = self.typewriter + DT*self.text_speed
		if math.floor(self.typewriter) ~= self.last_typewrite then
			self.last_typewrite = math.floor(self.typewriter)
			self.tText = self.tText .. self:checkNextCharacter(self.text:sub(self.last_typewrite, self.last_typewrite))
		end

		if self.typewriter > #self.text then
			self.typewriter = #self.text
			self.done_typing = true
			self.wait_timer = math.huge
		end
	end
end

function gameOver:keypressed(key)
	if (key == "return" or key == "space") and (not self.skip_typewriter or not self.done_typing) then
		print("Skipping")
		self.skip_typewriter = true
		self.done_typing = true

		self.timer = 300
		self.static_alpha = 0.1

		self.wait_timer = math.huge

		self.typewriter = #self.text

		self.tText = self.skip_text
	elseif key == "return" and self.done_typing then
		GameStateManager:changeState("game")
	elseif key == "escape" and self.done_typing then
		GameStateManager:changeState("menu")
	end
end

--[[function gameOver:getAllTextRight()
	local e = #self.text

	local rText = self.tText
	while self.last_typewrite <= e do
		self.last_typewrite = self.last_typewrite + 1
		rText = rText .. self:checkNextCharacter(self.text:sub(self.last_typewrite, self.last_typewrite))
	end
end]]

function gameOver:checkNextCharacter(char)
	if char == "[" then
		local count = 0
		local current_tw = self.last_typewrite+1
		local nextChar = self.text:sub(current_tw, current_tw)
		local command = ""
		repeat
			count = count + 1
			current_tw = current_tw + 1
			command = command .. nextChar
			nextChar = self.text:sub(current_tw, current_tw)
		until nextChar == "]"

		self.typewriter = self.typewriter + count+1
		self.last_typewrite = self.last_typewrite + count+1

		local match = {}
		for word in command:gmatch('([^:]+)') do
			table.insert(match, word)
		end
		local inst, time = unpack(match)
		if inst == "w" or inst == "wait" then
			self.wait_timer = tonumber(time)
		end
		return ""
	end

	return char
end

function gameOver:draw()
	love.graphics.setColor(1, 1, 1, self.static_alpha)
	love.graphics.draw(self.static_frames[self.frame], 0, 0)

	if self.typewriter <= 0 then
		return
	end

	love.graphics.setFont(self.font)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(self.tText, 15, 30)

	if self.done_typing then
		love.graphics.print("[ENTER] Restart", 15, SCREEN_HEIGHT-32*3)
		love.graphics.print("[ESCAPE] Main Menu", 15, SCREEN_HEIGHT-32*2)
	end
end

return gameOver