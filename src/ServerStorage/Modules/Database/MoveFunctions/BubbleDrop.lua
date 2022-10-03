--[[
BubbleDrop
Module that handles the code for running the Bubble Drop attack. It will create the server representation of the attack, show the effect on the client, make the player jump via
BodyPosition, then connect a landed event before dropping them to the ground. The landed event uses a GetPartBoundsInBox check to determine if any enemies are in range.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local Events = require(ServerStorage.Modules.Services.Events)
local RaycastHitbox = require(ReplicatedStorage.Modules.Standalones.RaycastHitbox)
local MoveInformation = require(ServerStorage.Modules.Database.MoveInformation)
local rng = Random.new()

local oparams = OverlapParams.new()
oparams.FilterType = Enum.RaycastFilterType.Blacklist

return function(player)
	
	local hold = Instance.new("BodyPosition")
	hold.P = 10000
	hold.MaxForce = Vector3.new(0,18000,0)
	hold.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,40,0)	
	hold.Parent = player.Character.HumanoidRootPart
	
	local serverrep = Instance.new("Part")
	serverrep.Transparency = 1
	serverrep.Size = Vector3.new(8.291, 8.291, 8.291)
	serverrep.CanCollide = false
	serverrep.Massless = true
	serverrep.Anchored = false
	serverrep.CFrame = player.Character.HumanoidRootPart.CFrame
	
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = serverrep
	attach.Part1 = player.Character.HumanoidRootPart
	attach.Parent = serverrep
	
	serverrep.Parent = workspace.Projectiles
	Events.showMoveEff:FireAllClients(serverrep,"BubbleDrop")
	
	task.delay(0.7,function()
		hold:Destroy()
		local humanoid = player.Character.Humanoid
		local landed 
		landed = humanoid.StateChanged:Connect(function(old, new)
			print(old,new)
			if new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running then
				landed:Disconnect()
				serverrep:Destroy()
				local ignoretable = {player.Character}
				for i,v in pairs (workspace.Projectiles:GetChildren()) do
					table.insert(ignoretable,v)
				end
				oparams.FilterDescendantsInstances = ignoretable
				local hitalready = {}
				for i,v in pairs (workspace:GetPartBoundsInBox(player.Character.HumanoidRootPart.CFrame * CFrame.new(0,-9,0) ,Vector3.new(8.291, 8.291, 8.291) * 3, oparams)) do
					print(v.Name)
					if not hitalready[v.Parent] and v.Parent:GetAttribute("Targetable") == true then
						hitalready[v.Parent] = true
						local distance = (v.Parent.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
						print(distance)
						if distance <= MoveInformation["BubbleDrop"]["AOERange"] then
							v.Parent.Humanoid.Health -= MoveInformation["BubbleDrop"]["Damage"]
						end
					end
				end
			end
		end)
	end)
	
	
	
end
