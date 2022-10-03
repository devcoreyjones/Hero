--[[
Zap
Module code for Zap. When the key binded to Zap is pressed, if allowed, the client will play any local effect tied to the start of the attack and then
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
				CAS:BindAction("useZap",
					function(actionName, inputState, inputObj)
						if inputState == Enum.UserInputState.Begin and self.Debounces.casting == false and self.Debounces.Zap == true  then
							self.Debounces.casting = true
							self.Debounces.Zap = false
							--startup animation/effect
							--fire to the server to attempt the attack
							local anim,toaster = self:playEffect()
							activateMove:FireServer("Zap",self:GetMousePoint(self.Mouse.X,self.Mouse.Y))
							task.delay(0.5,function()
								anim:Stop()
								toaster:Destroy()
								self.Debounces.casting = false
							end)
						end
					end, false, Enum.KeyCode.Two)  
			end
		end
	end)
end

function module:playEffect()
	local anim = ReplicatedStorage.Assets.Animations.Hold
	local animPlayer = self.Player.Character.Humanoid.Animator:LoadAnimation(anim)
	animPlayer:Play()
	local toaster = ReplicatedStorage.Assets.Moves.Toaster:Clone()
	toaster.CFrame = self.Player.Character.LeftHand.CFrame * CFrame.Angles(0,0,math.pi/1.2) * CFrame.new(0,0.8,0)
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = toaster
	attach.Part1 = self.Player.Character.LeftHand
	attach.Parent = toaster
	toaster.Parent = self.Player.Character
	local sfx = Sounds.Audio.SoundEffects.lightning:Clone()
	sfx.Parent = self.Player.Character.HumanoidRootPart
	sfx:Destroy()
	return animPlayer,toaster
end

function module:Unbind()
	CAS:UnbindAction("useZap")
	self.binded = false
end


return module
