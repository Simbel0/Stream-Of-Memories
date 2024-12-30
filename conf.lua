function love.conf(t)
	t.identity = "neuromemories"

	if love.system and love.system.getOS() ~= "Web" then
		t.version = "11.0"
	end

	t.window.title = "Stream of Memories"
	t.window.icon = "icon.png"

	t.window.width = 960
    t.window.height = 540

    -- Thinking about phones I guess
    t.externalstorage = true
end