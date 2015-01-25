AnimationPrms = {
  }

Animation = {
  spriteSheet = nil,
  spriteMatrix = nil,
  quadWidth = 0,
  currentQuadIndex = 1,
  currentFaceIndex = 1,
  currentTime = 0,
  scale = 1,
}
Animation.__index = Animation


function Animation:new(spriteSheetImage, spriteMatrix, scale, quadWidth)
  local self = setmetatable({}, Animation)

  self.spriteSheet = spriteSheetImage
  self.spriteMatrix = spriteMatrix
  self.scale = scale or self.scale
  self.quadWidth = quadWidth

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


function Animation:draw(x, y, isMirrored)
  if not isMirrored then
    love.graphics.draw(self.spriteSheet, self.spriteMatrix[self.currentFaceIndex][self.currentQuadIndex], x, y, 0, self.scale)
  else
    love.graphics.draw(self.spriteSheet, self.spriteMatrix[self.currentFaceIndex][self.currentQuadIndex], x + self.quadWidth / 2, y, 0, -self.scale, self.scale)
  end
end
