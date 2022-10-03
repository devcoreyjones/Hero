--[[
Cooldowns
Module code for Cooldowns UI. This module will hide any move icons on cooldown and display those ready to be used.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local Info = require(ReplicatedStorage.Modules.Templates.UI.Info)

local module = setmetatable({}, {__index = Info})

function module:Init()
	self.CDUI = self.screenGui.Background
	self.reflectCD = ReplicatedStorage.Events.UICD.OnClientEvent:Connect(function(move,status)
		if status == "cd" then
			self.CDUI[move].Visible = false
		elseif status == "ready" then
			self.CDUI[move].Visible = true
		end
	end)
	
end

function module:onShow()
	self.screenGui.Enabled = self.enabled
end

--]]
return module

