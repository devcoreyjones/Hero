--[[
AI
The AI used in the game. The AI is a class object which handles AI behavior, dealing damage to a target, cleaning itself up on death, and personal parameters.
]]

local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Sounds = game:GetService("SoundService")
local Events = require(ServerStorage.Modules.Services.Events)

local RNG = Random.new()

local module = {}
local mt = {__index = module}

function module.new(name,flying)
	local self = setmetatable({}, mt)
	self.name = name
	self.player = game.Players:GetPlayers()[1]
	self.spawns = workspace.SpecialLocations.EnemySpawnLocations:GetChildren()
	self.originaltarget = workspace.SpecialLocations.WallLocations["Wall"..RNG:NextInteger(1,12)]
	self.target = self.originaltarget
	self.lastattacktime = nil
	self.stats = {
		["Speed"] = 8,
		["AttackPower"] = 5,
		["AttackSpeed"] = 3,
		["Health"] = 100,
	}
	--statuses?
	self.flying = flying
	self:Init()
	self:spawn()
	return self
end

function module:Init()
end

function module:fly()
	self.bp = Instance.new("BodyPosition")
	self.bp.MaxForce = Vector3.new(0, 10000, 0)
	self.bp.Position = Vector3.new(0,50,0)
	self.bp.Parent = self.character.HumanoidRootPart
	self.stopflying = CollectionService:GetInstanceRemovedSignal("Flying"):Connect(function(obj)
		if obj == self.character then
			self.bp:Destroy()
			self.character.Humanoid.WalkSpeed /=2
		end
	end)
end

function module:spawn()
	if self.name then
		self.character = ReplicatedStorage.Assets.Rigs.R15:FindFirstChild(self.name)
	end
	if not self.character then
		local rigs = ReplicatedStorage.Assets.Rigs.R15:GetChildren()
		self.character = rigs[math.random(1, #rigs)]
	end
	self.character = self.character:Clone()
	self.character:SetAttribute("Targetable",true)
	self.character:SetAttribute("Stunned",false)
	self.character.Name = (self.flying == false and "Angry Noob" or "Flying Noob")
	self.character.PrimaryPart.CFrame = self.spawns[math.random(1, #self.spawns)].CFrame * CFrame.new(0, self.character:GetExtentsSize().Y/2, 0)
	self.character.Animate.Disabled = false
	self:setConnections()
	self:behavior()
	self.character.Humanoid.MaxHealth,self.character.Humanoid.Health = self.stats["Health"],self.stats["Health"]
	self.character.Humanoid.WalkSpeed = self.stats["Speed"]
	if self.flying then
		CollectionService:GetInstanceRemovedSignal("Flying"):Connect(function(obj)
			if obj == self.character then
				self.character.Name = "Ex-Flying Noob"
				self.parachute:Destroy()
			end
		end)
		CollectionService:AddTag(self.character,"Flying")
		self:fly()
	end
	self.character.Parent = workspace.Enemies
	if self.flying then
		self.parachute = ReplicatedStorage.Assets.VFX.Parachute:Clone()
		self.parachute.Parent = workspace.Projectiles
		self.parachute:SetPrimaryPartCFrame(self.character.HumanoidRootPart.CFrame)
		local attach = Instance.new("WeldConstraint")
		attach.Part0 = self.parachute.PrimaryPart
		attach.Part1 = self.character.HumanoidRootPart
		attach.Parent = self.parachute.PrimaryPart
	end

end

function module:despawn(context)
	self.name = self.character.Name
	for i, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
	
	ReplicatedStorage.Trackers.EnemiesLeft.Value -= 1
	Events.showMoveEff:FireAllClients("","DeathSound")
	self.character:Destroy()
	self.character = nil
end

function module:setConnections()
	self.connections = {}
	table.insert(self.connections, self.character.Humanoid.Died:Connect(function()
		self:Destroy()
	end))
end

function module:Attack()
	workspace:SetAttribute("CastleHealth",workspace:GetAttribute("CastleHealth") - self.stats["AttackPower"] ) 
end

function module:behavior()
	task.spawn(function()
		while self.character do
			self.character.Humanoid:MoveTo(self.target.Position)
			self.character.Humanoid.MoveToFinished:Wait()
			if ((self.target.Position * Vector3.new(1,0,1)) - (self.character.PrimaryPart.Position * Vector3.new(1,0,1))).Magnitude < 5 then
				if self.lastattacktime == nil or workspace:GetServerTimeNow() - self.lastattacktime >= self.stats["AttackSpeed"] then
					self:Attack()
					self.lastattacktime = workspace:GetServerTimeNow()
				end
			end
		end
	end)
end

function module:Destroy()
	self:despawn()
	table.clear(self)
	setmetatable(self, nil)
end

return module