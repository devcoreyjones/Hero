--[[
Main Menu
Module code for Main Menu UI. This module connects the effects on the play button and asks the server to begin the game when the play button is pushed.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local startGame = ReplicatedStorage.Events:WaitForChild("startGame",30)

local Window = require(ReplicatedStorage.Modules.Templates.UI.Window)

local module = setmetatable({}, {__index = Window})

function module:Init()
	self.tweenClick = TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0)
	self.MainMenu = self.playerGui:WaitForChild("MainMenu")
	self:setButtons()
end

function module:setButtons()
	for i,v in pairs(self.MainMenu:GetDescendants()) do
		if v.ClassName == "TextButton" then
			v.MouseButton1Click:Connect(function()
				task.spawn(function()
					local G = v.Click:Clone()
					G.Position = UDim2.new(0,self.Mouse.X-v.AbsolutePosition.X,0,self.Mouse.Y-v.AbsolutePosition.Y)
					G.Parent = v
					local tween = self.TS:Create(G, self.tweenClick, {Size = UDim2.new(1,0,1,0),ImageTransparency = 1})
					tween:Play()
					task.wait(1)
					G:Destroy()
				end)
				self["On"..v.Name](self)
			end)
			v.MouseEnter:Connect(function()
				local click = SoundService.Audio.SoundEffects.hover:Clone()
				click.Parent = self.playerGui
				click:Destroy()
				local ti = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				local offset1 = {Offset = Vector2.new(1, 0)}
				local create = self.TS:Create(v.UIGradient, ti, offset1)
				local startingPos = Vector2.new(-1, 0) --start on the right, tween to the left so it looks like the shine went from left to right
				v.UIGradient.Offset = startingPos
				local addWait = 2.5
				create:Play()
			end)
		end	
	end
end

function module:OnPlay()
	startGame:FireServer()
	self:Toggle()
	self.Player.Character:SetPrimaryPartCFrame(workspace.RealSpawnLocation.CFrame)
	self.MoveCamera("Player")
	self.ui.HUD:Show(true)
	self.ui.Cooldowns:Show(true)
	--self.Player.CameraMode = Enum.CameraMode.LockFirstPerson


end

function module:onToggle()
	self.screenGui.Enabled = self.enabled
end

return module
