--[[
GameHandler
Module that handles starting the game. This module will recieve the client's request to start the game and do so. Mainly exists to edit aspects of the 
game before hand if necessary.
]]

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Round = require(ServerStorage.Modules.Templates.Round)

local PlayerList = require(ServerStorage.Modules.Services.Players)
local Events = require(ServerStorage.Modules.Services.Events)
local rng = Random.new()

local module = {}
module.__index = module

function module.new()
	local self = setmetatable({}, module)
	self.start = Events.startGame.OnServerEvent:Connect(function()
		self:startGame()
	end)
	return self
end



function module:startGame()
	local player = game.Players:GetPlayers()[1]
	if player then
		player:SetAttribute("PlayerLocation","InRound")
	end
	local defense = Round.new()
	defense:Start()
end

return module
