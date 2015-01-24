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
  personality = nil,
  tween,
}
Character.__index = Character


function Character:new(x, y, personality)
  local self = setmetatable({}, Character)

  self.animations = {}
  self.x = x or self.x
  self.y = y or self.y

  self.personality = personality

  self.image = CharacterPrms.image
  self.scale = love.window:getHeight() / self.image:getHeight() / 2

  return self
end


function Character:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
end

function Character:moveTo(x, y)
  self.tween = tween.new(3, self, {x=x, y=y})
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

  if self.tween then
    self.tween:update(dt)
  end

  dbg:msg("character.awkward", self.awkward)
  dbg:msg("character.panic", self.panic)
end


function Character:draw()
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(self.personality.color)
  self.animations[self.currentAnimationKey]:draw(self.x, self.y)
  love.graphics.setColor(r, g, b)
end


function Character:addAnimation(key, animation)
  self.animations[key] = animation
  if self.currentAnimationKey == nil then
    self.currentAnimationKey = key
  end
end


function Character:getPanic()
  return self.panic
end


function Character:getAwkward()
  return self.awkward
end


function Character:event(o)
  if o.sender == self then
    return
  end

  -- TODO: fix this function pointer in personality
  local p, a = self.personality.reactToEvent(o)

  self:addAwkwardness(a)
  self:addPanic(p)
end

function Character:getY()
  return self.y
end
