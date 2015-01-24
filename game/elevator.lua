ElevatorPrms = {
  elevatorForground = love.graphics.newImage("assets/graphics/elevator/placeholder-fix.png"),
  elevatorImage = love.graphics.newImage("assets/graphics/elevator/elevator-nodoor.png"),
  leftImage = love.graphics.newImage("assets/graphics/elevator/left-door.png"),
  rightImage = love.graphics.newImage("assets/graphics/elevator/right-door.png"),
  x = 0,
  y = 0,
}

local MAX_DOOR_OFFSET = 120
local MIN_DOOR_OFFSET = 0
local DOOR_OFFSET_TIME_FACTOR = 60

local DOOR_STATES = {
  OPENING = 1,
  CLOSING = 2,
  OPEN = 3,
  CLOSED = 4
}


Elevator = {
  doorOffset = MIN_DOOR_OFFSET,
  currentDoorState = DOOR_STATES.CLOSED
}
Elevator.__index = Elevator


function Elevator:new(o)
  local self = setmetatable(o or {}, Elevator)

  self.elevatorImage = ElevatorPrms.elevatorImage
  self.scale = love.window:getHeight() / self.elevatorImage:getHeight()
  self.leftImage = ElevatorPrms.leftImage
  self.rightImage = ElevatorPrms.rightImage
  self.x = (love.window:getWidth() - self.elevatorImage:getWidth() * self.scale) / 2
  self.y = ElevatorPrms.y

  return self
end


local function updateOpenDoors(self, dt)
  self.doorOffset = self.doorOffset + dt * DOOR_OFFSET_TIME_FACTOR
  if self.doorOffset >= MAX_DOOR_OFFSET then
    self.doorOffset = MAX_DOOR_OFFSET
    self.currentDoorState = DOOR_STATES.OPEN
  end
end


local function updateCloseDoors(self, dt)
  self.doorOffset = self.doorOffset - dt * DOOR_OFFSET_TIME_FACTOR
  if self.doorOffset <= MIN_DOOR_OFFSET then
    self.doorOffset = MIN_DOOR_OFFSET
    self.currentDoorState = DOOR_STATES.CLOSED
  end
end


function Elevator:openDoors()
  self.currentDoorState = DOOR_STATES.OPENING
end

function Elevator:closeDoors()
  self.currentDoorState = DOOR_STATES.CLOSING
end


function Elevator:update(dt)
  dbg:msg("doorOffset", self.doorOffset)
  dbg:msg("doorState", self.currentDoorState)

  if self.currentDoorState == DOOR_STATES.OPENING then
    updateOpenDoors(self, dt)
  elseif self.currentDoorState == DOOR_STATES.CLOSING then
    updateCloseDoors(self, dt)
  end

end


function Elevator:draw()
  love.graphics.draw(self.leftImage, self.x - self.doorOffset, self.y + 0.47 * self.doorOffset, 0, self.scale)
  love.graphics.draw(self.rightImage, self.x + self.doorOffset, self.y - 0.47 * self.doorOffset, 0, self.scale)
  love.graphics.draw(self.elevatorImage, self.x, self.y, 0, self.scale)
  love.graphics.draw(ElevatorPrms.elevatorForground, self.x, self.y, 0, self.scale)
end
