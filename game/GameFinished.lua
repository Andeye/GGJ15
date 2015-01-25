
GameFinished = {}
GameFinished.__index = GameFinished


function GameFinished:new(o)
  local self = setmetatable(o or {}, GameFinished)

  return self
end


return GameFinished
