
GameFinished = {
  }
GameFinished.__index = GameFinished

function GameFinished:new(o)
  local self = setmetatable(o or {}, GameFinished)

  --  self.image = love.graphics.newImage("assets/graphics/credits.png")
  --  self.scale = love.window:getHeight() / self.image:getHeight()
  --  self.x = (love.window:getWidth() - self.image:getWidth() * self.scale) / 2
  --  self.y = (love.window:getHeight() - self.image:getHeight() * self.scale) / 2

  return self
end

function GameFinished:update(dt)
end

function GameFinished:draw()
  if self.image then
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale)
  end
end


return GameFinished
