--[[
Chill
Module that handles the code for running the Chill attack. It will create the server representation of the attack, show the effect on the client, move it forward on a heartbeat loop,
and use GetPartsBoundInBox to find any hit enemies. These enemies have their walkspeed cut in half.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Events = require(ServerStorage.Modules.Services.Events)
local RaycastHitbox = require(ReplicatedStorage.Modules.Standalones.RaycastHitbox)
local MoveInformation = require(ServerStorage.Modules.Database.MoveInformation)
local rng = Random.new()


local oparams = OverlapParams.new()
oparams.FilterType = Enum.RaycastFilterType.Blacklist

return function(player,args)
	local pos = args[1]
	local temppos
	if typeof(pos) == "Vector3" then
		temppos = pos
	elseif typeof(pos) == "Instance" or typeof(pos) == "CFrame" then
		temppos = pos.Position
	end

	local generatedProjectile = ServerStorage.Assets.SizeInfo.Chill:Clone()
	generatedProjectile.CFrame = CFrame.new((player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-6)).p,temppos) * CFrame.Angles(0,0,0)
	generatedProjectile.Parent = workspace.Projectiles
	Events.showMoveEff:FireAllClients(generatedProjectile,"Chill")
	print("fire client")
	local move
	move = game:GetService("RunService").Heartbeat:Connect(function()
		if generatedProjectile ~= nil then	
			generatedProjectile.Position = generatedProjectile.Position + generatedProjectile.CFrame.LookVector * MoveInformation["Chill"]["Speed"]
		end
	end)
	task.spawn(function()
		task.wait(15)
		if generatedProjectile and generatedProjectile.Parent == workspace.Projectiles then
			generatedProjectile:Destroy()
		end
	end)
	task.spawn(function()
		local hitAlready = {}
		repeat
			for i,v in pairs(workspace:GetPartBoundsInBox(generatedProjectile.CFrame,generatedProjectile.Size,oparams)) do
				if v.ClassName ~= "Accessory" and v.Parent:GetAttribute("Targetable") == true and not hitAlready[v.Parent] then
					print("hit npc")
					if v.Parent:FindFirstChild("Humanoid") ~= nil then
						hitAlready[v.Parent] = true
						local hum = v.Parent.Humanoid
						hum.WalkSpeed /= 2
					end
				else
				end
			end
			task.wait(0.1)
		until generatedProjectile.Parent ~= workspace.Projectiles
	end)
	--hitAlready[player.Name] = player.Character
	
	
end
