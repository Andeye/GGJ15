GamePrms = {
  size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("personality_generator.lua")()
love.filesystem.load("character.lua")()
love.filesystem.load("elevator.lua")()
love.filesystem.load("animation.lua")()
love.filesystem.load("special_animation.lua")()
love.filesystem.load("animation_parser.lua")()

love.filesystem.load("sound_music.lua")()
love.filesystem.load("sound_sfx.lua")()

love.filesystem.load("event_types.lua")()
love.filesystem.load("event.lua")()

local elevator = Elevator:new()


Game = {
  GAME_DURATION = (6 + (4 * math.random() - 2)) * 60, -- 4 - 8 minutes of gameplay
  accumulatedGameTime = 0,
  player = nil,
  characterList = nil,
  drawables = nil,
  buttonOffsetX = 30,
  buttonOffsetY = 30,
  buttonList = nil,
  anyButtonClicked = false,
  ACCUMULATED_TIME_LIMIT = 4,
}
Game.__index = Game


local nakedDudeSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/naked_dude_spritesheet.png")
local mainCharacterFrontsideSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/main_character_front_spritesheet.png")
local mainCharacterSpecialSpritesheetImage_1 = love.graphics.newImage("assets/graphics/sprites/main_character_special_spritesheet_1.png")

---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y, spritesheetImage)
  local character = Character:new(x, y, PersonalityGenerator:createPersonality())

  local walkAnimationMatrix, panicAnimationMatrix, scale, quadWidth = AnimationParser:parseCharacter(spritesheetImage)

  character:addAnimation("walk", Animation:new(spritesheetImage, walkAnimationMatrix, scale, quadWidth))
  character:addAnimation("panic", Animation:new(spritesheetImage, panicAnimationMatrix, scale, quadWidth))

  return character
end

local function buttonUpdate(button, f)
  if button.isDisabled or game.anyButtonPressed then
    return
  else
    f()
    game.anyButtonPressed = true
    button.isDisabled = true
    button:setImageDown()
  end
end


local function sendGlobalEvent(self, type)
  print("send global event")
  local newEvent = EventTypes:getEvent(self.player, type)
  for i, character in ipairs(self.characterList) do
    self.characterList[i]:event(newEvent)
  end
end



local function createButton(game, title, f)
  local x = elevator.x + elevator.elevatorImage:getWidth() * elevator.scale + game.buttonOffsetX

  local y = game.buttonOffsetY
  if #game.buttonList > 0 then
    y = game.buttonList[#game.buttonList].y + game.buttonList[#game.buttonList].height + game.buttonOffsetY
  end

  local button = Button:new{
    x = x,
    y = y,
    text = title,
    onClick = function(button)
      buttonUpdate(button, f)
    end, -- eventTrigger,
    mousereleased = function(button)
      if button.isDisabled then
        return
      else
        button.image = button.imageUp
      end
    end,
    accumulatedTime = 0,
    isDisabled = false,
    accumulate = function(self, dt)
      if self.isDisabled then
        self.accumulatedTime = self.accumulatedTime + dt
        if self.accumulatedTime >= game.ACCUMULATED_TIME_LIMIT then
          self.isDisabled = false
          game.anyButtonPressed = false
          self:setImageUp()
          print("enabled")
          self.accumulatedTime = 0
        end
      end
    end
  }

  --  buttonUpdate(button, f)
  
  table.insert(game.buttonList, button)

  return button
end


function addSpecialSpriteSheets(player)
  
  -- add the special animations
  
  local totalRows = 3
  local quads = 10
  local specialAnimations = {}
  local scale = nil
  local quadWidth = nil
  for i = 1, totalRows do
    specialAnimations[i], scale, quadWidth = AnimationParser:parseSpecialSpritesheet(mainCharacterSpecialSpritesheetImage_1, i, quads, totalRows)
  end
  player:addSpecialAnimation("handwave", SpecialAnimation:new(mainCharacterSpecialSpritesheetImage_1, specialAnimations[1], scale, quadWidth, 100))
  player:addSpecialAnimation("calm_down", SpecialAnimation:new(mainCharacterSpecialSpritesheetImage_1, specialAnimations[2], scale, quadWidth, 100))
  player:addSpecialAnimation("fart", SpecialAnimation:new(mainCharacterSpecialSpritesheetImage_1, specialAnimations[3], scale, quadWidth, 300))
  
  -- add the idle "animation"
  local idleAnimationMatrix, scale, quadwidth = AnimationParser:parseIdleAnimation(mainCharacterSpecialSpritesheetImage_1, quads, totalRows)
  player:addAnimation("idle", Animation:new(mainCharacterSpecialSpritesheetImage_1, idleAnimationMatrix, scale, quadWidth))
  player:playAnimation("idle")
  
end


function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false

  self.characterList = {}
  self.drawables = {}
  table.insert(self.drawables, elevator)

  SoundMusic:load()
  SoundSfx:load()

  --[[
  -- create the characters
  --]]
  local character = createCharacter(450, 300, nakedDudeSpritesheetImage)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(550, 150, nakedDudeSpritesheetImage)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(800, 250, nakedDudeSpritesheetImage)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)
  
  --[[
  -- Create the player
  --]]
  
  self.player = createCharacter(650, 350, mainCharacterFrontsideSpritesheetImage)
  addSpecialSpriteSheets(self.player)
  table.insert(self.drawables, self.player)
  
  --[[
  -- Create buttons
  --]]


  self.buttonList = {}
  GUI:addComponent(createButton(self, "Dance",
    function()
      sendGlobalEvent(self, "dance")
    end))
  GUI:addComponent(createButton(self, "Calm down",
    function()
      sendGlobalEvent(self, "calm_down")
    end))
  GUI:addComponent(createButton(self, "Fart",
    function()
      sendGlobalEvent(self, "fart")
      SoundSfx:play("fart_male_" .. math.random(1, 3))
    end))
  GUI:addComponent(createButton(self, "Wave", function() sendGlobalEvent(self, "wave") end))
  GUI:addComponent(createButton(self, "Flirt", function()
    sendGlobalEvent(self, "flirt")
    SoundSfx:play("kiss_female_" .. math.random(1, 2))
  end))
  GUI:addComponent(createButton(self, "Tell joke", function() sendGlobalEvent(self, "tell_joke") end))
  GUI:addComponent(createButton(self, "Irritate", function() sendGlobalEvent(self, "irritate") end))

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
  elseif key == "8" then
    game.player:playSpecialAnimation("fart")
  elseif key == "9" then
    game.player:playSpecialAnimation("handwave")
  elseif key == "0" then
    game.player:playSpecialAnimation("calm_down")
  elseif key == "f" then
    SoundSfx:play("fart")
  elseif key == "m" then
    game.player:mirror()
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
  dbg:msg("Game time", self.accumulatedGameTime)
  dbg:msg("Game Ends", self.GAME_DURATION)

  self.accumulatedGameTime = self.accumulatedGameTime + dt

  if self.accumulatedGameTime < self.GAME_DURATION then
    input(dt)

    self.player:update(dt)

    elevator:update(dt)
    for _, character in ipairs(self.characterList) do
      character:update(dt)
    end

    local roomPanic, roomAwkwardness = getRoomStatus(self)

    for _, button in ipairs(self.buttonList) do
      button:accumulate(dt)
    end

    dbg:msg("---------------------------", "")
    dbg:msg("roomPanic", roomPanic)
    dbg:msg("roomAwkwardness", roomAwkwardness)

    SoundMusic:update(dt, roomPanic, roomAwkwardness)
  else
  -- Do END GAME STUFF/Logic
  end
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
