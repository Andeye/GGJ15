EventTypes = {}

local EventType = {}

EventType["dance"] = {
  panicSign = -1,     -- People AREN'T going to panic by dancing by default
  awkwardSign = 1,    -- People ARE going to get awkward by dancing by default
  callback = nil,
}
EventType["fart"] = {
  panicSign = 1,
  awkwardSign = 1,
  callback = function() SoundSfx:play("fart_male_" .. math.random(1, 3)) end
}
EventType["wave"] = {
  panicSign = -1,
  awkwardSign = 1,
  callback = nil,
}
EventType["flirt"] = {
  panicSign = 1,
  awkwardSign = -1,
  callback = nil,
}
EventType["calm_down"] = {
  panicSign = -1,
  awkwardSign = -1,
  callback = nil,
}
EventType["tell_joke"] = {
  panicSign = -1,
  awkwardSign = 1,
  callback = nil,
}
EventType["irritate"] = {
  panicSign = 1,
  awkwardSign = 1,
  callback = nil,
}
EventType["scream"] = {
  panicSign = 1,
  awkwardSign = -1,
  callback = function()
    if math.random(1, 2) == 1 then
      SoundSfx:play("scream_male_" .. math.random(1, 3))
    else
      SoundSfx:play("scream_female_" .. math.random(1, 3))
    end
  end,
}
EventType["chuckle"] = {
  panicSign = 1,
  awkwardSign = -1,
  callback = function()
    SoundSfx:play("chuckle_male_" .. math.random(1, 3))
  end,
}
EventType["light_flickering"] = {
  panicSign = 1,
  awkwardSign = -1,
  callback = function()
    game:flickerLights()
  end,
}

-- Allowed types for random environmental events
local randomTypes = {"fart", "scream", "light_flickering", "chuckle"}

function EventTypes:getRandomEvent(sender, filter)
  local tempRandomTypes = {}
  for k, v in ipairs(randomTypes) do
    if v == "scream" and not filter.canScream then
    elseif v == "chuckle" and not filter.canChuckle then
    else
      tempRandomTypes[k] = v
    end
  end

  dbg:msg("temp", dbg:serialize(tempRandomTypes))

  return self:getEvent(sender, tempRandomTypes[math.random(1, #tempRandomTypes)])
end

function EventTypes:getEvent(sender, type, callback)
  if sender == nil or type == nil then
    error("Can't use events without sender")
  end

  local eventType = EventType[type]

  if eventType == nil then
    error("Unrecognized event type: " .. dbg:serialize(type))
  end

  local panicValue = math.random(0, 10) * eventType.panicSign
  local awkwardValue = math.random(0, 10) * eventType.awkwardSign

  if callback then
    eventType.callback = callback
  end

  return Event:new(sender, type, eventType.callback, panicValue, awkwardValue)
end


function EventTypes.getType(key)
  return EventType[key]
end


return EventTypes
