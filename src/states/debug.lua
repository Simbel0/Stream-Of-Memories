local Debug = {}

function Debug:init()
	print("Init Debug State")
	self.stage = Object(0, 0)

	--self.test = Object(100, 297)
	--self.stage:addChild(self.test)
	self.testPath = TubePath({
		{100, 10},
		{120, 50},
		{150, 100},
		{200, 160},
		{250, 210},
		{350, 300}
	})
	self.stage:addChild(self.testPath)

	self.obj = TubeTrailObject(self.testPath)
	self.stage:addChild(self.obj)
end

function Debug:enter()
	print("Entered Debug State")
	--print(self.test.x)
	print(Utils.dump(self.testPath:getNodePos(2)))
	--print("Object info: "..self.TestObject.x)
end

function Debug:keypressed(key)
	print("Debug pressed: "..Utils.dump(key))
    if key == 'a' then
    	print("Pressed a")
        Timer.after(1, function() print("Hello, world!") end)
    end
end

function Debug:update()
	self.stage:update()
	self.testPath.x = self.testPath.x + 50*DT
end

function Debug:draw()
	self.stage:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Debug text", 100, 199)
end

return Debug