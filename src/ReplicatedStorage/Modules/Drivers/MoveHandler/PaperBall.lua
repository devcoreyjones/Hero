--[[
PaperBall
Module code for Paper Ball. When the key binded to Paper Ball is pressed, if allowed, the client will play any local effect tied to the start of the attack and then
request for the server to perform the move.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")
local Spell = require(ReplicatedStorage.Modules.Templates.Ability.Spell)
local activateMove = ReplicatedStorage.Events:WaitForChild("activateMove")

local module = setmetatable({}, {__index = Spell})

function module:Init()
	self.binded = false
	self.currentanim = nil
	self.activated = self.Player:GetAttributeChangedSignal("PlayerLocation"):Connect(function()
		if self.binded == false then
			self.binded = true
			if self.Player:GetAttribute("PlayerLocation") == "InRound" then
				CAS:BindAction("usePaperBall",
					function(actionName, inputState, inputObj)
						if inputState == Enum.UserInputState.Begin and self.Debounces.casting == false and self.Debounces.PaperBall == true then
							self.Debounces.casting = true
							self.Debounces.PaperBall = false
							--startup animation/effect
							--fire to the server to attempt the attack
							self:playEffect()
							activateMove:FireServer("PaperBall",self:GetMousePoint(self.Mouse.X,self.Mouse.Y))
							self.Debounces.casting = false
						end
					end, false, Enum.UserInputType.MouseButton1)  
			end
		end
	end)
end

function module:playEffect()
	local anim = ReplicatedStorage.Assets.Animations.WideAiToss
	local animPlayer = self.Player.Character.Humanoid.Animator:LoadAnimation(anim)
	if self.currentanim then
		self.currentanim:Stop()
	end
	self.currentanim = animPlayer
	animPlayer:Play()
end


function module:Unbind()
	CAS:UnbindAction("usePaperBall")
	self.binded = false
end


return module
