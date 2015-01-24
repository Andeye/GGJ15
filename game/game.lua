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

love.filesystem.load("event_types.lua")()
love.filesystem.load("event.lua")()

love.filesystem.load("aula.lua")()
love.filesystem.load("shaft.lua")()

local elevator = Elevator:new()
local aula = Aula:new()
local shaft = Shaft:new()
aula.scale = elevator.scale
shaft.scale = elevator.scale


Game = {
  player,
  characterList,
  drawables,
}
Game.__index = Game


local nakedDudeSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/naked_dude_spritesheet.png")

---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y)
  local character = Character:new(x, y, PersonalityGenerator:createPersonality())

  local walkAnimationMatrix, panicAnimationMatrix, scale = AnimationParser:parseCharacter(nakedDudeSpritesheetImage)

  character:addAnimation("walk", Animation:new(nakedDudeSpritesheetImage, walkAnimationMatrix, scale))
  character:addAnimation("panic", Animation:new(nakedDudeSpritesheetImage, panicAnimationMatrix, scale))

  return character
end

function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  self.characterList = {}
  self.drawables = {}
  table.insert(self.drawables, aula)
  table.insert(self.drawables, shaft)
  for k,v in pairs(elevator:getDrawables()) do
    table.insert(self.drawables, v)
  end

  SoundMusic:load()
  SoundSfx:load()

  local character = createCharacter(200, 300)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(300, 150)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(550, 250)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)
  
  player = createCharacter(400, 350)
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
    local newEvent = EventTypes:getEvent(player, "dance")
    for i, character in ipairs(game.characterList) do
      game.characterList[i]:event(newEvent)
    end
  elseif key == "r" then
    local newEvent = EventTypes:getEvent(player, "calm_down")
    for i, character in ipairs(game.characterList) do
      game.characterList[i]:event(newEvent)
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
  
  dbg:msg("---------------------------", "")
  dbg:msg("roomPanic", roomPanic)
  dbg:msg("roomAwkwardness", roomAwkwardness)

  SoundMusic:update(dt, roomPanic, roomAwkwardness)
end

function Game:draw()
  --[[
  for k,v in pairs(elevator:getDrawables()) do
    table.insert(self.drawables, v)
  end
  --]]
  table.sort(self.drawables, sortZ)
  for k,v in ipairs(self.drawables) do
    v:draw()
  end
end

function sortZ(a, b)
  -- print("a")
  -- print(dbg:serialize(a))
  -- print("b")
  -- print(dbg:serialize(b))
  return a:getZ() < b:getZ()
end
