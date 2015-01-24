GamePrms = {
  size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("character.lua")()
love.filesystem.load("elevator.lua")()
love.filesystem.load("animation.lua")()
love.filesystem.load("animation_parser.lua")()

local elevator = Elevator:new()
local character = Character:new()

Game = {
  }
Game.__index = Game


function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  local image = love.graphics.newImage("assets/graphics/sprites/whitedude_spritesheet.png")
  local quadArray, scale = AnimationParser:parse(image, 1, 4, 1)
  local timeArray = {100, 100, 100, 100}
  
  character:addAnimation("test", Animation:new(image, quadArray, timeArray, scale))

  return self
end


function love.keypressed(key)
  if key == "left" then
    elevator:openDoors()
  elseif key == "right" then
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
