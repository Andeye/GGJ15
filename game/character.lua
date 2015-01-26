CharacterPrms = {}

Character = {
  animations = nil,
  specialAnimations = nil,
  currentAnimationKey = nil,
  currentSpecialAnimationKey = nil,
  awkward = 10,
  panic = 10,
  x = 500,
  y = 300,
  z = 1000,
  inElevator = true,
  personality = nil,
  tween,
}
Character.__index = Character


function Character:new(x, y, personality)
  local self = setmetatable({}, Character)

  self.animations = {}
  self.specialAnimations = {}
  self.awkward = math.random() * self.awkward
  self.panic = math.random() * self.panic
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

function Character:moveTo(x, y, z, length)
  length = length or 3
  self.tween = tween.new(length, self, {x=x, y=y, z=z})
  self.currentAnimationKey = "walk"
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


function Character:playAnimation(key)
  if self.animations[key] ~= nil then
    self.currentAnimationKey = key
  end
end


function Character:isSpecialAnimationPlaying()
  local key = self.currentSpecialAnimationKey
  return key ~= nil and self.specialAnimations[key]:isPlaying()
end


function Character:playSpecialAnimation(key, times)
  if not self:isSpecialAnimationPlaying() and self.specialAnimations[key] ~= nil then
    self.currentSpecialAnimationKey = key
    self.specialAnimations[key]:play(times)
  end
end


function Character:update(dt)

  if self:isSpecialAnimationPlaying() then
    local key = self.currentSpecialAnimationKey
    self.specialAnimations[key]:update(dt)
    if not self.specialAnimations[key]:isPlaying() then
      self.currentSpecialAnimationKey = nil
    end
  else
    local panicSpriteDuration = getPanicSpriteDuration(self.panic)
    self.animations[self.currentAnimationKey]:update(dt, panicSpriteDuration, self.awkward)
  end


  if self.tween then
    if self.tween:update(dt) then
      if self.animations["idle"] ~= nil then
        self.currentAnimationKey = "idle"
      else
        self.currentAnimationKey = "panic"
      end
      if self.isMirrored then
        self:mirror()
      end
    end
  end

--  dbg:msg("-----------------------------------", "")
--  dbg:msg("currentAnimationKey", self.currentAnimationKey)
--  dbg:msg("-----------------------------------", "")
--  dbg:msg("character.awkward", self.awkward)
--  dbg:msg("character.panic", self.panic)
  
end


function Character:draw()
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(self.personality.color)
  love.graphics.setShader(game.skinColorShader)
  local elevatorY = 0
  if self.inElevator then
    elevatorY = elevator.y
  end
  if self:isSpecialAnimationPlaying() then
    self.specialAnimations[self.currentSpecialAnimationKey]:draw(self.x, self.y + elevatorY, self.isMirrored)
  else
    self.animations[self.currentAnimationKey]:draw(self.x, self.y + elevatorY, self.isMirrored)
  end
  love.graphics.setShader()
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

  local p, a = self.personality:reactToEvent(o)

  self:addAwkwardness(a)
  self:addPanic(p)
end

function Character:getZ()
  return self.y + self.z
end

function Character:mirror()
  self.isMirrored = not self.isMirrored
end
