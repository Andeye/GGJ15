
-- require("external/livecode/livecode")
tween = require("external/tween/tween")

love.filesystem.load("dbg.lua")()
-- dbg = Debug:new()
dbg = Debug_dummy
love.filesystem.load("gamestate.lua")()
love.filesystem.load("gui.lua")()
love.filesystem.load("main_menu.lua")()
love.filesystem.load("splash_screen.lua")()
love.filesystem.load("button.lua")()
love.filesystem.load("utility.lua")()


function love.livereload()
  love.load()
end

function love.load()
  print("Resetting")
  GameState:new()
  GUI:new()

  pxlScl = love.window.getPixelScale()

  splashScreen = SplashScreen:new()
  GameState:add("splashScreen", splashScreen)
  
  mainMenu = MainMenu:new()
  GameState:add("mainMenu", mainMenu)
--  gameFinished = GameFinished:new()
--  GameState:add("gameFinished", gameFinished)
  GameState:push("mainMenu")
end

function love.update(dt)
  if dt > 1/15 then dt = 1/15 end -- simple fps correction
  GameState:update(dt)
  GUI:update(dt)
end

function love.draw()
  GameState:draw()
  GUI:draw()

  love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.print("FPS: "..love.timer.getFPS()..dbg:out(), 10, 10)
end
