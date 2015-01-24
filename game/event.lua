EventPrms = {
  }

Event = {
  type = nil,
  panicValue = 5,
  awkwardValue = 5,
}
Event.__index = Event


function Event:new(type, panicValue, awkwardValue, o)
  local self = setmetatable(o or {}, Event)

  self.type = type
  if panicValue ~= nil and awkwardValue == nil then
    self.panicValue = panicValue
    self.awkwardValue = panicValue
  end

  self.panicValue = panicValue
  self.awkwardValue = awkwardValue or self.awkwardValue

  return self
end


function Event:getPanicValue()
  return self.panicValue
end


function Event:getAwkwardValue()
  return self.awkwardValue
end
