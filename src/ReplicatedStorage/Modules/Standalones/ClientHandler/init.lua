--[[
ClientHandler
Module code for handling the Client. This module will connect any important character and LocalPlayer events, such as UI events.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ModuleLoader = require(ReplicatedStorage.Modules.Common.ModuleLoader)
local CharacterHandler = require(ReplicatedStorage.Modules.Common.CharacterHandler)
local MoveCamera = require(ReplicatedStorage.Modules.Standalones.CameraHandler)
local EffectHandler = require(ReplicatedStorage.Modules.Standalones.EffectHandler)

local module = {
	Client = nil
}

module.__index = module

function module.new()
	local self = setmetatable({}, module)
	self.player = Players.LocalPlayer
	self.character = nil
	self.connections = {}
	module.Client = self
	self.debounces = require(script.Debounces)
	local function characterAdded(character)
		if not self.character then
			self.character = CharacterHandler.new(character)
			self:LoadCharacterEvents()
		end
	end
	characterAdded(self.player.Character or self.player.CharacterAdded:Wait())
	self.player.CharacterAdded:Connect(characterAdded)
	self.player.CharacterRemoving:Connect(function(character)
		self.character:Destroy()
		self.character = nil
	end)
	self.clearclientcd = ReplicatedStorage.Events.clientCD.OnClientEvent:Connect(function(move)
		self.debounces[move] = true
	end)
	--
	ModuleLoader.load(ReplicatedStorage.Modules.Drivers:GetChildren())
	task.wait(0.1)
	self.UIHandler = ModuleLoader.loadedModules["UIHandler"]
	--when the player selects "play", a attribute changed will fire and bind the player moves
	self:LoadPlayerEvents()
	MoveCamera(workspace.SpecialLocations.IntroCamera)
	self.UIHandler.MainMenu:Activated()
	return self
end

function module:LoadCharacterEvents()
	
end

function module:LoadPlayerEvents()
	
end


function module:Destroy()
	for _, connection in pairs(self.connections) do
		connection:Disconnect()
		connection = nil
	end
	table.clear(self)
	setmetatable(self, nil)
end

return module

