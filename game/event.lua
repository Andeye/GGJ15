EventPrms = {
  }

Event = {
  sender = nil,
  type = nil,
  panicValue = 5,
  awkwardValue = 5,
}
Event.__index = Event


---
-- sender is the object that triggered the event
-- 
function Event:new(sender, type, panicValue, awkwardValue)
  local self = setmetatable({}, Event)

  self.sender = sender
  self.type = type
  
  if panicValue ~= nil and awkwardValue == nil then
    self.panicValue = panicValue
    self.awkwardValue = panicValue
  end

  self.panicValue = panicValue or self.panicValue
  self.awkwardValue = awkwardValue or self.awkwardValue

  print("--------------------------")
  print("event.sender       = " .. dbg:serialize(self.sender))
  print("event.type         = " .. self.type)
  print("event.panicValue   = " .. self.panicValue)
  print("event.awkwardValue = " .. self.awkwardValue)
  print("--------------------------")
    
  return self
end


function Event:getPanicValue()
  return self.panicValue
end


function Event:getAwkwardValue()
  return self.awkwardValue
end

return Event