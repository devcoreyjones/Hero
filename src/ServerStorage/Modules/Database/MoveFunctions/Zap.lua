--[[
Zap
Module that handles the code for running the Zap attack. It will create the server representation of the attack, show the effect on the client, move it forward on a heartbeat loop,
and use repeated Raycasts to find any hit enemies. Zap will knock flying enemies out the sky and cut their speed.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local Events = require(ServerStorage.Modules.Services.Events)
local RaycastHitbox = require(ReplicatedStorage.Modules.Standalones.RaycastHitbox)
local MoveInformation = require(ServerStorage.Modules.Database.MoveInformation)
local rng = Random.new()

return function(player,args)
	local pos = args[1]
	local temppos
	if typeof(pos) == "Vector3" then
		temppos = pos
	elseif typeof(pos) == "Instance" or typeof(pos) == "CFrame" then
		temppos = pos.Position
	end

	local generatedProjectile = ServerStorage.Assets.SizeInfo.Zap:Clone()
	generatedProjectile.CFrame = CFrame.new((player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-6)).p,temppos) * CFrame.Angles(0,0,0)
	generatedProjectile.Parent = workspace.Projectiles
	Events.showMoveEff:FireAllClients(generatedProjectile,"Zap")
	local move
	move = game:GetService("RunService").Heartbeat:Connect(function()
		if generatedProjectile ~= nil then	
			generatedProjectile.Position = generatedProjectile.Position + generatedProjectile.CFrame.LookVector * MoveInformation["Zap"]["Speed"]
		end
	end)
	local Hitbox = RaycastHitbox.new(generatedProjectile)
	local my_RP = RaycastParams.new()
	my_RP.FilterDescendantsInstances = {player.Character,generatedProjectile}
	my_RP.FilterType = Enum.RaycastFilterType.Blacklist
	my_RP.IgnoreWater = true
	Hitbox.RaycastParams = my_RP
	Hitbox.Visualizer = false
	Hitbox.DetectionMode = 3
	local myhit
	myhit = Hitbox.OnHit:Connect(function(Part, humanoid)
		if Part.Parent ~= workspace.Projectiles then
			if Part.ClassName ~= "Accessory" and Part.Parent:GetAttribute("Targetable") == true then
				if Part.Parent:FindFirstChild("Humanoid") ~= nil then
					local hum = Part.Parent.Humanoid
					hum.Health -= MoveInformation["Zap"]["Damage"]
					if CollectionService:HasTag(Part.Parent,"Flying") then
						CollectionService:RemoveTag(Part.Parent,"Flying")
					end
					Hitbox:HitStop()
					move:Disconnect()
					generatedProjectile:Destroy()
				end
			else
				Hitbox:HitStop()
				move:Disconnect()
				generatedProjectile:Destroy()
			end
		end
	end)--]]
	Hitbox:HitStart()
	task.spawn(function()
		task.wait(10)
		if generatedProjectile and generatedProjectile.Parent == workspace.Projectiles then
			generatedProjectile:Destroy()
		end
	end)
	
end
