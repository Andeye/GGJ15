EventPrms = {
}

Event = {
  type = "default",
  panicValue = 5,
  awkwardValue = 5,
}
Event.__index = Event


function Event:new(panicValue, awkwardValue, o)
  local self = setmetatable(o or {}, Event)
  
  self.panicValue = panicValue or self.panicValue
  self.awkwardValue = awkwardValue or self.awkwardValue
  
  return self
end


function Event:getPanicValue()
  return self.panicValue
end


function Event:getAwkwardValue()
  return self.awkwardValue
end