Aula = {
  aulaImage = love.graphics.newImage("assets/graphics/aula.png"),
  auladoorwallImage = love.graphics.newImage("assets/graphics/auladoorwall.png"),
  y = 0,
}
Aula.__index = Aula

function Aula:new(o)
  local self = setmetatable(o or {}, Aula)
  
  return self
end

function Aula:draw()
  love.graphics.draw(self.aulaImage, 0, self.y, 0, self.scale)
  love.graphics.draw(self.auladoorwallImage, 0, self.y, 0, self.scale)
end

function Aula:getZ()
  return self.y + 1
end