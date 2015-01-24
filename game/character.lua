CharacterPrms = {
  image = love.graphics.newImage("assets/graphics/gubbskelett.png"),
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
	self.image = CharacterPrms.image
	self.scale = love.window:getHeight() / self.image:getHeight() / 2
	return self
end


function Character:update(dt)
end


function Character:draw()
  love.graphics.draw(self.image, (love.window:getWidth() - self.image:getWidth()*self.scale) / 2, 200, 0, self.scale)
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
