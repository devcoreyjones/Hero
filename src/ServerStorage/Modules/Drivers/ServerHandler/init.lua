--[[
ServerHandler
Server manager module that handles players. This script will load any children and run any events connected to the player joining or leaving and game critical events.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Events = ReplicatedStorage:WaitForChild("Events")


local PlayerHandler = require(ServerStorage.Modules.Services.PlayerHandler)
local GameHandler = require(ServerStorage.Modules.Services.GameHandler)

local module = {
	Events = require(ServerStorage.Modules.Services.Events)
}
module.__index = module

function module.new()
	local self = setmetatable({}, module)
	self.players = require(ServerStorage.Modules.Services.Players)
	Players.PlayerAdded:Connect(function(player)
		self.players[player] = PlayerHandler.new(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self.players[player]:Destroy()
		self.players[player] = nil
	end)
	for i,v in pairs(script:GetChildren()) do
		self[v.Name] = require(v)
	end
	task.spawn(function()
		self.game = GameHandler.new()
	end)
	return self
end


return module
