--[[
MoveHandler
Container module for the move class objects created. This module will require the move modules that the player will use, running their code and allowing them
to share information between each other if necessary.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}
module.__index = module


function module.new()
	local self = setmetatable({}, module)
	for _, module in ipairs(script:GetChildren()) do
		self[module.Name] = require(module):new(module.Name)
	end
	for i in pairs(self) do
		for k, v in pairs(self) do
			if i ~= k then
				self[i].moves[k] = v
			end
		end
	end
	return self
end

return module
