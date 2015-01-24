EventPrms = {
}

Event = {
}
Event.__index = Event


function Event:new(panicValue, awkwardValue, o)
  local self = setmetatable(o or {}, Event)

  return self
end