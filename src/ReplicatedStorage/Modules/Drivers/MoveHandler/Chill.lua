--[[
Chill
Module code for Chill. When the key binded to Chill is pressed, if allowed, the client will play any local effect tied to the start of the attack and then
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
				CAS:BindAction("useChill",
					function(actionName, inputState, inputObj)
						if inputState == Enum.UserInputState.Begin and self.Debounces.casting == false and self.Debounces.Chill == true then
							self.Debounces.casting = true
							self.Debounces.Chill = false
							--startup animation/effect
							--fire to the server to attempt the attack
							local anim,fan = self:playEffect()
							activateMove:FireServer("Chill",self:GetMousePoint(self.Mouse.X,self.Mouse.Y))
							task.delay(0.5,function()
								anim:Stop()
								fan:Destroy()
								self.Debounces.casting = false
							end)
						end
					end, false, Enum.KeyCode.Four)  
			end
		end
	end)
end

function module:playEffect()
	local anim = ReplicatedStorage.Assets.Animations.Hold
	local animPlayer = self.Player.Character.Humanoid.Animator:LoadAnimation(anim)
	animPlayer:Play()
	local fan = ReplicatedStorage.Assets.Moves.Fan:Clone()
	fan:SetPrimaryPartCFrame(self.Player.Character.RightHand.CFrame * CFrame.Angles(-math.pi/2,-math.pi/2.2,0) * CFrame.new(0,0.5,0))
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = fan.PrimaryPart
	attach.Part1 = self.Player.Character.RightHand
	attach.Parent = fan.PrimaryPart
	fan.Parent = self.Player.Character
	local sfx = Sounds.Audio.SoundEffects.iceBomb:Clone()
	sfx.Parent = self.Player.Character.HumanoidRootPart
	sfx:Destroy()
	return animPlayer,fan
end

function module:Unbind()
	CAS:UnbindAction("useChill")
	self.binded = false
end


return module
