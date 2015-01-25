Debug = {
	data = "",
}
Debug.__index = Debug

function Debug:new()
	local self = setmetatable({}, Debug)
	return self
end

function Debug:msg(tag, msg)
	if msg == nil then 
		return
	end
	self.data = self.data.."\n"..tag..": "..msg
end

function Debug:clear()
	self.data = ""
end

function Debug:out()
	local data = self.data
	self:clear()
	return data
end

function Debug:serialize(o, maxindent, indent)
	local indent = indent or ""
	local maxindent = maxindent or 3
	if #indent > maxindent then
		return ""
	end
	if type(o) == "table" then
		local str = tostring(o).." ("..#o..")\n"
		indent = indent.."\t"
		for i,v in pairs(o) do
			str = str..indent..tostring(i)..": "..self:serialize(o[i], maxindent, indent).."\n"
		end
		return str
	else
		-- return " "..": '"..tostring(o).."'\t"..type(o)
		return "'"..tostring(o).."'\t"..type(o)
	end
end

-- Dummy

Debug_dummy = {
new = function() return Debug_dummy end,
msg = function() end,
out = function() return "" end,
serialize = function() return "" end,
}
