--[[
ClientInit
Main Driver for Client.
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local ClientHandler = require(ReplicatedStorage.Modules.Standalones.ClientHandler).new()
print(workspace:GetServerTimeNow())
