GamePrms = {
  size = 25,
}
-- pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("game_finished.lua")()

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

love.filesystem.load("aula.lua")()
love.filesystem.load("shaft.lua")()

elevator = Elevator:new()
local aula = Aula:new()
local shaft = Shaft:new()
aula.scale = elevator.scale
shaft.scale = elevator.scale


Game = {
  GAME_DURATION = (6 + (4 * math.random() - 2)) * 60, -- 4 - 8 minutes of gameplay
  MINIMI_TIME_BETWEEN_RANDOM_EVENTS = 20,  -- TODO: change this to 20 (or suitable for gameplay)
  START_IDLE_ELEVATOR_FREQ = 3, -- how often the elevators come by in the beginning when idle
  accumulatedGameTime = 0,
  startIdleTime = 0,
  accTimeBetweenRandomEvents = 0,
  player = nil,
  characterList = nil,
  drawables = nil,
  buttonOffsetX = 30,
  buttonOffsetY = 30,
  buttonList = nil,
  anyButtonClicked = false,
  ACCUMULATED_TIME_LIMIT = 0,
  started = false,
  ACCUMULATED_TIME_LIMIT = 3,
  skinColorShader = love.graphics.newShader("assets/shaders/skincolor.glsl"),
  nakedDudeSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/naked_dude_spritesheet.png"),
  nakedDudeSpritesheetImageMask = love.graphics.newImage("assets/graphics/sprites/naked_dude_spritesheet_mask.png"),
  shirtDudeSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/shirt_dude_spritesheet.png"),
  shirtDudeSpritesheetImageMask = love.graphics.newImage("assets/graphics/sprites/shirt_dude_spritesheet_mask.png"),
  flowerLadySpritesheetImage = love.graphics.newImage("assets/graphics/sprites/flower_lady_spritesheet.png"),
  flowerLadySpritesheetImageMask = love.graphics.newImage("assets/graphics/sprites/flower_lady_spritesheet_mask.png"),
  beardGuySpritesheetImage = love.graphics.newImage("assets/graphics/sprites/beard_guy_spritesheet.png"),
  beardGuySpritesheetImageMask = love.graphics.newImage("assets/graphics/sprites/beard_guy_spritesheet_mask.png"),
  mainCharacterFrontsideSpritesheetImage = love.graphics.newImage("assets/graphics/sprites/main_character_front_spritesheet.png"),
  mainCharacterFrontsideSpritesheetImageMask = love.graphics.newImage("assets/graphics/sprites/main_character_front_spritesheet_mask.png"),
  mainCharacterSpecialSpritesheetImage_1 = love.graphics.newImage("assets/graphics/sprites/main_character_special_spritesheet_1.png"),
  mainCharacterSpecialSpritesheetImage_1_Mask = love.graphics.newImage("assets/graphics/sprites/main_character_special_spritesheet_1_mask.png"),
}
Game.__index = Game



---
-- Temporary function for creating the test character (whitedude)
local function createCharacter(x, y, spritesheetImage, spritesheetMask)
  local character = Character:new(x, y, PersonalityGenerator:createPersonality())

  local walkAnimationMatrix, panicAnimationMatrix, scale, quadWidth = AnimationParser:parseCharacter(spritesheetImage)

  character:addAnimation("walk", Animation:new(spritesheetImage, spritesheetMask, walkAnimationMatrix, scale, quadWidth))
  character:addAnimation("panic", Animation:new(spritesheetImage, spritesheetMask, panicAnimationMatrix, scale, quadWidth))

  return character
end

