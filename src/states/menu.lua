local menu = {}

function menu.init()
	print("Init Menu State")
end

function menu.enter()
	print("Entered Menu State")
end

function menu.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Menu text", 100, 199)
end

return menu