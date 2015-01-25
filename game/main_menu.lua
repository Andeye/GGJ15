MainMenu = {
  SPACE_BETWEEN_UP_DOWN_ARROWS = 15,
  ARROW_OFFSET_Y = 50,
  timer = 0,
}
MainMenu.__index = MainMenu

function MainMenu:new()
  local self = setmetatable({}, MainMenu)

  self.background = {}
  self.buttons = {}

  self.background.image = love.graphics.newImage("assets/graphics/main_menu/startscreenbgmedium.png")
  self.background.scale = love.window:getHeight() / self.background.image:getHeight()
  self.background.x = (love.window:getWidth() - self.background.image:getWidth() * self.background.scale) / 2

  self.buttons.background = love.graphics.newImage("assets/graphics/main_menu/titlepanel.png")
  self.buttons.scale = love.window:getHeight() / self.buttons.background:getHeight() * 0.9
  self.buttons.backgroundX = (love.window:getWidth() - self.buttons.background:getWidth() * self.buttons.scale) / 2
  self.buttons.backgroundY = (love.window:getHeight() - self.buttons.background:getHeight() * self.buttons.scale) / 2

  self.buttons.downNormal = love.graphics.newImage("assets/graphics/main_menu/buttons/downnormal.png")
  self.buttons.downLight = love.graphics.newImage("assets/graphics/main_menu/buttons/downlight.png")
  self.buttons.downHover = love.graphics.newImage("assets/graphics/main_menu/buttons/downhover.png")

  self.buttons.upNormal = love.graphics.newImage("assets/graphics/main_menu/buttons/upnormal.png")
  self.buttons.upLight = love.graphics.newImage("assets/graphics/main_menu/buttons/uplight.png")
  self.buttons.upHover = love.graphics.newImage("assets/graphics/main_menu/buttons/uphover.png")

  self.buttons.startText = {}
  self.buttons.startText.image = love.graphics.newImage("assets/graphics/main_menu/buttons/startbutton.png")
  self.buttons.startText.x = (love.window:getWidth() - self.buttons.startText.image:getWidth() * self.buttons.scale) / 2
  self.buttons.startText.y = 200

  local buttonX = (love.window:getWidth() - self.buttons.upNormal:getWidth() * self.buttons.scale) / 2
  local buttonY = love.window:getHeight() / 2 - self.buttons.upNormal:getHeight() * self.buttons.scale + self.ARROW_OFFSET_Y
  self.buttons.start = {
    image = self.buttons.upNormal,
    pressed = false,
    x = buttonX,
    y = buttonY
  }

  buttonX = (love.window:getWidth() - self.buttons.downNormal:getWidth() * self.buttons.scale) / 2
  buttonY = love.window:getHeight() / 2 + self.SPACE_BETWEEN_UP_DOWN_ARROWS + self.ARROW_OFFSET_Y
  self.buttons.quit = {
    image = self.buttons.downNormal,
    pressed = false,
    x = buttonX,
    y = buttonY
  }

  return self
end

local function startGame(self)
  GameState:pop()
  GameState:push("splashScreen")
  GUI:layerVisible("main_menu_gui", false)
  local screenDumpData = love.graphics.newScreenshot()

  splashScreen:setBackground(screenDumpData, self.buttons.scale, self.buttons.startText.x, self.buttons.startText.y)
end

local function quitGame(self)
  love.event.quit()
end

local function gameCredits(self)

end

local function isMouseInsideImage(button)
  local mouseX, mouseY = love.mouse.getPosition()
  return mouseX >= button.x and mouseX < button.x + button.image:getWidth() and mouseY >= button.y and mouseY < button.y + button.image:getHeight()
end

local function checkButtonUp(self, button)
  if isMouseInsideImage(button) then
    if love.mouse.isDown("l") then
      button.image = self.buttons.upLight
      button.pressed = true
    else
      if not button.pressed then
        button.image = self.buttons.upHover
      end
    end
  else
    if not button.pressed then
      button.image = self.buttons.upNormal
    end
  end
end

local function checkButtonDown(self, button)
  if isMouseInsideImage(button) then
    if love.mouse.isDown("l") then
      button.image = self.buttons.downLight
      button.pressed = true
    else
      if not button.pressed then
        button.image = self.buttons.downHover
      end
    end
  else
    if not button.pressed then
      button.image = self.buttons.downNormal
    end
  end
end

function MainMenu:update(dt)
  checkButtonUp(self, self.buttons.start)
  checkButtonDown(self, self.buttons.quit)

  if self.buttons.quit.pressed then
    self.timer = self.timer + dt
    if self.timer >= 0.5 then
      quitGame(self)
    end
  end

  if self.buttons.start.pressed then
    self.timer = self.timer + dt
    if self.timer >= 0.05 then
      startGame(self)
    end
  end

  if love.keyboard.isDown("kp8") then
    startGame(self)
  elseif love.keyboard.isDown("kp5") then
    gameCredits(self)
  elseif love.keyboard.isDown("kp2") then
    quitGame(self)
  end
end

function MainMenu:draw()
  love.graphics.draw(self.background.image, self.background.x, 0, 0, self.background.scale)
  love.graphics.draw(self.buttons.background, self.buttons.backgroundX, self.buttons.backgroundY, 0, self.buttons.scale)
  love.graphics.draw(
    self.buttons.startText.image,
    self.buttons.startText.x,
    self.buttons.startText.y,
    0,
    self.buttons.scale)
  love.graphics.draw(self.buttons.start.image, self.buttons.start.x, self.buttons.start.y, 0, self.buttons.scale)
  love.graphics.draw(self.buttons.quit.image, self.buttons.quit.x, self.buttons.quit.y, 0, self.buttons.scale)
  love.graphics.rectangle("fill", (love.window.getWidth() - 2) / 2, (love.window.getHeight() - 2) / 2, 2, 2)
end
