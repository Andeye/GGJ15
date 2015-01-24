AnimationParser = {}


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


return AnimationParser