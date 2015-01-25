Button = {
  width=200,
  height=50,
  imageUp=love.graphics.newImage("assets/graphics/placeholderout.png"),
  imageDown=love.graphics.newImage("assets/graphics/placeholderin.png"),
}
Button.__index = Button
function Button:new(o)
	local self = setmetatable(o or {}, Button)
	self.border = self.border or 0
	self.shape = {
					[1] = {x = self.x, y = self.y},
					[2] = {x = self.x + self.width, y = self.y},
					[3] = {x = self.x + self.width, y = self.y + self.height},
					[4] = {x = self.x, y = self.y + self.height}
				}
	self.shapeList = convertPointsToList(self.shape)
  self.textX = self.x
  self.textY = self.y
	if self.imageUp then
    self.image = self.imageUp
    self.imgScl = self.height / self.image:getHeight()
    self.textX = self.x + self.image:getHeight() * self.imgScl * 1.4 + (self.width / 2 - self.image:getHeight() * self.imgScl) - love.graphics.getFont():getWidth(self.text) / 2
    self.textY = self.y + self.image:getHeight() / 2 * self.imgScl - love.graphics.getFont():getHeight() / 2
	end
	return self
end

function Button:draw()
	if self.image then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.image, self.x, self.y, 0, self.imgScl)
	else
		love.graphics.polygon("fill", self.shapeList)
	end
  if self.text then
		love.graphics.setColor(0,0,0)
    love.graphics.print(self.text, self.textX, self.textY)
  end
end

function Button:onClick()
end

function Button:onHover(draggable)
  --[[
  self.hover = true
	if draggable then
	end
  --]]
end

function Button:onBlur(onDrag, draggable)
  --[[
	self.hover = false
	if onDrag then
		--return Draggable:new{image = self.image}
	end
  --]]
end

function Button:setImageUp()
  self.image = self.imageUp
end

function Button:setImageDown()
  self.image = self.imageDown
end

function Button:mousepressed()
  self.image = self.imageDown
end

function Button:mousereleased()
  self.image = self.imageUp
end

function Button:onDragDrop(draggable)
end
