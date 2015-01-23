--[[
	GUI handler service for detecting and delivering mouse clicks and hovering events
	Components registering need to define:
		.shape
	and the functions:
		:draw
		:onHover()
		:onBlur(onDrag)
		:mousepressed()
		:mousereleased()
		:onClick()
		:onDragDrop()
 --]]
GUI = {
	components,
	last,
	layers,
}

require("external/PointWithinShape")

function GUI:new()
	-- No need to create multiple GUI handlers
	self.components = {}
	self.last = nil
	self.layers = {}
	self.mousedown = false
	self.draggable = nil
	return GUI
end

function GUI:update(dt)
	local x, y = love.mouse.getPosition()
	x, y = x / pxlScl, y / pxlScl
	self:checkMouse(x, y)
end

function GUI:draw()
	for component in pairs(self.components) do
		component:draw()
	end
	for name,layer in pairs(self.layers) do
		if layer.visible then
			for component in pairs(layer.components) do
				component:draw()
			end
		end
	end
	if self.draggable then
		self.draggable:draw()
	end
end

local function getComponent(components, x, y)
	for component in pairs(components) do
		if PointWithinShape(component.shape, x, y) then
			return component
		end
	end
	return false
end

function GUI:getComponent(x, y)
	local component = getComponent(self.components, x, y)
	if component then
		return component
	else
		for name,layer in pairs(self.layers) do
			if layer.visible then
				local component = getComponent(layer.components, x, y)
				if component then
					return component
				end
			end
		end
	end	
	return false
end

function GUI:checkMouse(x, y)
	-- Check over which component the mouse is and send hover and blur events
	local component = self:getComponent(x, y)
	if component then
		if self.last ~= component then
			if self.last then
				local draggable = self.last:onBlur(self.mousedown == self.last, self.draggable)
				if self.mousedown == self.last then
					self.draggable = draggable
				end
			end
			self.last = component
			self.last:onHover(self.draggable)
		end
		return true
	end
	if self.last then
		local draggable = self.last:onBlur(self.mousedown == self.last, self.draggable)
		if self.mousedown == self.last then
			self.draggable = draggable
		end
		self.last = nil
	end
	return false
end

function GUI:addComponent(component, layer)
	if layer then
		if not self.layers[layer] then
			self:addLayer(layer, true)
		end
		self.layers[layer].components[component] = component
	else
		self.components[component] = component
	end
end

function GUI:delComponent(component)
	self.components[component] = nil
end

function GUI:addLayer(layer, visible)
	self.layers[layer] = {visible = visible, components = {}}
end

function GUI:layerVisible(layer, visible)
	if not self.layers[layer] then
		self:addLayer(layer, visible)
	else
		self.layers[layer].visible = visible
	end
end

function love.mousepressed(x, y, button)
	x, y = x / pxlScl, y / pxlScl
	local component = GUI:getComponent(x, y)
	if component then
		if component.mousepressed then
			component:mousepressed(x, y, button)
		end
		GUI.mousedown = component
	else
		GUI.mousedown = true
	end
end

function love.mousereleased(x, y, button)
	x, y = x / pxlScl, y / pxlScl
	local component = GUI:getComponent(x, y)
	if component then
		if component.mousereleased then
			component:mousereleased(x, y, button)
		end
		if component.onDragDrop and GUI.draggable then
			component:onDragDrop(GUI.draggable)
		elseif component.onClick and component == GUI.mousedown then
			component:onClick(x, y, button)
		end
	end
	GUI.mousedown = false
	GUI.draggable = nil
end
