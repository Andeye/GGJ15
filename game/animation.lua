AnimationPrms = {
}

Animation = {
  spriteSheet = nil,
  quadArray = nil,
  timeArray = nil,
  currentQuadIndex = 1,
  currentTime = 0,
  scale = 1
}
Animation.__index = Animation


---
-- The quad array and the duration array must be the same length!
function Animation:new(spriteSheetImage, spriteQuadArray, durationArray, scale)
  local self = setmetatable({}, Animation)
  
  self.spriteSheet = spriteSheetImage
  self.quadArray = spriteQuadArray
  self.timeArray = durationArray 
  self.scale = scale or self.scale
    
  return self
end


function Animation:update(dt)
  self.currentTime = self.currentTime + dt * 1000
  
  if self.currentTime > self.timeArray[self.currentQuadIndex] then
    self.currentTime = self.currentTime - self.timeArray[self.currentQuadIndex]
    self.currentQuadIndex = self.currentQuadIndex + 1
    if self.currentQuadIndex > #self.quadArray then
      self.currentQuadIndex = 1
    end
  end
  
end


function Animation:draw(x, y)
  love.graphics.draw(self.spriteSheet, self.quadArray[self.currentQuadIndex], x, y, 0, self.scale)
end
