GamePrms = {
	size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("character.lua")()
love.filesystem.load("elevator.lua")()

local elevator = Elevator:new()
local character = Character:new()

Game = {
}
Game.__index = Game


function Game:new()
	local self = setmetatable({}, Game)
	self.hover = false

	local test = Character:new()
	
	return self
end


function love.keypressed(key)
  if key == "left" then
    print("left")
    elevator:openDoors()
  elseif key == "right" then
    print("right")
    elevator:closeDoors()
  end
end


function Game:update(dt)
	dbg:msg("Game ID", tostring(self.selected))

  elevator:update(dt)
  character:update(dt)
end

function Game:draw()
	elevator:draw()
	character:draw()
end
