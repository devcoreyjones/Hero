--[[
EffectHandler
Module code for handling the effects. This module is connected to an OnClientEvent which runs the code of the effect based on the name passed to it.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local showMoveEff = ReplicatedStorage.Events:WaitForChild("showMoveEff",30)
local Sounds = game:GetService("SoundService")

local effectCreation = {}

effectCreation["Explosion"] = function(pos)
	task.spawn(function()
		local explosion = ReplicatedStorage.Assets.VFX.Explosion:Clone()	
		explosion.Position = pos
		explosion.Anchored = true
		explosion.CanCollide = false
		explosion.Parent = workspace
		explosion.Fire.Enabled = true
		explosion.Fire2.Enabled = true
		explosion.Wave.Enabled = true
		local sfx = game.SoundService.Audio.SoundEffects.Explosion:Clone()
		sfx.Parent = explosion
		sfx:Destroy()
		task.wait(0.5)
		explosion.Fire.Enabled = false
		explosion.Fire2.Enabled = false
		explosion.Wave.Enabled = false
		task.wait(2)
		explosion:Destroy()
	end)
end

effectCreation["WaterExplosion"] = function(pos)
	task.spawn(function()
		local explosion = ReplicatedStorage.Assets.VFX.WaterExplosion:Clone()	
		explosion.Position = pos
		explosion.Parent = workspace
		local sfx = game.SoundService.Audio.SoundEffects.waterHit:Clone()
		sfx.Parent = explosion
		sfx:Destroy()
		task.wait(0.5)
		explosion.Attachment.Trail.Enabled = false
		explosion.explode.Enabled = false
		task.wait(2)
		explosion:Destroy()
	end)
end

effectCreation["DeathSound"] = function()
	local sfx = Sounds.Audio.SoundEffects.Bonk:Clone()
	sfx.Parent = game.Players.LocalPlayer.PlayerGui
	sfx:Destroy()
end

effectCreation["FireBall"] = function(...)
	local args = table.unpack({...})
	local placeholder = args[1]
	local fireball = ReplicatedStorage.Assets.Moves.Fireball:Clone()
	fireball.CFrame = placeholder.CFrame
	fireball.Parent = workspace
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = fireball
	attach.Part1 = placeholder
	attach.Parent = fireball

	placeholder.AncestryChanged:Connect(function(_, parent)
		if not parent then
			effectCreation["Explosion"](fireball.Position)
			fireball:Destroy()
		end
	end)
end

effectCreation["Zap"] = function(...)
	local args = table.unpack({...})
	local placeholder = args[1]

	local zap = ReplicatedStorage.Assets.Moves.Zap:Clone()
	zap.CFrame = placeholder.CFrame
	zap.Parent = workspace
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = zap
	attach.Part1 = placeholder
	attach.Parent = zap

	placeholder.AncestryChanged:Connect(function(_, parent)
		if not parent then
			zap:Destroy()
		end
	end)
end

effectCreation["Chill"] = function(...)
	local args = table.unpack({...})
	local placeholder = args[1]

	local chill = ReplicatedStorage.Assets.Moves.Chill:Clone()
	chill.CFrame = placeholder.CFrame
	chill.Parent = workspace
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = chill
	attach.Part1 = placeholder
	attach.Parent = chill

	placeholder.AncestryChanged:Connect(function(_, parent)
		if not parent then
			chill:Destroy()
		end
	end)
end

effectCreation["BubbleDrop"] = function(...)
	local args = table.unpack({...})
	local placeholder = args[1]

	local bubble = ReplicatedStorage.Assets.Moves.BubbleDrop:Clone()
	bubble:SetPrimaryPartCFrame(placeholder.CFrame)
	bubble.Parent = workspace
	local attach = Instance.new("WeldConstraint")
	attach.Part0 = bubble.PrimaryPart
	attach.Part1 = placeholder
	attach.Parent = bubble.PrimaryPart

	placeholder.AncestryChanged:Connect(function(_, parent)
		if not parent then
			effectCreation["WaterExplosion"](bubble.PrimaryPart.Position)
			bubble:Destroy()
		end
	end)
end

showMoveEff.OnClientEvent:Connect(function(...)
	local args = {...}
	effectCreation[args[2]](args)
end)


return effectCreation
