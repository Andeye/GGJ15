-- Statemachine for managing and at some point also transitioning between the game states.
-- A state here being a menu, cut-scene animation or gameplay.
GameState = {
	states,
	stack,
}

function GameState:new()
	-- No need to create multiple game state managers
	self.states = {}
	self.stack = {}
	return GameState
end

function GameState:update(dt)
	local current = self:getCurrent()
	if current then
		current:update(dt)
		return true
	end
	return false
end

function GameState:draw()
	local current = self:getCurrent()
	if current then
		current:draw()
		return true
	end
	return false
end

function GameState:getCurrent()
	return self.stack[#self.stack]
end

function GameState:add(name, state)
	if self.states[name] == nil then
		self.states[name] = state
		return true
	end
	return false
end

function GameState:change(name)
	if self.states[name] then
		self.stack[#self.stack] = self.states[name]
		return true
	end
	return false
end

function GameState:push(name)
	if self.states[name] then
		table.insert(self.stack, self.states[name])
		return true
	end
	return false
end

function GameState:pop()
	return table.remove(self.stack)
end
