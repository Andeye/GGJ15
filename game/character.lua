CharacterPrms = {
	size = 25,
}

Character = {
	awkard = 50,
	panic = 50,
}
Character.__index = Character


function Character:new()
	local self = setmetatable({}, Character)
	self.hover = false
	
	return self
end

function Character:update(dt)
end

function Character:draw()
end

function Character:event(o)
	if o.type == "awkward" then
		--
	elseif o.name == "dance" then
		--
	else
		self.awkard = self.awkward + o.awkward
		self.panic = self.panic + o.panic
	end
end
