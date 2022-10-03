--[[
BubbleDrop
Module code for Bubble Drop. When the key binded to Bubble Drop is pressed, if allowed, the client will play any local effect tied to the start of the attack and then
request for the server to perform the move.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")
local Sounds = game:GetService("SoundService")
local Spell = require(ReplicatedStorage.Modules.Templates.Ability.Spell)
local activateMove = ReplicatedStorage.Events:WaitForChild("activateMove")

local module = setmetatable({}, {__index = Spell})

function module:Init()
	self.binded = false
	self.activated = self.Player:GetAttributeChangedSignal("PlayerLocation"):Connect(function()
		if self.binded == false then
			self.binded = true
			if self.Player:GetAttribute("PlayerLocation") == "InRound" then
				CAS:BindAction("useBubbleDrop",
					function(actionName, inputState, inputObj)
						if inputState == Enum.UserInputState.Begin and self.Debounces.casting == false and self.Debounces.BubbleDrop == true then
							self.Debounces.casting = true
							self.Debounces.BubbleDrop = false
							--startup animation/effect
							--fire to the server to attempt the attack
							self:playEffect()
							activateMove:FireServer("BubbleDrop")
							self.Debounces.casting = false
						end
					end, false, Enum.KeyCode.Three)  
			end
		end
	end)
	self.managecd = ReplicatedStorage.Events.clientCD.OnClientEvent:Connect(function(move,status)
		
	end)
end

function module:playEffect()
	local sfx = Sounds.Audio.SoundEffects.AirWoosh:Clone()
	sfx.Parent = self.Player.Character.HumanoidRootPart
	sfx:Destroy()
end


function module:Unbind()
	CAS:UnbindAction("useBubbleDrop")
	self.binded = false
end


return module
