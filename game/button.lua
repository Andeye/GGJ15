Button = {
  width=200,
  height=50,
  imageUp = {
    [false] = love.graphics.newImage("assets/graphics/buttons/placeholderout.png"),
    [true] = love.graphics.newImage("assets/graphics/buttons/buttonlightfullout.png")
  },
  imageDown = {
    [false] = love.graphics.newImage("assets/graphics/buttons/placeholderin.png"),
    [true] = love.graphics.newImage("assets/graphics/buttons/buttonlightfullin.png")
  },
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
  self.litUp = false
	if self.imageUp then
    self.image = self.imageUp
    local img = self.image[self.litUp]
    self.imgScl = self.height / img:getHeight()
    self.textX = self.x + img:getHeight() * self.imgScl * 1.4 + (self.width / 2 - img:getHeight() * self.imgScl) - love.graphics.getFont():getWidth(self.text) / 2
    self.textY = self.y + img:getHeight() / 2 * self.imgScl - love.graphics.getFont():getHeight() / 2
	end
	return self
end

function Button:draw()
	if self.image then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.image[self.litUp], self.x, self.y, 0, self.imgScl)
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


function Button:setLitUp(bool)
  self.litUp = bool
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
  SoundSfx:play("button_click")
  self:setImageDown()
end

function Button:mousereleased()
  SoundSfx:play("button_release")
  self:setImageUp()
end

function Button:onDragDrop(draggable)
end
