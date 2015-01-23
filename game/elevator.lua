ElevatorPrms = {
  image = love.graphics.newImage("assets/graphics/elevator_ph_crop.png"),
  x = 0,
  y = 0,
}

Elevator = {
  }
Elevator.__index = Elevator


function Elevator:new(o)
  local self = setmetatable(o or {}, Elevator)

  self.image = ElevatorPrms.image
  self.scale = love.window:getHeight() / self.image:getHeight()
  self.x = (love.window:getWidth() - self.image:getWidth() * self.scale) / 2
  self.y = ElevatorPrms.y

  return self
end



function Elevator:update(dt)

end


function Elevator:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale)
end
