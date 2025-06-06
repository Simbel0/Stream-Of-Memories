local SubStateMachine = Class()

function SubStateMachine:init(state)

	self.up_state = state

	self.orig_func = {
		update = state.update,
		draw = state.draw,
		keypressed = state.keypressed,
		wheelmoved = state.wheelmoved,
		mousepressed = state.mousepressed,
	}

	for func,state_func in pairs(self.orig_func) do
		state[func] = function(_, ...)
			state_func(state, ...)
			if self and self[func] then
				self[func](self, ...)
			end
			local post_func = "post"..Utils.simpleTitleCase(func)
			if state[post_func] then
				state[post_func](state, ...)
			end
		end
	end

	self.states = {}

	self.stack = {}
end

function SubStateMachine:deactivate()
	self:resetStack()

	for func,state_func in pairs(self.orig_func) do
		state[func] = state_func
	end
end

function SubStateMachine:addState(id, state)
	self.states[id] = state
end

function SubStateMachine:getState(id)
	return self.states[id]
end

function SubStateMachine:getCurrentState()
	return self.stack[#self.stack]
end

function SubStateMachine:push(id)
	local state = self:getState(id)
	if state == nil then
		error("The state \""..id.."\" doesn't exist!")
	end

	local new_state = state()
	new_state.machine = self
	self:getCurrentState():pause()
	table.insert(self.stack, new_state)
	new_state:enter()

	return new_state
end

function SubStateMachine:pop()
	local state = table.remove(self.stack, #self.stack)

	state:leave()

	if not self:getCurrentState():resume() then
		self:getCurrentState():enter()
	end

	return state
end

function SubStateMachine:changeState(id)
	local state = self:getState(id)
	if state == nil then
		error("The state \""..id.."\" doesn't exist!")
	end

	self:resetStack()

	local new_state = state()
	new_state.machine = self
	table.insert(self.stack, new_state)
	new_state:enter()

	return new_state
end

function SubStateMachine:resetStack()
	for k,state in ipairs(self.stack) do
		state:leave()
	end

	self.stack = {}
end

function SubStateMachine:update(...)
	self:getCurrentState():update(...)
end

function SubStateMachine:draw(...)
	for i,state in ipairs(self.stack) do
		if state == self:getCurrentState() or (state ~= self:getCurrentState() and not state._dont_draw_when_paused) then
			state:draw(...)
		end
	end
end

function SubStateMachine:keypressed(...)
	self:getCurrentState():keypressed(...)
end

function SubStateMachine:wheelmoved(...)
	self:getCurrentState():wheelmoved(...)
end

function SubStateMachine:mousepressed(...)
	local state = self:getCurrentState()
	local func = state.mousepressed
	if not func then
		return
	end
	func(state, ...)
end

return SubStateMachine