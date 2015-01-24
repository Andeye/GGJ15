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
local drawables = {}
table.insert(drawables, elevator)

Game = {
  }
Game.__index = Game

---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y, color)
  local character = Character:new(x, y, color)

  local image = love.graphics.newImage("assets/graphics/sprites/whitedude_spritesheet.png")
  local quadArray, scale = AnimationParser:parse(image, 1, 4, 1)
  local timeArray = {100, 100, 100, 100}

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
  
  local character = createCharacter(450, 300, {255, 0, 0})
  table.insert(characterList, character)
  table.insert(drawables, character)
  character = createCharacter(650, 300, {255, 255, 0})
  table.insert(characterList, character)
  table.insert(drawables, character)
  character = createCharacter(630, 350, {0, 0, 255})
  table.insert(characterList, character)
  table.insert(drawables, character)
  player = createCharacter(550, 150, {255, 0, 255})
  table.insert(characterList, player)
  table.insert(drawables, player)
  
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
  if love.keyboard.isDown("t") then
    player:moveTo(200, -100)
  end
  if love.keyboard.isDown("r") then
    elevator.y = 1000
    elevator:moveTo(0)
  end
  if love.keyboard.isDown("e") then
    elevator:moveTo(-1000)
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

function Game:draw()
  table.sort(drawables, sortY)
  for k,v in ipairs(drawables) do
    v:draw()
  end
end

function sortY(a, b)
  return a:getY() < b:getY()
end
