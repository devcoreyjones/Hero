--[[
ServerInit
Main Driver for Client.
]]


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

require(ReplicatedStorage.Modules.Common.ModuleLoader).load(ServerStorage.Modules.Drivers:GetChildren())