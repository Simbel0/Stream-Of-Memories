local SubState = Class()

function SubState:init()
end

function SubState:enter()

end

function SubState:pause()

end

function SubState:resume()
	return true
end

function SubState:leave()

end

function SubState:update()

end

function SubState:draw()

end

function SubState:keypressed()

end

function SubState:getMainState()
	return self.machine.up_state
end

return SubState