local function buttonUpdate(button, f)
  if button.isDisabled or game.anyButtonPressed then
    return
  else
    game.anyButtonPressed = true
    button.isDisabled = true
    button:setLitUp(true)
    f()
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
  local x = elevator.x + elevator.elevatorFloor:getWidth() * elevator.scale + game.buttonOffsetX

  local y = game.buttonOffsetY
  if #game.buttonList > 0 then
    y = game.buttonList[#game.buttonList].y + game.buttonList[#game.buttonList].height + game.buttonOffsetY
  end

  local button = Button:new {
    x = x,
    y = y,
    text = title,
    mousepressed = function(button)
      SoundSfx:play("button_click")
      button:setImageDown()
      if not button.isDisabled and not game.anyButtonPressed then
        buttonUpdate(button, f)
      end
    end, -- eventTrigger,,
    accumulatedTime = 0,
    isDisabled = false,
    accumulate = function(self, dt)
      if self.isDisabled then
        self.accumulatedTime = self.accumulatedTime + dt
        if self.accumulatedTime >= game.ACCUMULATED_TIME_LIMIT then
          self.isDisabled = false
          self:setLitUp(false)
          game.anyButtonPressed = false
          self.accumulatedTime = 0
        end
      end
    end
  }

  --  buttonUpdate(button, f)

  table.insert(game.buttonList, button)

  return button
end


local function addSpecialSpriteSheets(game, player)

  -- add the special animations

  local totalRows = 6
  local quads = 10
  local specialAnimations = {}
  local scale = nil
  local quadWidth = nil
  for i = 1, totalRows do
    specialAnimations[i], scale, quadWidth = AnimationParser:parseSpecialSpritesheet(game.mainCharacterSpecialSpritesheetImage_1, i, quads, totalRows)
  end
  player:addSpecialAnimation("tell_joke", SpecialAnimation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, specialAnimations[1], scale, quadWidth, 150))
  player:addSpecialAnimation("irritate", SpecialAnimation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, specialAnimations[2], scale, quadWidth, 200))
  player:addSpecialAnimation("dance", SpecialAnimation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, specialAnimations[3], scale, quadWidth, 100))
  player:addSpecialAnimation("fart", SpecialAnimation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, specialAnimations[4], scale, quadWidth, 300))
  player:addSpecialAnimation("calm_down", SpecialAnimation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, specialAnimations[5], scale, quadWidth, 150))
  player:addSpecialAnimation("handwave", SpecialAnimation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, specialAnimations[6], scale, quadWidth, 100))

  -- add the idle "animation"
  local idleAnimationMatrix, scale, quadwidth = AnimationParser:parseIdleAnimation(game.mainCharacterSpecialSpritesheetImage_1, quads, totalRows)
  player:addAnimation("idle", Animation:new(game.mainCharacterSpecialSpritesheetImage_1, game.mainCharacterSpecialSpritesheetImage_1_Mask, idleAnimationMatrix, scale, quadWidth))

  player:mirror()
  player:playAnimation("panic")
  player:addPanic(-100)
  player:addPanic(80)

end


function Game:new()
  local self = setmetatable({}, Game)
  self.hover = false
  
  self.GAME_DURATION = (6 + (4 * math.random() - 2)) * 60 -- 4 - 8 minutes of gameplay

  gameFinished = GameFinished:new()
  GameState:add("gameFinished", gameFinished)

  self.characterList = {}
  self.drawables = {}
  for k,v in pairs(aula:getDrawables()) do
    table.insert(self.drawables, v)
  end
  table.insert(self.drawables, shaft)
  for k,v in pairs(elevator:getDrawables()) do
    table.insert(self.drawables, v)
  end

  SoundMusic:load()
  SoundSfx:load()

  --
  -- Create the player
  --

  self.player = createCharacter(130, 150, self.mainCharacterFrontsideSpritesheetImage, self.mainCharacterFrontsideSpritesheetImageMask)
  addSpecialSpriteSheets(self, self.player)
  table.insert(self.drawables, self.player)

  self.player.z = 840
  
  self.buttonList = {}
  
  GUI:addLayer("game_gui", true)

  GUI:addComponent(createButton(self, "Enter",
  function()
    GUI:delComponent(self.buttonList[1], "enter")
    self.buttonList = {}
    self:createGameButtons()
    self.started = true
    game.anyButtonPressed = false

    self.player.inElevator = true
    self.player:moveTo(350, 400, 1000, length)
  end), "enter", "game_gui")

  --
  -- Create buttons
  --
  -- self:createGameButtons()

  return self
end

function Game:createCharacters()
  local character = createCharacter(200, 300, self.shirtDudeSpritesheetImage, self.shirtDudeSpritesheetImageMask)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(300, 150, self.flowerLadySpritesheetImage, self.flowerLadySpritesheetImageMask)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)

  character = createCharacter(550, 250, self.beardGuySpritesheetImage, self.beardGuySpritesheetImageMask)
  table.insert(self.characterList, character)
  table.insert(self.drawables, character)
end

function Game:removeCharacters()
  for k,v in pairs(self.characterList) do
    for k2,v2 in pairs(self.drawables) do
      if v == v2 then
        table.remove(self.drawables, k2)
      end
    end
  end
  self.characterList = {}
end

