ElevatorPrms = {
  elevatorImage = love.graphics.newImage("assets/graphics/elevator_ph_crop.png"),
  doorImage = love.grahphics.newImage("assets/graphics/elevator_ph_crop_door.png"),
  x = 0,
  y = 0,
}

Elevator = {
  }
Elevator.__index = Elevator


function Elevator:new(o)
  local self = setmetatable(o or {}, Elevator)

  self.elevatorImage = ElevatorPrms.elevatorImage
  self.scale = love.window:getHeight() / self.image:getHeight()
  self.x = (love.window:getWidth() - self.image:getWidth() * self.scale) / 2
  self.y = ElevatorPrms.y

  return self
end



function Elevator:update(dt)

end


function Elevator:draw()
  love.graphics.draw(self.elevatorImage, self.x, self.y, 0, self.scale)
--  love.graphics.draw(slef.doorImage, self.x, self.y, 0, self.scale)
end
