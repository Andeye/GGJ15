
require("external/livecode/livecode")
tween = require("external/tween/tween")

love.filesystem.load("dbg.lua")()
dbg = Debug:new()
love.filesystem.load("gamestate.lua")()
love.filesystem.load("gui.lua")()
love.filesystem.load("game.lua")()
love.filesystem.load("game_finished.lua")()
love.filesystem.load("button.lua")()
love.filesystem.load("utility.lua")()

function love.livereload()
  -- love.load()
end

function love.load()
  print("Resetting")
  GameState:new()
  GUI:new()
  
  game = Game:new()
  gameFinished = GameFinished:new()
  
  GameState:add("gameFinished",gameFinished)
  GameState:add("game", game)
  GameState:push("game")
end

function love.update(dt)
  GameState:update(dt)
  GUI:update(dt)
end

function love.draw()
  GameState:draw()
  GUI:draw()

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("FPS: "..love.timer.getFPS()..dbg:out(), 10, 10)
end
