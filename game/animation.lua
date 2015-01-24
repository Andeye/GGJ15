AnimationPrms = {
  }

Animation = {
  spriteSheet = nil,
  spriteMatrix = nil,
  currentQuadIndex = 1,
  currentFaceIndex = 1,
  currentTime = 0,
  scale = 1
}
Animation.__index = Animation


function Animation:new(spriteSheetImage, spriteMatrix, scale)
  local self = setmetatable({}, Animation)

  self.spriteSheet = spriteSheetImage
  self.spriteMatrix = spriteMatrix
  self.scale = scale or self.scale

  return self
end


function Animation:update(dt, spriteDuration, awkwardness)

  self.currentTime = self.currentTime + dt * 1000

  self.currentFaceIndex = math.floor(awkwardness / 100 * #self.spriteMatrix) + 1
  if self.currentFaceIndex > #self.spriteMatrix then
    self.currentFaceIndex = #self.spriteMatrix
  end

  if self.currentTime > spriteDuration then
    self.currentTime = self.currentTime - spriteDuration
    self.currentQuadIndex = self.currentQuadIndex + 1
    if self.currentQuadIndex > #self.spriteMatrix[self.currentFaceIndex] then
      self.currentQuadIndex = 1
    end
  end

end


function Animation:draw(x, y)
  love.graphics.draw(self.spriteSheet, self.spriteMatrix[self.currentFaceIndex][self.currentQuadIndex], x, y, 0, self.scale)
end
