--[[
FireBall
Module that handles the code for running the FireBall attack. It will create the server representation of the attack, show the effect on the client, move it forward on a heartbeat loop,
and use repeated Raycasts to find any hit enemies. The fireball will also fall in an arc after a period of time passes.
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

	local generatedProjectile = ServerStorage.Assets.SizeInfo.Fireball:Clone()
	generatedProjectile.CFrame = CFrame.new((player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-6)).p,temppos) * CFrame.Angles(0,0,0)
	generatedProjectile.Parent = workspace.Projectiles
	Events.showMoveEff:FireAllClients(generatedProjectile,"FireBall")
	print("fire client")
	local move
	local starttime = workspace:GetServerTimeNow()
	local decay = MoveInformation["FireBall"]["Speed"]
	local decaystarted = false
	move = game:GetService("RunService").Heartbeat:Connect(function()
		if generatedProjectile ~= nil then	
			if workspace:GetServerTimeNow() - starttime >= 1.5 then
				generatedProjectile.Position = generatedProjectile.Position + generatedProjectile.CFrame.LookVector * decay
				decay -= 0.005
				if decaystarted == false then
					decaystarted = true
					generatedProjectile.Anchored = false
					local attach = Instance.new("Attachment")
					attach.Parent = generatedProjectile
					local vf_down = Instance.new("VectorForce")
					vf_down.Force = Vector3.new(0,50000,0)
					vf_down.Attachment0 = attach
					vf_down.RelativeTo = Enum.ActuatorRelativeTo.World
					local vf_forward = Instance.new("VectorForce")
					vf_forward.Force = Vector3.new(0,0,-20000)
					vf_forward.Attachment0 = attach
					vf_forward.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
					vf_forward.Parent = generatedProjectile

				end
				if decay <= 0 then
					move:Disconnect()
				end
				
			else
				generatedProjectile.Position = generatedProjectile.Position + generatedProjectile.CFrame.LookVector * MoveInformation["FireBall"]["Speed"]
			end
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
	--local hitAlready = {}
	local myhit
	--hitAlready[player.Name] = player.Character
	local hitalready = {}
	myhit = Hitbox.OnHit:Connect(function(Part, humanoid)
		print(Part.Name,Part.Parent)
		if Part.Parent ~= workspace.Projectiles then
			if Part.ClassName ~= "Accessory" and Part.Parent:GetAttribute("Targetable") == true then
				print("hit npc")
				if Part.Parent:FindFirstChild("Humanoid") ~= nil then
					local hum = Part.Parent.Humanoid
					hum.Health -= MoveInformation["FireBall"]["Damage"]
					print("normal")
					hitalready[Part.Parent] = true			
					Hitbox:HitStop()
					move:Disconnect()
				end
			else
				Hitbox:HitStop()
				move:Disconnect()
			end
			for i,v in pairs (workspace:GetPartBoundsInBox(generatedProjectile.CFrame,Vector3.new(8.291, 8.291, 8.291) * 5, oparams)) do
				local ignoretable = {player.Character}
				for i,v in pairs (workspace.Projectiles:GetChildren()) do
					table.insert(ignoretable,v)
				end
				oparams.FilterDescendantsInstances = ignoretable
				if not hitalready[v.Parent] and v.Parent:GetAttribute("Targetable") == true then
					hitalready[v.Parent] = true
					local distance = (v.Parent.HumanoidRootPart.Position - generatedProjectile.Position).magnitude
					if distance <= MoveInformation["FireBall"]["AOERange"] then
						print("splash")
						v.Parent.Humanoid.Health -= MoveInformation["FireBall"]["Damage"]
					end
				end
			end
			generatedProjectile:Destroy()
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
