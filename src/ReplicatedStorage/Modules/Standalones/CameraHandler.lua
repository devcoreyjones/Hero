--[[
CameraHandler
Module code for updating the Camera's view to the desired camera subject.
]]

return function(camsubject)
	local camera = workspace.CurrentCamera
	if camsubject == "Player" then
		camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		camera.CameraType = Enum.CameraType.Custom
	else
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CameraSubject = camsubject
		camera.CFrame =  camsubject.CFrame
	end
end