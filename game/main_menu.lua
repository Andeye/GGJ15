MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu:new()
  local self = setmetatable({}, MainMenu)
  return self
end

function MainMenu:update(dt)

end

function MainMenu:draw()

end
