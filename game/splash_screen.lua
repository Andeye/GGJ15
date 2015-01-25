SplashScreen = {
  started = false,
  SHOW_SPLASH_SCREEN_TIME = 3,
  accumulatedTime = 0,
}
SplashScreen.__index = SplashScreen

function SplashScreen:new(o)
  local self = setmetatable(o or {}, SplashScreen)
  self.foregroundImage = love.graphics.newImage("assets/graphics/main_menu/buttons/loadingbutton.png")
  return self
end

function SplashScreen:update(dt)
  self.accumulatedTime = self.accumulatedTime + dt
  if self.accumulatedTime >= 0.1 and not self.started then
    self.started = true

    love.filesystem.load("game.lua")()
    game = Game:new()

    GameState:add("game", game)
    GameState:pop()
    GameState:push("game")
  end
end

function SplashScreen:draw()
  if self.backgroundImage then
    love.graphics.draw(self.backgroundImage)
    love.graphics.draw(self.foregroundImage, self.loadTextX, self.loadTextY, 0, self.foregroundScale)
  end
end

function SplashScreen:setBackground(imageData, foregroundScale, startButtonX, startButtonY)
  self.backgroundImage = love.graphics.newImage(imageData)
  self.foregroundScale = foregroundScale
  self.loadTextX = startButtonX
  self.loadTextY = startButtonY
end
















