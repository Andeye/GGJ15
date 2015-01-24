EventTypes = {}

local EventType = {}

EventType["dance"] = {
  panicSign = -1,     -- People AREN'T going to panic by dancing by default
  awkwardSign = 1     -- People ARE going to get awkward by dancing by default
}
EventType["fart"] = {
  panicSign = 1,
  awkwardSign = 1
}
EventType["wave"] = {
  panicSign = -1,
  awkwardSign = 1
}
EventType["flirt"] = {
  panicSign = 1,
  awkwardSign = -1
}
EventType["calm_down"] = {
  panicSign = -1,
  awkwardSign = -1
}
EventType["tell_joke"] = {
  panicSign = -1,
  awkwardSign = 1
}
EventType["irritate"] = {
  panicSign = 1,
  awkwardSign = 1
}


function EventTypes:getEvent(sender, type)
  if sender == nil or type == nil then
    error("Can't use events without sender")
  end
  
  print(tostring(type))
  
  local eventType = EventType[type]
  
  if eventType == nil then
    error("Unrecognized event type: " .. dbg:serialize(type))
  end
  
  local panicValue = math.random(0, 10) * eventType.panicSign
  local awkwardValue = math.random(0, 10) * eventType.awkwardSign
  
  return Event:new(sender, type, panicValue, awkwardValue)
end


function EventTypes.getType(key)
  return EventType[key]
end


return EventTypes