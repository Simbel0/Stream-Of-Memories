local game = {}

function game:init()
	print("Init Game State")
	self.stage = Object()

	self.score = 0
	self.best_score = 0
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
end

function game:draw()
	self.stage:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Game text", 100, 199)
end

return game