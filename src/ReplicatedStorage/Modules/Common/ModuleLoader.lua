--[[
ModuleLoader
Module for loading the modules passed to the load function.
]]

local module = {}

module.loadedModules = {}

function module.load(Modules)
	for _, child in pairs(Modules) do
		if child:IsA("ModuleScript") then
			module.loadedModules[child.Name] = require(child)
			task.spawn(function()
				if type(module.loadedModules[child.Name]) == "table" and module.loadedModules[child.Name].new then
					module.loadedModules[child.Name] = module.loadedModules[child.Name].new()
				else
					module.loadedModules[child.Name] = nil
				end
			end)
		elseif child:IsA("Folder") then
			module.load(child:GetChildren())
		end
	end
end

return module
