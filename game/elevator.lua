ElevatorPrms = {
  elevatorForground = love.graphics.newImage("assets/graphics/elevator/placeholder-fix.png"),
  elevatorFloor = love.graphics.newImage("assets/graphics/elevator/floorandwall.png"),
  elevatorDoorwall = love.graphics.newImage("assets/graphics/elevator/doorwall.png"),
  leftImage = love.graphics.newImage("assets/graphics/elevator/leftdoor.png"),
  rightImage = love.graphics.newImage("assets/graphics/elevator/rightdoor.png"),
  x = 0,
  y = 1000,
  tween,
}

local MAX_DOOR_OFFSET = 100
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
  currentDoorState = DOOR_STATES.CLOSED,
  moving = false,
  justMoved = true,
  ready = true,
}
Elevator.__index = Elevator

function Elevator:isDoorOpen()
  return self.currentDoorState == DOOR_STATES.OPEN
end

function Elevator:isDoorClosed()
  return self.currentDoorState == DOOR_STATES.CLOSED
end

function Elevator:new(o)
  local self = setmetatable(o or {}, Elevator)

  self.elevatorFloor = ElevatorPrms.elevatorFloor
  self.elevatorDoorwall = ElevatorPrms.elevatorDoorwall
  self.scale = love.window:getHeight() / self.elevatorFloor:getHeight()
  self.leftImage = ElevatorPrms.leftImage
  self.rightImage = ElevatorPrms.rightImage
  self.x = ElevatorPrms.x
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

    SoundMusic.isPlayMusic = true
--    SoundMusic:setVolume(0.2)
  end
end


function Elevator:openDoors()
print("asdasdasdasdasdasdas")
  if self.currentDoorState == DOOR_STATES.CLOSED then
    SoundSfx:play("ding")
  end
  self.currentDoorState = DOOR_STATES.OPENING
end

function Elevator:closeDoors()
  self.currentDoorState = DOOR_STATES.CLOSING
end

function Elevator:moveTo(y)
  self.tween = tween.new(2, self, {y=y})
end

function Elevator:update(dt)
  dbg:msg("doorOffset", self.doorOffset)
  dbg:msg("doorState", self.currentDoorState)

  if self.currentDoorState == DOOR_STATES.OPENING then
    updateOpenDoors(self, dt)
  elseif self.currentDoorState == DOOR_STATES.CLOSING then
    updateCloseDoors(self, dt)
  end

  if self.tween then
    self.moving = not self.tween:update(dt)
  end
end

local function draw(self)
  love.graphics.draw(self.image, self:getX(), self:getY(), 0, self.scale)
end

function Elevator:getDrawables()
  return {
    {
      draw=draw,
			getY=function() return self.y - .6*self.doorOffset end,
			getX=function() return self.x + self.doorOffset end,
			image=self.rightImage,
			x=self.x + self.doorOffset,
			getZ=function() return self.y - .6*self.doorOffset + 1000 end,
			0,
			scale=self.scale
    }, {
      draw=draw,
			getY=function() return self.y + .6*self.doorOffset end,
			getX=function() return self.x - self.doorOffset end,
			image=self.leftImage,
			getZ=function() return self.y + .6*self.doorOffset + 1001 end,
			0,
			scale=self.scale
    }, {
      draw=draw,
			getY=function() return self.y end,
			getX=function() return self.x end,
			image=self.elevatorFloor,
			x=self.x,
			getZ=function() return self.y + 1103 end,
			0,
			scale=self.scale
    }, {
      draw=draw,
			getY=function() return self.y end,
			getX=function() return self.x end,
			image=self.elevatorDoorwall,
			x=self.x,
			getZ=function() return self.y + 1104 end,
			0,
			scale=self.scale},
  }
end
