--[[
Round
Module for handling the rounds in the game. Once the game begins, the game will generate a round by setting the Castle Health to 100 and spawning in waves of NPCs.
Clearing the waves or having the Castle HP drop to 0 signifies the end of the round, and based on the previously completed rounds, the game is either won, lost, or
going to the next round.
]]

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerList = require(ServerStorage.Modules.Services.Players)
local Events = require(ServerStorage.Modules.Services.Events)

local AI = require(ServerStorage.Modules.Templates.AI)

local rng = Random.new()

local module = {}
module.__index = module

function module:new()
	local self = setmetatable({}, module)
	self.enabled = false
	self.connections = {}
	self.enemies = {}
	self.round = 1
	self.enemiesinround = ReplicatedStorage.Trackers.EnemiesLeft
	self:Init()
	return self
end

function module:Init()

end


function module:spawnPlayer(player)
	
end

function module:startRound()
	workspace:SetAttribute("CastleHealth",100)
	self.enemiesinround.Value = self.round * 4
	for i = 1,self.round * 4 do
		local ai = AI.new("Test",rng:NextInteger(0,1) == 0 and true or false) 
		table.insert(self.enemies,ai)
		task.wait(rng:NextInteger(5,9))
	end
	repeat task.wait(0.5) until self.enemiesinround.Value == 0 or workspace:GetAttribute("CastleHealth") <= 0
	if workspace:GetAttribute("CastleHealth") <= 0 then
		return false
	else
		Events.givestatus:FireAllClients("Round Complete.")
		return true
	end
end


function module:Start()
	
	self.enabled = true
	self.round = 1
	local passedrounds = 0
	for i = 1,3 do
		local roundoutcome = self:startRound()
		if roundoutcome == true then
			passedrounds += 1
			self.round += 1
			if passedrounds == 3 then
				Events.givestatus:FireAllClients("You won! New game starting in 5 seconds.")
				task.wait(5)
			else
				Events.givestatus:FireAllClients("New round starts in 5 seconds!")
				task.wait(5)
			end
		else
			for i,v in pairs(self.enemies) do
				v:Destroy()
			end
			Events.givestatus:FireAllClients("Game over! New game begins in 5 seconds.")
			task.wait(5)
			break
		end
	end
	self:Start()
end


function module:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return module
