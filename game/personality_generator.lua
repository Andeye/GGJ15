PersonalityGenerator = {}


local colors = {}
colors[1] = {189, 176, 142}
colors[2] = {173, 170, 147}
colors[3] = {213, 183, 158}
colors[4] = {203, 182, 165}
colors[5] = {212, 210, 185}
colors[6] = {216, 193, 150}
colors[7] = {84, 71, 50}
colors[9] = {178, 148, 83}
colors[10] = {67, 61, 51}
colors[11] = {161, 140, 107}
colors[12] = {144, 96, 58}
colors[13] = {178, 131, 83}


function PersonalityGenerator:createPersonality()
  local personality = {}

  local index = math.random(1, #colors)
  personality.color = colors[index]

  return personality
end


return PersonalityGenerator
