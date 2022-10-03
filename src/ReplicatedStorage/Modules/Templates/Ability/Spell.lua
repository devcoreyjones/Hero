--[[
Spell
Template module for the player abilities. This is a skeleton module that contains functions used in all move modules. Move modules will
overwrite the unique events, such as playEffect, with thier own implementations of it.
]]


local module = setmetatable({}, {__index = require(script.Parent)})

function module:playEffect()
	
end

function module:Unbind()

end

function module:GetMousePoint(X, Y, allowHumanoidTargets)
	if self.Mouse.Target ~= nil and self.Mouse.Target.Parent:IsA("Model") == true and self.Mouse.Target.Parent ~= workspace  and self.Mouse.Target.Parent:FindFirstChild("Humanoid") ~= nil then
		--	print(mouse.Target.Parent.Name)
		if allowHumanoidTargets == nil then
			return self.Mouse.hit
		end
		if allowHumanoidTargets and allowHumanoidTargets == true then
			return self.Mouse.Target.Parent.HumanoidRootPart
		end
	end--]]
	local RayMag1 = self.Camera:ScreenPointToRay(X, Y) --Hence the var name, the magnitude of this is 1.
	local NewRay = Ray.new(self.Player.Character.Head.Position, RayMag1.Direction * 1000)
	local Target, Position = workspace:FindPartOnRayWithIgnoreList(NewRay, {self.Player.Character})
	--[[local beam = Instance.new("Part", workspace)
		beam.BrickColor = BrickColor.new("Bright red")
		beam.FormFactor = "Custom"
		beam.Material = "Neon"
		beam.Transparency = 0.25
		beam.Anchored = true
		beam.Locked = true
		beam.CanCollide = false
		local distance = (Player.Character.Head.Position - Position).magnitude
		beam.Size = Vector3.new(0.3, 0.3, distance)
		beam.CFrame = CFrame.new(Player.Character.Head.Position , Position) * CFrame.new(0, 0, -distance / 2) 
		game:GetService("Debris"):AddItem(beam, 5)--]]
	if (Target) and (Target or Position == nil) or self.Mouse.hit then
		return self.Mouse.hit
	else
		return Position
	end
end

function module:Activate()
	self:Use()
end

return module
