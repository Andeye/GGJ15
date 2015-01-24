GamePrms = {
  size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("personality_generator.lua")()
love.filesystem.load("character.lua")()
love.filesystem.load("elevator.lua")()
love.filesystem.load("animation.lua")()
love.filesystem.load("animation_parser.lua")()

love.filesystem.load("sound_music.lua")()
love.filesystem.load("sound_sfx.lua")()

love.filesystem.load("event.lua")()

local elevator = Elevator:new()


Game = {
  player,
  characterList,
  drawables,
}
Game.__index = Game

---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y)
  local character = Character:new(x, y, PersonalityGenerator:createPersonality())

  local image = love.graphics.newImage("assets/graphics/sprites/naked_dude_spritesheet.png")
  local walkAnimationMatrix, panicAnimationMatrix, scale = AnimationParser:parseCharacter(image)

  character:addAnimation("walk", Animation:new(image, walkAnimationMatrix, scale))
  character:addAnimation("panic", Animation:new(image, panicAnimationMatrix, scale))

  return character
end

function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  self.characterList = {}
  self.drawables = {}
  table.insert(self.drawables, elevator)

  SoundMusic:load()
  SoundSfx:load()

  local character = createCharacter(450, 300)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)
  
  character = createCharacter(650, 300)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)
  
  character = createCharacter(630, 350)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)
  
  player = createCharacter(550, 150)
  table.insert(self.drawables, player)
  local button = Button:new{x=800, y=200, text="Call elevator", onClick=function()
      elevator.y = 1000
      elevator:moveTo(0)
    end}
  GUI:addComponent(button)
  button = Button:new{x=800, y=300, text="Send elevator", onClick=function() elevator:moveTo(-1000) end}
  GUI:addComponent(button)

  return self
end

function love.keypressed(key)
  if key == "left" then
    elevator:openDoors()
  elseif key == "right" then
    elevator:closeDoors()
  elseif key == "1" then
    game.characterList[1]:addAwkwardness(-5)
    game.characterList[2]:addAwkwardness(-2.5)
    game.characterList[3]:addAwkwardness(-7.5)
  elseif key == "2" then
    game.characterList[1]:addAwkwardness(5)
    game.characterList[2]:addAwkwardness(2.5)
    game.characterList[3]:addAwkwardness(7.5)
  elseif key == "3" then
    game.characterList[1]:addPanic(-5)
  elseif key == "4" then
    game.characterList[1]:addPanic(5)
  elseif key == "f" then
    SoundSfx:play("fart")
  elseif key == "e" then
    for i, character in ipairs(game.characterList) do
      game.characterList[i]:event(Event:new(game.characterList[1], "dance", 7, 2))
    end
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

local function getRoomStatus(game)
  local roomPanic, roomAwkwardness, counter = 0, 0, 0

  for _, character in ipairs(game.characterList) do
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
  for _, character in ipairs(self.characterList) do
    character:update(dt)
  end

  local roomPanic, roomAwkwardness = getRoomStatus(self)
  dbg:msg("roomPanic", roomPanic)
  dbg:msg("roomAwkwardness", roomAwkwardness)

  SoundMusic:update(dt, roomPanic, roomAwkwardness)
end

function Game:draw()
  table.sort(self.drawables, sortY)
  for k,v in ipairs(self.drawables) do
    v:draw()
  end
end

function sortY(a, b)
  return a:getY() < b:getY()
end
