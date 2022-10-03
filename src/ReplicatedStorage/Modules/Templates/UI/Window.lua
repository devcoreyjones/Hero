--[[
Window
Template module for window UI. This is a skeleton module that contains functions used in all main focus UI. When Activated is ran, the UI
will make any other UI hide itself before appearing.
]]

local module = setmetatable({}, {__index = require(script.Parent)})

function module:setButtons()

end

function module:onToggle()
	
end

function module:Toggle()
	self.enabled = (not self.enabled)
	if self.enabled then
		for key, ui in pairs(self.ui) do
			print(key)
			if ui.Deactivated then
				ui:Deactivated()
			end
		end
	end
	self:onToggle()
end

function module:Activated()
	if not self.enabled then
		self:Toggle()
	end
end

function module:Deactivated()
	if self.enabled then
		self:Toggle()
	end
end

return module
