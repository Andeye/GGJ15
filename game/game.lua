GamePrms = {
	size = 25,
}
pxlScl = love.window.getPixelScale()
-- pxlScl = 3


Game = {
}
Game.__index = Game


function Game:new()
	local self = setmetatable({}, Game)
	self.hover = false
	
	return self
end

function Game:update(dt)
	dbg:msg("Game ID", tostring(self.selected))

end

function Game:draw()
end