function Game:createGameButtons()
  self.buttonList = {}
  GUI:addComponent(createButton(self, "Dance",
    function()
      sendGlobalEvent(self, "dance")
      game.player:playSpecialAnimation("dance", 3)
    end), "game_gui")
  GUI:addComponent(createButton(self, "Calm down",
    function()
      sendGlobalEvent(self, "calm_down")
      game.player:playSpecialAnimation("calm_down")
    end), "game_gui")
  GUI:addComponent(createButton(self, "Fart",
    function()
      sendGlobalEvent(self, "fart_player")
      game.player:playSpecialAnimation("fart")
      SoundSfx:play("fart_player")
    end), "game_gui")
  GUI:addComponent(createButton(self, "Wave",
    function()
      sendGlobalEvent(self, "wave")
      game.player:playSpecialAnimation("handwave")
    end), "game_gui")
  GUI:addComponent(createButton(self, "Flirt", function()
    sendGlobalEvent(self, "flirt")
    SoundSfx:play("kiss_female_" .. math.random(1, 2))
  end), "game_gui")
  GUI:addComponent(createButton(self, "Tell joke",
    function()
      sendGlobalEvent(self, "tell_joke")
      game.player:playSpecialAnimation("tell_joke", 2)
    end), "game_gui")
  GUI:addComponent(createButton(self, "Irritate",
    function()
      sendGlobalEvent(self, "irritate")
      game.player:playSpecialAnimation("irritate")
    end), "game_gui")

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

  if self.started then
    self.accumulatedGameTime = self.accumulatedGameTime + dt
  else
    self.startIdleTime = self.startIdleTime + dt
  end

  dbg:msg("startIdleTime", self.startIdleTime)
  dbg:msg("START_IDLE_ELEVATOR_FREQ", self.START_IDLE_ELEVATOR_FREQ)
  dbg:msg("elevator.y", elevator.y)
  if self.startIdleTime > self.START_IDLE_ELEVATOR_FREQ then
    self:startIdleLoop()
  end
  
  if self.started and self.accumulatedGameTime < self.GAME_DURATION then
    self:gameLoop(dt)
  elseif self.started then
    -- Do END GAME STUFF/Logic
--    GameState:pop()
    GUI:layerVisible("game_gui", false)
    GameState:push("gameFinished")
  end
  self:coreLoop(dt)
end

function Game:coreLoop(dt)
  elevator:update(dt)
end

function Game:gameLoop(dt)
    input(dt)

    self.player:update(dt)

    for _, character in ipairs(self.characterList) do
      character:update(dt)
    end

    local roomPanic, roomAwkwardness = getRoomStatus(self)
    local roomMean = (roomPanic + roomAwkwardness) / 2
    self.accTimeBetweenRandomEvents = self.accTimeBetweenRandomEvents + dt

    -- TODO: Change 100 to 1000 or 10000 for more seldom events
    if self.accTimeBetweenRandomEvents > self.MINIMI_TIME_BETWEEN_RANDOM_EVENTS and math.random() < roomMean / 1000 then
      dbg:msg("room mean", roomMean)

      local filter = {
        canScream = false,
        canChuckle = false,
        canSob = false,
      }
      for _, character in ipairs(self.characterList) do
        if character.panic > 90 then
          filter.canScream = true
        end
        if character.panic < 40 then
          filter.canChuckle = true
        end
        if character.panic > 60 then
          filter.canSob = true
        end
      end
      local newEvent = EventTypes:getRandomEvent("elevator", filter)
      for _, character in ipairs(self.characterList) do
        character:event(newEvent)
      end
      self.accTimeBetweenRandomEvents = 0
    end

    for _, button in ipairs(self.buttonList) do
      button:accumulate(dt)
    end

    dbg:msg("---------------------------", "")
    dbg:msg("roomPanic", roomPanic)
    dbg:msg("roomAwkwardness", roomAwkwardness)

    SoundMusic:update(dt, roomPanic, roomAwkwardness)
end

function Game:startIdleLoop()
  if not elevator.moving then
    if elevator.y == -1000 then
      elevator.y = 1000
      elevator:moveTo(0)
      elevator.justMoved = true
      self:removeCharacters()
    elseif elevator.y == 0 and elevator.justMoved then
      GUI:layerVisible("enter", true)
      self.startIdleTime = 0
      elevator.justMoved = false
      self:createCharacters()
    elseif elevator.y == 0 then
      GUI:layerVisible("enter", false)
      elevator:moveTo(-1000)
    end
  end
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

function Game:flickerLights()
  print("flickering")
end

return Game
