local MemoryFactory = Class()

MemoryFactory.allMemories = {
	good = {
		gymbag=Gymbag,
	},
	wrong = {
		tower=Tower
	}
}

function MemoryFactory:getMemory(id)
	for type,memory_list in pairs(self.allMemories) do
		for mId,memory in pairs(memory_list) do
			if mId == id then
				return memory
			end
		end
	end
end

function MemoryFactory:getAllMemories()
	local memories = {}
	print("A")
	for type,memory_list in pairs(self.allMemories) do
		print("B")
		for mId,memory in pairs(memory_list) do
			print("C")
			table.insert(memories, memory)
		end
	end
	print("D")

	--print("All memories: "..Utils.dump(memories))
	return memories
end

function MemoryFactory:getRandomMemory()
	local memories = self:getAllMemories()

	return memories[love.math.random(1, #memories)]
end

function MemoryFactory:getRandomMemories(number)
	local memories = self:getAllMemories()
	local rd_memories = {}

	local index = number
	while index >= 0 do
		index = index - 1
		rd_memories = memories[love.math.random(1, #memories)]
	end

	return rd_memories
end

function MemoryFactory:createMemory(path, memory)
	if type(memory) == "string" then
		return self:getMemory(memory)(path)
	elseif type(memory) == "table" then
		if #memory == 0 then return end

		local m = {}
		if type(memory[1]) == "string" then -- id
			for i,mem in ipairs(memory) do
				table.insert(m, self:getMemory(memory)(path))
			end
		elseif type(memory[1]) == "table" then -- class
			for i,mem in ipairs(memory) do
				table.insert(m, mem(path))
			end
		end

		return m
	end
end

return MemoryFactory