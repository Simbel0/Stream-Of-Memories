utf8 = require("utf8")

_Class = require("src.hump.class")
GameStateManager = require("src.hump.gamestate")
Timer = require("src.hump.timer")

Utils = require("src.utils")

GameStates = {
	menu = require("src.states.menu"),
	game = require("src.states.game")
}

function love.load()
	require("src.vars")
	print("Neuro Game is started!")

	Timer.after(2, function() print("yay") end)

	GameStateManager.registerEvents()
	GameStateManager.switch(GameStates.game)
end

function love.update(dt)
	Timer.update(dt)
end

function love.keypressed(key, scancode, is_repeat)
	if scancode == "escape" then
		love.event.quit()
	elseif love.keyboard.isScancodeDown("lctrl") and scancode == "r" then
		love.event.quit("restart")
	end
end

function love.draw()
end