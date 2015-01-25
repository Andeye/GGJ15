
GameFinished = {
  started = false,
}
GameFinished.__index = GameFinished


function GameFinished:new(o)
  local self = setmetatable(o or {}, GameFinished)

  return self
end


local accTime = 0

function GameFinished:update(dt)
 
end


function GameFinished:draw()
  love.graphics.rectangle("fill", 100, 100, love.window:getWidth() - 200, love.window:getHeight() - 200)
end


return GameFinished
