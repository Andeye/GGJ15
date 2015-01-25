Aula = {
  aulaImage = love.graphics.newImage("assets/graphics/aula.png"),
  auladoorwallImage = love.graphics.newImage("assets/graphics/auladoorwall.png"),
  barsImage = love.graphics.newImage("assets/graphics/backgroundbars.png"),
  y = 0,
}
Aula.__index = Aula

function Aula:new(o)
  local self = setmetatable(o or {}, Aula)
  
  return self
end

local function draw(self)
  love.graphics.draw(self.image, 0, self:getY(), 0, self.scale)
end

function Aula:getDrawables()
  return {
    {
      draw=draw,
			getY=function() return self.y end,
			image=self.aulaImage,
			getZ=function() return self.y + 1 end,
			0,
			scale=self.scale
    }, {
      draw=draw,
			getY=function() return self.y end,
			image=self.auladoorwallImage,
			getZ=function() return self.y + 2 end,
			0,
			scale=self.scale
    } , {
      draw=draw,
			getY=function() return self.y end,
			image=self.barsImage,
			getZ=function() return self.y - 1000 end,
			0,
			scale=self.scale
    }
  }
end
