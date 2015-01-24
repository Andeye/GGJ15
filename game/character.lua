CharacterPrms = {
  image = love.graphics.newImage("assets/graphics/gubbskelett.png"),
}

Character = {
  animations = {},
  currentAnimationKey = nil,
	awkard = 50,
	panic = 50,
	x = 500,
	y = 300,
}
Character.__index = Character


function Character:new(o)
  local self = setmetatable(o or {}, Character)

	self.image = CharacterPrms.image
	self.scale = love.window:getHeight() / self.image:getHeight() / 2
	
	return self
end


function Character:update(dt)
  self.animations[self.currentAnimationKey]:update(dt)
end


function Character:draw()
  self.animations[self.currentAnimationKey]:draw(self.x, self.y)
--  love.graphics.draw(self.image, (love.window:getWidth() - self.image:getWidth()*self.scale) / 2, 200, 0, self.scale)
end


function Character:addAnimation(key, animation)
  self.animations[key] = animation
  if self.currentAnimationKey == nil then
    self.currentAnimationKey = key
  end
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
