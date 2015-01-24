AnimationParser = {}


local COLUMNS = 9
local ROWS = 4


---
-- Kind of outdated
function AnimationParser:parse(image, numberOfRows, numberOfSprites, row)
  local quadWidth = image:getWidth() / numberOfSprites
  local quadHeight = image:getHeight() / numberOfRows

  local scale = love.window:getHeight() / quadHeight / 2

  local quadArray = {}
  for i = 1, numberOfSprites do
    quadArray[i] = love.graphics.newQuad((i - 1) * quadWidth, (row - 1) * quadHeight, quadWidth, quadHeight, image:getDimensions())
  end

  return quadArray, scale
end


function AnimationParser:parseCharacter(image)
  local quadWidth = image:getWidth() / COLUMNS
  local quadHeight = image:getHeight() / ROWS

  local scale = love.window:getHeight() / quadHeight / 2

  local walkAnimationMatrix = {}
  local panicAnimationMatrix = {}

  for faceIndex = 1, ROWS do

    walkAnimationMatrix[faceIndex] = {}
    for k = 1, 4 do
      walkAnimationMatrix[faceIndex][k] = love.graphics.newQuad((k - 1) * quadWidth, (faceIndex - 1) * quadHeight, quadWidth, quadHeight, image:getDimensions())
    end

    panicAnimationMatrix[faceIndex] = {}
    for k = 5, 9  do
      panicAnimationMatrix[faceIndex][k - 4] = love.graphics.newQuad((k - 1) * quadWidth, (faceIndex - 1) * quadHeight, quadWidth, quadHeight, image:getDimensions())
    end

  end

  return walkAnimationMatrix, panicAnimationMatrix, scale
end


return AnimationParser
