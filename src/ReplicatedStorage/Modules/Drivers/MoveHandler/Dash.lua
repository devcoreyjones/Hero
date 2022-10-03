--[[
Dash
Module code for the dashing. When the Q key is pressed, the user will dash forward based on both thier mouselock status and what directional key they are holding.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")

local Spell = require(ReplicatedStorage.Modules.Templates.Ability.Spell)
local activateMove = ReplicatedStorage.Events:WaitForChild("activateMove")

local module = setmetatable({}, {__index = Spell})

local EnumDict = {
	[Enum.KeyCode.W] = {"LookVector",80},
	[Enum.KeyCode.D] = {"RightVector",80},
	[Enum.KeyCode.S] = {"LookVector",-80},
	[Enum.KeyCode.A] = {"RightVector",-80}
}

function module:Init()
	self.binded = false
	self.activated = self.Player:GetAttributeChangedSignal("PlayerLocation"):Connect(function()
		if self.binded == false then
			self.binded = true
			if self.Player:GetAttribute("PlayerLocation") == "InRound" then
				CAS:BindAction("useDash",
					function(actionName, inputState, inputObj)
						if inputState == Enum.UserInputState.Begin and self.Debounces.casting == false and self.Debounces.charging == false then
							self.Debounces.casting = true
							--startup animation/effect
							--fire to the server to attempt the attack
							local animation
							local fastmovement = game.SoundService.Audio.SoundEffects.fastMovement:Clone()
							fastmovement.Parent = self.Player.Character.HumanoidRootPart
							fastmovement:Destroy()
							local BodyVelocity = Instance.new("BodyVelocity")
							BodyVelocity.MaxForce = Vector3.new(20000,20000,20000)
							BodyVelocity.Parent = self.Player.Character.HumanoidRootPart
							--game.Debris:AddItem(BodyVelocity,dashtime)
							task.spawn(function()
								task.wait(0.17)
								BodyVelocity:Destroy()
								task.wait(0.17)
								--debounces.canAct = false
								self.Debounces.casting = false
							end)
							--local s,f = pcall(function() events.checkDashes:FireServer(Player) end)

							local savedkey
							local mouseislocked
							if UserSettings():GetService("UserGameSettings").RotationType == Enum.RotationType.CameraRelative then
								mouseislocked = true
							else
								mouseislocked = false
							end
							if not mouseislocked then
								savedkey = Enum.KeyCode.W 
							else
								if UIS:IsKeyDown(Enum.KeyCode.W) then savedkey = Enum.KeyCode.W 
								elseif UIS:IsKeyDown(Enum.KeyCode.A) then savedkey = Enum.KeyCode.A
								elseif UIS:IsKeyDown(Enum.KeyCode.S) then savedkey = Enum.KeyCode.S
								elseif UIS:IsKeyDown(Enum.KeyCode.D) then savedkey = Enum.KeyCode.D
								else
									savedkey = Enum.KeyCode.W 
								end
							end
							while self.Debounces.casting == true do
								if self.Debounces.casting == false then break end
								game:GetService("RunService").RenderStepped:Wait()
								BodyVelocity.Velocity = self.Player.Character.HumanoidRootPart.CFrame[EnumDict[savedkey][1]] * EnumDict[savedkey][2]
							end
						end
					end, false, Enum.KeyCode.Q)  
			end
		end
	end)
	
end


function module:Unbind()
	CAS:UnbindAction("useDash")
	self.binded = false
end


return module
