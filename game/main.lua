
require("External/livecode/livecode")

love.filesystem.load("dbg.lua")()
dbg = Debug:new()
love.filesystem.load("gamestate.lua")()
love.filesystem.load("gui.lua")()
love.filesystem.load("object.lua")()
love.filesystem.load("game.lua")()

function love.livereload()
	love.load()
end

function love.load()
	GameState:new()
	GUI:new()
	game = Game:new()
	GameState:add("game", game)
	GameState:push("game")
	print(dbg:serialize(game))
end

function love.update(dt)
	GameState:update(dt)
	GUI:update(dt)
end

function love.draw()
	GameState:draw()
	GUI:draw()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end
