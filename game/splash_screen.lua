SplashScreen = {
  started = false,
  SHOW_SPLASH_SCREEN_TIME = 3,
  accumulatedTime = 0,
}
SplashScreen.__index = SplashScreen

function SplashScreen:new(o)
  local self = setmetatable(o or {}, SplashScreen)
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
  love.graphics.rectangle("fill", 100, 100, love.window:getWidth() - 200, love.window:getHeight() - 200)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("loading...", 150, 150)
end








