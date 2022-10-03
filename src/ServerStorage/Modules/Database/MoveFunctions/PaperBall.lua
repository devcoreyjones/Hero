--[[
PaperBall
Module that handles the code for running the PaperBall attack. It will create the server representation of the attack, show the effect on the client, move it forward on a heartbeat loop,
and use repeated Raycasts to find any hit enemies.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Sounds = game:GetService("SoundService")
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

	local generatedProjectile = ReplicatedStorage.Assets.Moves.Paperball:Clone()
	generatedProjectile.CFrame = CFrame.new((player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)).p,temppos) * CFrame.Angles(0,0,0)
	generatedProjectile.Parent = workspace.Projectiles
	
	local sfx = Sounds.Audio.SoundEffects.papermove:Clone()
	sfx.Parent = generatedProjectile
	sfx:Play()
	task.delay(2,function()
		sfx:Stop()
		sfx:Destroy()
	end)
	
	local move
	move = game:GetService("RunService").Heartbeat:Connect(function()
		if generatedProjectile ~= nil then					
			generatedProjectile.Position = generatedProjectile.Position + generatedProjectile.CFrame.LookVector * MoveInformation["PaperBall"]["Speed"]
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
	myhit = Hitbox.OnHit:Connect(function(Part, humanoid)
		if Part.Parent ~= workspace.Projectiles then
			if Part.ClassName ~= "Accessory" and Part.Parent:GetAttribute("Targetable") == true then
				print("hit npc")
				if Part.Parent:FindFirstChild("Humanoid") ~= nil then
					local hum = Part.Parent.Humanoid
					hum.Health -= MoveInformation["PaperBall"]["Damage"]
					Hitbox:HitStop()
					move:Disconnect()
					generatedProjectile.Anchored = false
					generatedProjectile.CanCollide = true
				end
			else
				Hitbox:HitStop()
				move:Disconnect()
				generatedProjectile.Anchored = false
				generatedProjectile.CanCollide = true
			end
			local sfx = Sounds.Audio.SoundEffects.paperimpact:Clone()
			sfx.Parent = generatedProjectile
			sfx:Destroy()
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
