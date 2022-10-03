--[[
HUD
Module code for HUD UI. This module will manage the Castle Health UI bar by tracking any changes to the CastleHealth attribute of the workspace.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local Info = require(ReplicatedStorage.Modules.Templates.UI.Info)

local module = setmetatable({}, {__index = Info})

function module:Init()
	self.HUDUI = self.screenGui.Background
	self.Bar = self.HUDUI.BarBackground.Bar
	self.updateUI = workspace:GetAttributeChangedSignal("CastleHealth"):Connect(function()
		local percent = math.floor((workspace:GetAttribute("CastleHealth")/100)*100)
		if workspace:GetAttribute("CastleHealth") <= 0 then
			self.Bar:TweenSize(UDim2.new(0, 0, 1, 0),"Out","Sine",0.5,true)
		else
			self.Bar:TweenSize(UDim2.new((workspace:GetAttribute("CastleHealth")/100), 0, 1, 0),"Out","Sine",0.5,true)
		end
		local currenthealthbarPosition = self.Bar.Size.X.Scale
		if percent >= 67 then
			self.Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
		elseif percent >= 34 then
			self.Bar.BackgroundColor3 = Color3.fromRGB(255,255,0)
		else
			self.Bar.BackgroundColor3 = Color3.fromRGB(255, 51, 0)
		end
	end)
	
end

function module:onShow()
	self.screenGui.Enabled = self.enabled
end

--]]
return module

