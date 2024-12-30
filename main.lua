utf8 = require("utf8")

Class = require("src.hump.class")
function Class.isClass(class)
	local mt = getmetatable(class)
    return mt and mt.__call ~= nil
end

GameStateManager = require("src.hump.gamestate")
Timer = require("src.hump.timer")
Signal = require("src.hump.signal")

Utils = require("src.utils")

Object = require("src.objects.object")
TubeNode = require("src.objects.TubeNode")
TubePath = require("src.objects.TubePath")
TubeTrailObject = require("src.objects.TubeTrailObject")

Memory = require("src.objects.Memory")
Gymbag = require("src.objects.memories.Gymbag")
Tower = require("src.objects.memories.Tower")
MemoryFactory = require("src.objects.MemoryFactory")

GameStates = {
	menu = require("src.states.menu"),
	game = require("src.states.game"),
	debug = require("src.states.debug"),
	gameOver = require("src.states.gameOver")
}
function GameStateManager:changeState(state, use_switch, ...)
	if use_switch == nil then use_switch = true end

	if use_switch then
		self.switch(GameStates[state], ...)
	else
		self.push(GameStates[state], ...)
	end
end

function love.load()
	require("src.vars")
	print("GAME START: Neuro Game is started!")

	for id,state in pairs(GameStates) do
		GameStates[id].id = id
		GameStates[id].getId = function(self) return self.id end
	end

	main_font = love.graphics.newFont("assets/fonts/coffee.ttf", 32)

	Timer.after(2, function() print("yay") end)

	GameStateManager.registerEvents()
	GameStateManager:changeState("game")
end

function love.update(dt)
	Timer.update(dt)
	DT = dt

	FPS_TIMER = FPS_TIMER + DT
	FPS_COUNTER = FPS_COUNTER + 1
	if FPS_TIMER >= 1 then
		FPS = FPS_COUNTER
		FPS_COUNTER = 0
		FPS_TIMER = FPS_TIMER - 1
	end
end

function pressedCtrl()
	return love.keyboard.isScancodeDown("lctrl") or love.keyboard.isScancodeDown("rctrl")
end
function pressedShift()
	return love.keyboard.isScancodeDown("lshift") or love.keyboard.isScancodeDown("rshift")
end
function pressedAlt()
	return love.keyboard.isScancodeDown("lalt") or love.keyboard.isScancodeDown("ralt")
end

function love.keypressed(key, scancode, is_repeat)
	if scancode == "escape" then
		love.event.quit()
	elseif love.keyboard.isScancodeDown("lctrl") and scancode == "r" then
		love.event.quit("restart")
	elseif pressedCtrl() and scancode == "d" then
		DEBUG_VIEW = not DEBUG_VIEW
	end
end

function love.draw()
	love.graphics.setFont(main_font)
	if DEBUG_VIEW then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(FPS.." FPS", 0, 0)
	end
end