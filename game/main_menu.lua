MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu:new()
  local self = setmetatable({}, MainMenu)

  self.background = {}
  self.buttons = {}

  self.background.image = love.graphics.newImage("assets/graphics/main_menu/startscreenbgmedium.png")
  self.background.scale = love.window:getHeight() / self.background.image:getHeight()
  self.background.x = (love.window:getWidth() - self.background.image:getWidth() * self.background.scale) / 2

  self.buttons.background = love.graphics.newImage("assets/graphics/main_menu/startscreenpanel.png")
  self.buttons.scale = love.window:getHeight() / self.buttons.background:getHeight()
  self.buttons.backgroundX = (love.window:getWidth() - self.buttons.background:getWidth() * self.buttons.scale) / 2

  self.buttons.downNormal = love.graphics.newImage("assets/graphics/main_menu/buttons/downnormal.png")
  self.buttons.downLight = love.graphics.newImage("assets/graphics/main_menu/buttons/downlight.png")
  self.buttons.downHover = love.graphics.newImage("assets/graphics/main_menu/buttons/downhover.png")

  self.buttons.upNormal = love.graphics.newImage("assets/graphics/main_menu/buttons/upnormal.png")
  self.buttons.upLight = love.graphics.newImage("assets/graphics/main_menu/buttons/uplight.png")
  self.buttons.upHover = love.graphics.newImage("assets/graphics/main_menu/buttons/uphover.png")

  -- Create buttons

  self.buttonList = {}

  local startButton = Button:new{
    x = 0,
    y = 0,
    text = "Start",
    onClick = function()
      print("start game")
    end,
    imageUp = self.buttons.upNormal,
    imageDown = self.buttons.downNormal,
  }

  table.insert(self.buttonList, startButton)

  GUI:addLayer("main_menu_gui", true)
  GUI:addComponent(startButton, "main_menu_gui")

  return self
end

local function startGame()
  GameState:pop()
  GameState:push("splashScreen")
end

local function quitGame()
  love.event.quit()
end

local function gameCredits()

end

function MainMenu:update(dt)
  if love.keyboard.isDown("kp8") then
    startGame()
  elseif love.keyboard.isDown("kp5") then
    gameCredits()
  elseif love.keyboard.isDown("kp2") then
    quitGame()
  end
end

function MainMenu:draw()
  --  love.graphics.setColor(200, 39, 0)
  --  love.graphics.rectangle("fill", 100, 100, love.window:getWidth() - 200, love.window:getHeight() - 200)
  love.graphics.draw(self.background.image, self.background.x, 0, 0, self.background.scale)
  love.graphics.draw(self.buttons.background, self.buttons.backgroundX, 0, 0, self.buttons.scale)
  --  love.graphics.setColor(0, 0, 0)
  --  love.graphics.print("Main Menu", 120, 120)
end
