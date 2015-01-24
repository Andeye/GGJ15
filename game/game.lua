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

local elevator = Elevator:new()


Game = {
  player = nil,
  characterList = nil,
  drawables = nil,
}
Game.__index = Game


local nakedDudeSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/naked_dude_spritesheet.png")
local mainCharacterFrontsideSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/main_character_front_spritesheet.png")

---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y, spritesheetImage)
  local character = Character:new(x, y, PersonalityGenerator:createPersonality())

  local walkAnimationMatrix, panicAnimationMatrix, scale = AnimationParser:parseCharacter(spritesheetImage)

  character:addAnimation("walk", Animation:new(spritesheetImage, walkAnimationMatrix, scale))
  character:addAnimation("panic", Animation:new(spritesheetImage, panicAnimationMatrix, scale))

  return character
end


local function sendGlobalEvent(self, type)
  print("send global event")
  local newEvent = EventTypes:getEvent(self.player, type)
  for i, character in ipairs(self.characterList) do
    self.characterList[i]:event(newEvent)
  end
end


local buttonOffsetX = 30
local buttonOffsetY = 30
local buttonList = {}

local function createButton(title, eventTrigger)
  local x = elevator.x + elevator.elevatorImage:getWidth() * elevator.scale + buttonOffsetX

  local y = buttonOffsetY
  if #buttonList > 0 then
    y = buttonList[#buttonList].y + buttonList[#buttonList].height + buttonOffsetY
  end

  local button = Button:new{
    x = x,
    y = y,
    text = title,
    onClick = eventTrigger
  }

  table.insert(buttonList, button)

  return button
end


function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  self.characterList = {}
  self.drawables = {}
  table.insert(self.drawables, elevator)

  SoundMusic:load()
  SoundSfx:load()

  local character = createCharacter(450, 300, nakedDudeSpritesheetImage)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(550, 150, nakedDudeSpritesheetImage)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(800, 250, nakedDudeSpritesheetImage)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  self.player = createCharacter(650, 350, mainCharacterFrontsideSpritesheetImage)
  table.insert(self.drawables, self.player)

  GUI:addComponent(createButton("Dance", function() sendGlobalEvent(self, "dance") end))
  GUI:addComponent(createButton("Calm down", function() sendGlobalEvent(self, "calm_down") end))

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
    local newEvent = EventTypes:getEvent(game.player, "dance")
    for i, character in ipairs(game.characterList) do
      game.characterList[i]:event(newEvent)
    end
  elseif key == "r" then
    local newEvent = EventTypes:getEvent(self.player, "calm_down")
    for i, character in ipairs(game.characterList) do
      game.characterList[i]:event(newEvent)
    end
  end
end

local function input(dt)
  if love.keyboard.isDown("w") then
    game.player:move(0, -100 * dt * 0.47)
  end
  if love.keyboard.isDown("s") then
    game.player:move(0, 100 * dt * 0.47)
  end
  if love.keyboard.isDown("a") then
    game.player:move(-100 * dt, 0)
  end
  if love.keyboard.isDown("d") then
    game.player:move(100 * dt, 0)
  end
  if love.keyboard.isDown("t") then
    game.player:moveTo(200, -100)
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

  self.player:update(dt)

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
  table.sort(self.drawables, sortY)
  for k,v in ipairs(self.drawables) do
    v:draw()
  end
end

function sortY(a, b)
  return a:getY() < b:getY()
end
