--[[
Info
Template module for information UI. This is a skeleton module that contains functions used in all informative UI. When Show is ran, the UI
will appear or dissapear regardless of other UI on the screen.
]]



local module = setmetatable({}, {__index = require(script.Parent)})

function module:onShow()
		
end

function module:Show(bool)
	self.enabled = bool
	self:onShow()
end

return module
