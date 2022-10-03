--[[
Ability
Module code for handling the player abilities. This module servers as a parent for the move modules so that they may inherit some commonly shared variables,
other move modules, and/or functions.
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
	Debounces = require(ReplicatedStorage.Modules.Standalones.ClientHandler.Debounces),
	ClientEvents = require(ReplicatedStorage.Modules.Standalones.ClientHandler.ClientEvents),
	MoveCamera = require(ReplicatedStorage.Modules.Standalones.CameraHandler)
}

function module:new(uiName)
	local self = setmetatable({}, {__index = self})
	self.moves = {}
	self:Init()
	return self
end

function module:Init()

end

return module
