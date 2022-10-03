--[[
GameStatus
Module code for GameStatus UI. This module will allow the server to display game status messages to the client and display how many enemies are left during the round.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Info = require(ReplicatedStorage.Modules.Templates.UI.Info)

local module = setmetatable({}, {__index = Info})

function module:Init()
	self.givestatus = ReplicatedStorage.Events:WaitForChild("renderGameStatus",30)
	
	self.displaystatus = self.givestatus.OnClientEvent:Connect(function(info1,info2)
		self.screenGui.Status.Text = info1
	end)
	
	self.displayenemies = ReplicatedStorage.Trackers.EnemiesLeft.Changed:Connect(function(value)
		self.screenGui.Status.Text = "Enemies Left: "..value
	end)
	--]]
	
end




return module
