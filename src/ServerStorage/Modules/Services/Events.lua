--[[
Events
Module that loads and holds reference to all shared RemoveEvents in ReplicatedStorage.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local events = {}

events.startGame = ReplicatedStorage.Events:WaitForChild("startGame",30)
events.activateMove = ReplicatedStorage.Events:WaitForChild("activateMove",30)
events.showMoveEff = ReplicatedStorage.Events:WaitForChild("showMoveEff",30)
events.givestatus = ReplicatedStorage.Events:WaitForChild("renderGameStatus",30)
events.clientCD = ReplicatedStorage.Events:WaitForChild("clientCD",30)
events.UICD = ReplicatedStorage.Events:WaitForChild("UICD",30)

return events
