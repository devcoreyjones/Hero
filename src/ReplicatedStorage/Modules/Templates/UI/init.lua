--[[
UI
Module code for handling the UI modules. This module servers as a parent for the UI modules so that they may inherit some commonly shared variables
other ui modules, and/or functions.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local module = {
	--Global vars
	Player = Players.LocalPlayer,
	Mouse = Players.LocalPlayer:GetMouse(),
	Camera = workspace.CurrentCamera,
	TS = game:GetService("TweenService"),
	ClientEvents = require(ReplicatedStorage.Modules.Standalones.ClientHandler.ClientEvents),
	MoveCamera = require(ReplicatedStorage.Modules.Standalones.CameraHandler)
}

function module:new(uiName)
	local self = setmetatable({}, {__index = self})
	self.ui = {}
	self.enabled = false
	self.playerGui = self.Player.PlayerGui
	self.screenGui = self.playerGui:WaitForChild(uiName)
	self:Init()
	return self
end


function module:Init()
	
end

return module
