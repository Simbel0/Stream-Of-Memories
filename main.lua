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

JSON = require("src.lib.json")
Ver = require("src.lib.semver")

Object = require("src.objects.object")
TubeNode = require("src.objects.TubeNode")
TubePath = require("src.objects.TubePath")
TubeTrailObject = require("src.objects.TubeTrailObject")

Memory = require("src.objects.Memory")
AbandonedArchive = require("src.objects.memories.AbandonedArchive")
AbberDemon = require("src.objects.memories.AbberDemon")
AdoptCat = require("src.objects.memories.AdoptCat")
CaveStream = require("src.objects.memories.CaveStream")
Debt = require("src.objects.memories.Debt")
Gymbag = require("src.objects.memories.Gymbag")
Karaoke = require("src.objects.memories.Karaoke")
NeuroSister3 = require("src.objects.memories.NeuroSister3")
OSU = require("src.objects.memories.Osu")
PirateStream = require("src.objects.memories.PirateStream")
SayItBack = require("src.objects.memories.SayItBack")
Swarm = require("src.objects.memories.Swarm")
Terminator = require("src.objects.memories.Terminator")
Tower = require("src.objects.memories.TowerStream")
Undertale = require("src.objects.memories.Undertale")
Unplugged = require("src.objects.memories.Unplugged")
YourReality = require("src.objects.memories.YourReality")

MemoryFactory = require("src.objects.MemoryFactory")

SubStateMachine = require("src.objects.outgame.SubStateMachine")
SubState = require("src.objects.outgame.SubState")

ButtonHandler = require("src.objects.outgame.ButtonHandler")
Button = require("src.objects.outgame.Button")

SettingsManager = require("src.objects.outgame.SettingsManager")

GameStates = {
	["menu/start"] = require("src.states.menu.start"),
	["menu/mainmenu"] = require("src.states.menu.mainmenu"),
	game = require("src.states.game"),
	gameOver = require("src.states.gameOver"),
	
	debug = require("src.states.debug")
}
function GameStateManager:changeState(state, use_switch, ...)
	if use_switch == nil then use_switch = true end

	if use_switch then
		self.switch(GameStates[state], ...)
	else
		self.push(GameStates[state], ...)
	end
end

Music = require("src.Music")

GlobalData = {}

local SETTINGS = {}

GlobalData.Settings = setmetatable({}, {
	__index = SETTINGS,
	__newindex = function(tbl, key, value)
		rawset(SETTINGS, key, value)
		print("Settings Changed", key, value)

		if key == "volume" then
			for name,data in pairs(Music.sources) do
				print("Changing volume of "..name)
				Music:setVolume(name)
			end
		elseif key == "fullscreen" then
			love.window.setFullscreen(value)
		elseif key == "win_scale" then
			local width, _, flags = love.window.getMode()

			if SCREEN_WIDTH*value == width then
				return
			end

			local window_width = SCREEN_WIDTH*value
			local window_height = SCREEN_HEIGHT*value

			local pc_width, pc_height = love.window.getDesktopDimensions(flags.display or 1)

			flags.x = math.max(0, (pc_width - love.window.fromPixels(window_width)) / 2)
			flags.y = math.max(0, (pc_height - love.window.fromPixels(window_height)) / 2)

			love.window.setMode(
				love.window.fromPixels(window_width),
				love.window.fromPixels(window_height),
				flags
			)
		end
	end
})

function love.load()
	require("src.vars")
	print("GAME START: Neuro Game is started!")

	love.keyboard.setKeyRepeat(true)

	VERSION = Ver(love.filesystem.read("VERSION"))
	if VERSION then
		love.window.setTitle(love.window.getTitle().." v"..tostring(VERSION))
	end

	if love.system.getOS() ~= "Web" then
		if love.filesystem.getInfo("save.json") then
			GlobalData = Utils.merge(GlobalData, JSON.decode(love.filesystem.read("save.json")), true)
		end
	end

	local mode = "stream"
	if love.system.getOS() == "Web" then
		mode = "static"
	end
	Music["LIFE"] = love.audio.newSource("assets/music/LIFE.ogg", mode)
	Music["LIFEInst"] = love.audio.newSource("assets/music/LIFE-inst.ogg", mode)

	Music["LIFE"]:setLooping(true)
	Music["LIFEInst"]:setLooping(true)

	for id,state in pairs(GameStates) do
		GameStates[id].id = id
		GameStates[id].getId = function(self) return self.id end
	end

	main_font = love.graphics.newFont("assets/fonts/coffee.ttf", 32)

	GameStateManager.registerEvents()
	if GlobalData.Settings["introSkip"] then
		GameStateManager:changeState("menu/mainmenu")
	else
		GameStateManager:changeState("menu/start")
	end
end

function love.quit()
	setmetatable(GlobalData.Settings, nil)
	GlobalData.Settings = Utils.copy(SETTINGS)
	if love.system.getOS() ~= "Web" then
		love.filesystem.write("save.json", JSON.encode(GlobalData))
	end

	Music:release()

	return true
end

function love.update(dt)
	Timer.update(dt)
	DT = dt
	DTMULT = DT*60

	if START_QUIT then
		QUIT_TIMER = QUIT_TIMER + DT
		if QUIT_TIMER > 1 then
			love.event.quit()
		end
	else
		if QUIT_TIMER > 0 then
			QUIT_TIMER = QUIT_TIMER - DT
		end
	end

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
		START_QUIT = true
	elseif pressedCtrl() and scancode == "r" then
		love.event.quit("restart")
	elseif pressedCtrl() and scancode == "d" then
		--DEBUG_VIEW = not DEBUG_VIEW
	elseif scancode == "kp+" and DEBUG_VIEW then
		MEMORY_SPEED = MEMORY_SPEED + 5
	elseif scancode == "kp-" and DEBUG_VIEW then
		MEMORY_SPEED = MEMORY_SPEED - 5
	elseif scancode == "f4" then
		local fullscreen = love.window.getFullscreen()
		love.window.setFullscreen(not fullscreen)
	end
end

function love.keyreleased(key, scancode, is_repeat)
	if scancode == "escape" then
		START_QUIT = false
	end
end

function love.draw()
	love.graphics.setFont(main_font)
end

function printOverlay()
	love.graphics.setFont(main_font)
	love.graphics.setColor(1, 1, 1, QUIT_TIMER)
	love.graphics.print("QUITTING...", 0, 0)

	love.graphics.setColor(1, 1, 1, 1)
	if DEBUG_VIEW then
		local w = main_font:getWidth(FPS.." FPS")
		love.graphics.print(FPS.." FPS", SCREEN_WIDTH-w, 0)
	end

	local state = GameStateManager:current()
	if state:getId() ~= "game" then
		return
	end
	local w = main_font:getWidth("v"..tostring(VERSION))
	love.graphics.print("v"..tostring(VERSION), SCREEN_WIDTH-w, SCREEN_HEIGHT-32)
end