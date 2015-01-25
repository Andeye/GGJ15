Shaft = {
  shaftImage = love.graphics.newImage("assets/graphics/shaft.png"),
  y = 0,
}
Shaft.__index = Shaft

function Shaft:new(o)
  local self = setmetatable(o or {}, Shaft)
  
  return self
end

function Shaft:draw()
  love.graphics.draw(self.shaftImage, 0, self.y, 0, self.scale)
end

function Shaft:getZ()
  return self.y
end