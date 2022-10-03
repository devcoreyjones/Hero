--[[
activateMove
Module that runs the attacks when a client requests it. This module loads all attack modules under MoveFunctions. If the move is not on cooldown 
(signified by having an index in the cd table), the module will run the attack and process the cooldown before allowing the client to use the attack again.
This module also signifies to the client when an attack can be used again via RemoteEvent.
]]

local ServerStorage = game:GetService("ServerStorage")
local Events = require(ServerStorage.Modules.Services.Events)
--local plrData = require(game.ServerScriptService.Database.plrDataManager)
local Players = require(ServerStorage.Modules.Services.Players)
local MoveInformation = require(ServerStorage.Modules.Database.MoveInformation)

local Moves = {}
for i,v in pairs(ServerStorage.Modules.Database.MoveFunctions:GetChildren()) do
	Moves[v.Name] = require(v)
end

local cd = {}

return Events.activateMove.OnServerEvent:Connect(function(player,movename,...)
	local args = {...}
	if cd[movename] == nil then
		cd[movename] = true
		Events.UICD:FireClient(player,movename,"cd")
		Moves[movename](player,args)
		task.delay(MoveInformation[movename]["Cooldown"],function()
			cd[movename] = nil
			Events.clientCD:FireClient(player,movename)
			Events.UICD:FireClient(player,movename,"ready")
		end)
	else
		print(movename.. " on cool down")
	end
end)

