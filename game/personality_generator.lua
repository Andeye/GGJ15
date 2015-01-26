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

local VALUE_RANGE = 4

local skinColorChain = {13, 7, 4, 3}
local index = 0

function PersonalityGenerator:createPersonality(reactToEvent)
  local personality = {
    eventTypeMap = {}
  }

--  local index = math.random(1, #colors)
  index = (index % 4) + 1
  personality.color = colors[skinColorChain[index]]

  personality.reactToEvent = reactToEvent or function(self, event)

      if self.eventTypeMap[event.type] == nil then
        local p, a = VALUE_RANGE * math.random() - VALUE_RANGE / 2, VALUE_RANGE * math.random() - VALUE_RANGE / 2
        self.eventTypeMap[event.type] = {p = p, a = a}
      end

      local panic = self.eventTypeMap[event.type].p * event:getPanicValue()
      local awkward = self.eventTypeMap[event.type].a * event:getAwkwardValue()

      return panic, awkward
  end

  return personality
end


return PersonalityGenerator
