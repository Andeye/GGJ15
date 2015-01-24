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


---
-- Temporary function for creating the test character (whitedude)
local function createCharacter()
  local image = love.graphics.newImage("assets/graphics/sprites/whitedude_spritesheet.png")
  local quadArray, scale = AnimationParser:parse(image, 1, 4, 1)
  local timeArray = {100, 100, 100, 100}
  
  character:addAnimation("test", Animation:new(image, quadArray, timeArray, scale))
end


function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  createCharacter()

  return self
end


function love.keypressed(key)
  if key == "left" then
    elevator:openDoors()
  elseif key == "right" then
    elevator:closeDoors()
  end
end


local function input(dt)
  if love.keyboard.isDown("w") then
    character:move(0, -100 * dt * 0.47)
  end
  if love.keyboard.isDown("s") then
    character:move(0, 100 * dt * 0.47)
  end
  if love.keyboard.isDown("a") then
    character:move(-100 * dt, 0)
  end
  if love.keyboard.isDown("d") then
    character:move(100 * dt, 0)
  end
end


function Game:update(dt)
  dbg:msg("Game ID", tostring(self.selected))
  
  input(dt)

  elevator:update(dt)
  character:update(dt)
end

function Game:draw()
  elevator:draw()
  character:draw()
end
