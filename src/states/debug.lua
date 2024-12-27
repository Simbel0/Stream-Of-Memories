local Debug = {}

function Debug:init()
	print("Init Debug State")

	self.test = Object(100, 297)
	self.testPath = TubePath(0, 0)
end

function Debug:enter()
	print("Entered Debug State")
	print(self.test.x)
	print(self.testPath.x)
	--print("Object info: "..self.TestObject.x)
end

function Debug:keypressed(key)
	print("Debug pressed: "..Utils.dump(key))
    if key == 'a' then
    	print("Pressed a")
        Timer.after(1, function() print("Hello, world!") end)
    end
end

function Debug:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Debug text", 100, 199)
end

return Debug