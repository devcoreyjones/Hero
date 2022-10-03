--[[
CharacterHandler
Module for connecting important Character events when the Character is loaded. Can be run on either the client or server.
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local module = {}
local mt = {__index = module}

function module.new(character)
	local self = setmetatable({}, mt)
	self.character = character
	self.humanoid = self.character:WaitForChild("Humanoid")
	self.connections = {}
	self["On"..((RunService:IsServer()) and "Server" or "Client")](self)
	self:GetAnims()
	return self
end

function module:GetAnims()
	
end

function module:OnServer()
	
end

function module:OnClient()
	
end

function module:Destroy()
	for _, connection in pairs(self.connections) do
		connection:Disconnect()
		connection = nil
	end
	if self.anims then
		for anim, animTrack in pairs(self.anims) do
			animTrack:Destroy()
		end
	end
	table.clear(self)
	setmetatable(self, nil)
end

return module
