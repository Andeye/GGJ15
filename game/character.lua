CharacterPrms = {
  image = love.graphics.newImage("assets/graphics/gubbskelett.png"),
}

Character = {
  animations = nil,
  currentAnimationKey = nil,
	awkward = 50,
	panic = 50,
	x = 500,
	y = 300,
  color,
	faces = nil,
}
Character.__index = Character


function Character:new(x, y, color)
  local self = setmetatable({}, Character)

  self.animations = {}
  self.faces = {
    quadArray = {},
    index = 1,
    image = {},
    offsetX = 0,
    offsetY = 0,
  }
  self.x = x or self.x
  self.y = y or self.y
  self.color = color or {255, 255, 255}

  self.image = CharacterPrms.image
  self.scale = love.window:getHeight() / self.image:getHeight() / 2

  return self
end


function Character:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
end

function Character:addAwkwardness(da)
  self.awkward = self.awkward + da
  if self.awkward >= 100 then
    self.awkward = 100
  elseif self.awkward <= 0 then
    self.awkward = 0
  end
end

function Character:addPanic(dp)
  self.panic = self.panic + dp
  if self.panic >= 100 then
    self.panic = 100
  elseif self.panic <= 0 then
    self.panic = 0
  end
end


function Character:update(dt)
  self.animations[self.currentAnimationKey]:update(dt)

  self.faces.index = math.floor(self.awkward / 100 * (#self.faces.quadArray - 1)) + 2
  if self.faces.index > #self.faces.quadArray then
    self.faces.index = #self.faces.quadArray
  end

  dbg:msg("faceIndex", self.faces.index)
  dbg:msg("character.awkward", self.awkward)
  dbg:msg("character.panic", self.panic)
end


function Character:draw()
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(self.color)
  self.animations[self.currentAnimationKey]:draw(self.x, self.y)
  love.graphics.draw(self.faces.image, self.faces.quadArray[self.faces.index], self.x + self.faces.offsetX, self.y + self.faces.offsetY, 0, 0.12)
  --  love.graphics.draw(self.image, (love.window:getWidth() - self.image:getWidth()*self.scale) / 2, 200, 0, self.scale)
  love.graphics.setColor(r, g, b)
end


function Character:addAnimation(key, animation)
  self.animations[key] = animation
  if self.currentAnimationKey == nil then
    self.currentAnimationKey = key
  end
end


function Character:setFaces(faceImage, quadArray, offsetX, offsetY)
  self.faces.image = faceImage
  self.faces.quadArray = quadArray
  self.faces.index = 2
  self.faces.offsetX = offsetX or self.faces.offsetX
  self.faces.offsetY = offsetY or self.faces.offsetY
end


function Character:getPanic()
  return self.panic
end


function Character:getAwkward()
  return self.awkward
end


function Character:event(o)
  if o.type == "awkward" then
  --
  elseif o.name == "dance" then
  --
  else
    self.awkard = self.awkward + o.awkward
    self.panic = self.panic + o.panic
  end
end

function Character:getY()
  return self.y
end
