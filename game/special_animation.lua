
SpecialAnimation = {
  spriteSheet = nil,
  spriteMask = nil,
  spriteArray = nil,
  quadWidth = nil,
  currentQuadIndex = nil,
  currentTime = 0,
  scale = 1,
  duration = nil,
  loopsLeft = nil,
}
SpecialAnimation.__index = SpecialAnimation


function SpecialAnimation:new(spriteSheetImage, spriteSheetMask, spriteArray, scale, quadWidth, duration)
  local self = setmetatable({}, SpecialAnimation)

  self.spriteSheet = spriteSheetImage
  self.spriteMask = spriteSheetMask
  self.spriteArray = spriteArray
  self.scale = scale or self.scale
  self.quadWidth = quadWidth
  self.duration = duration

  return self
end


function SpecialAnimation:play(times)
  self.currentQuadIndex = 1
  self.currentTime = 0
  self.loopsLeft = times or 1
end


function SpecialAnimation:isPlaying()
  return self.currentQuadIndex ~= nil and self.currentQuadIndex <= #self.spriteArray
end


function SpecialAnimation:update(dt, spriteDuration, awkwardness)

  if not self:isPlaying() then
    return
  end

  self.currentTime = self.currentTime + dt * 1000

  if self.currentTime > self.duration then
    self.currentTime = self.currentTime - self.duration
    self.currentQuadIndex = self.currentQuadIndex + 1
    if self.currentQuadIndex > #self.spriteArray then
      if self.loopsLeft > 1 then
        self.loopsLeft = self.loopsLeft - 1
        self.currentQuadIndex = 1
      else
        self.currentQuadIndex = nil
      end
    end
  end

end


function SpecialAnimation:draw(x, y, isMirrored)
  if self.spriteMask ~= nil then
    game.skinColorShader:send("skinMask", self.spriteMask)
  end
  if not isMirrored then
    love.graphics.draw(self.spriteSheet, self.spriteArray[self.currentQuadIndex], x, y, 0, self.scale)
  else
    love.graphics.draw(self.spriteSheet, self.spriteArray[self.currentQuadIndex], x + self.quadWidth / 2, y, 0, -self.scale, self.scale)
  end
end
