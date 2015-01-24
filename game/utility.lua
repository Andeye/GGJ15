function convertListToPoints(list)
--[[
Converts vertices from this format:
{1, 2, 3...}
to this:
{[1] = {x = 1, y = 2}, [2] ...}
..]]
	local points = {}
	local i = 1
	for k,v in pairs(list) do
		if k % 2 == 0 then
			points[i].y = v
			i = i + 1
		else
			points[i] = {}
			points[i].x = v
		end
	end
	return points
end

function convertPointsToList(points)
--[[
Converts vertices from this format:
{[1] = {x = 1, y = 2}, [2] ...}
to this:
{1, 2, 3...}
..]]
	local list = {}
	for k,v in ipairs(points) do
		table.insert(list, v.x)
		table.insert(list, v.y)
	end
	return list
end
