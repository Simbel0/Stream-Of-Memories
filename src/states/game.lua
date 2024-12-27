local game = {}

function game:init()
	print("Init Game State")
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

function game:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Game text", 100, 199)
end

return game