CharacterPrms = {}

Character = {
  animations = nil,
  specialAnimations = nil,
  currentAnimationKey = nil,
  currentSpecialAnimationKey = nil,
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
  self.specialAnimations = {}
  self.x = x or self.x
  self.y = y or self.y
  self.personality = personality
  self.currentAnimationKey = "panic"

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

---
-- http://www.wolframalpha.com/input/?i=plot%28.1975+*+x%5E2+-+39.55+*+x%2B+2000%2C+from+0+to+100%29
function getPanicSpriteDuration(panic)
  return .1975 * panic^2 - 39.55 * panic + 2000
end


function Character:update(dt)

  local panicSpriteDuration = getPanicSpriteDuration(self.panic)
  self.animations[self.currentAnimationKey]:update(dt, panicSpriteDuration, self.awkward)

  if self.tween then
    self.tween:update(dt)
  end

  dbg:msg("-----------------------------------", "")
  dbg:msg("character.awkward", self.awkward)
  dbg:msg("character.panic", self.panic)
end


function Character:draw()
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(self.personality.color)
  self.animations[self.currentAnimationKey]:draw(self.x, self.y, self.isMirrored)
  love.graphics.setColor(r, g, b)
end


function Character:addAnimation(key, animation)
  self.animations[key] = animation
  if self.currentAnimationKey == nil then
    self.currentAnimationKey = key
  end
end


function Character:addSpecialAnimation(key, animation)
  self.specialAnimations[key] = animation
  if self.currentSpecialAnimationKey == nil then
    self.currentSpecialAnimationKey = key
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
  local p, a = self.personality:reactToEvent(o)

  self:addAwkwardness(a)
  self:addPanic(p)
end

function Character:getY()
  return self.y
end

function Character:mirror()
  self.isMirrored = not self.isMirrored
end
