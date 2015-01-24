GamePrms = {
  size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("character.lua")()
love.filesystem.load("elevator.lua")()
love.filesystem.load("animation.lua")()
love.filesystem.load("animation_parser.lua")()

love.filesystem.load("sound_music.lua")()
love.filesystem.load("sound_sfx.lua")()

local elevator = Elevator:new()

local player
local characterList = {}

Game = {
  }
Game.__index = Game


---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y)
  local character = Character:new(x, y)

  local image = love.graphics.newImage("assets/graphics/sprites/whitedude_spritesheet.png")
  local quadArray, scale = AnimationParser:parse(image, 1, 4, 1)
  local timeArray = {100, 100, 4000000, 100}

  character:addAnimation("test", Animation:new(image, quadArray, timeArray, scale))

  local faceImage = love.graphics.newImage("assets/graphics/faces/face-test.png")
  local faceQuadArray = AnimationParser:parse(faceImage, 1, 5, 1)
  character:setFaces(faceImage, faceQuadArray, 88, 48)

  return character
end



function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  SoundMusic:load()
  SoundSfx:load()
  
  table.insert(characterList, createCharacter(450, 300))
  table.insert(characterList, createCharacter(650, 300))
  table.insert(characterList, createCharacter(630, 350))
  player = createCharacter(550, 150)
  
  return self
end


function love.keypressed(key)
  if key == "left" then
    elevator:openDoors()
  elseif key == "right" then
    elevator:closeDoors()
  elseif key == "1" then
    characterList[1]:addAwkwardness(-5)
    characterList[2]:addAwkwardness(-2.5)
    characterList[3]:addAwkwardness(-7.5)
  elseif key == "2" then
    characterList[1]:addAwkwardness(5)
    characterList[2]:addAwkwardness(2.5)
    characterList[3]:addAwkwardness(7.5)
  elseif key == "3" then
    characterList[1]:addPanic(-5)
  elseif key == "4" then
    characterList[1]:addPanic(5)
  elseif key == "f" then
    SoundSfx:play("fart")
  end
end


local function input(dt)
  if love.keyboard.isDown("w") then
    player:move(0, -100 * dt * 0.47)
  end
  if love.keyboard.isDown("s") then
    player:move(0, 100 * dt * 0.47)
  end
  if love.keyboard.isDown("a") then
    player:move(-100 * dt, 0)
  end
  if love.keyboard.isDown("d") then
    player:move(100 * dt, 0)
  end
end


local function getRoomStatus()
  local roomPanic, roomAwkwardness, counter = 0, 0, 0
  
  for _, character in ipairs(characterList) do
    roomPanic = roomPanic + character:getPanic()
    roomAwkwardness = roomAwkwardness + character:getAwkward()
    counter = counter + 1
  end
  
  return roomPanic / counter, roomAwkwardness / counter
end


function Game:update(dt)
  dbg:msg("Game ID", tostring(self.selected))

  input(dt)
  
  player:update(dt)

  elevator:update(dt)
  for _, character in ipairs(characterList) do
    character:update(dt)
  end

  local roomPanic, roomAwkwardness = getRoomStatus()
  dbg:msg("roomPanic", roomPanic)
  dbg:msg("roomAwkwardness", roomAwkwardness)
  
  SoundMusic:update(dt, roomPanic, roomAwkwardness)
end


-- TODO: REMOVE THIS
local colors = {{255, 0, 0}, {255, 255, 0}, {0, 0, 255}, {255, 0, 255}}
function Game:draw()
  elevator:draw()
  for i, character in ipairs(characterList) do
    local r, g, b = love.graphics.getColor()
    love.graphics.setColor(colors[i])
    character:draw()
    love.graphics.setColor(r, g, b)
  end
  player:draw()
end
