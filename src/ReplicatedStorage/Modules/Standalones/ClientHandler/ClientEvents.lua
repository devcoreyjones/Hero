local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module = {}

repeat RunService.Heartbeat:Wait() until ReplicatedStorage:FindFirstChild("Events")
module.Events = ReplicatedStorage.Events

return module