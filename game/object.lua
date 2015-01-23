Object = {}
Object.__index = Object

function Object:new(o)
	local self = setmetatable(o or {}, Object)
	return self
end
