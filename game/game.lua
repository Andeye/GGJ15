GamePrms = {
	size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3

love.filesystem.load("character.lua")()

Game = {
}
Game.__index = Game


function Game:new()
	local self = setmetatable({}, Game)
	self.hover = false
	
	local test = Character:new()
	
	return self
end

function Game:update(dt)
	dbg:msg("Game ID", tostring(self.selected))

end

function Game:draw()
end
