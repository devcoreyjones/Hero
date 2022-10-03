--[[
PlayerHandler
Module that handles players who join the game. Joining players are given a Player object which, if necessary, can hold special information
and connect important events to the player on the server-side.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local CharacterHandler = require(ReplicatedStorage.Modules.Common.CharacterHandler)

local module = {
	
}

module.__index = module

function module.new(player)
	local self = setmetatable({}, module)
	self.player = player
	self.player:SetAttribute("PlayerLocation", "Inactive")
	local function characterAdded(character)
		if not self.character then
			self.character = CharacterHandler.new(character)
		end
	end
	characterAdded(self.player.Character or self.player.CharacterAdded:Wait())
	self.player.CharacterAdded:Connect(characterAdded)
	self.player.CharacterRemoving:Connect(function(character)
		if self.character then
			self.character:Destroy()
			self.character = nil
		end
	end)
	return self
end


function module:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return module
