local CameraStart = game.Workspace.MenuBGPart.Camera
local camera = workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()

Connection = camera:GetPropertyChangedSignal("CameraType"):Connect(function()
    if camera.CameraType ~= Enum.CameraType.Scriptable then
        camera.CameraType = Enum.CameraType.Scriptable
    end
end)

camera.CameraType = Enum.CameraType.Scriptable
camera.CFrame = CameraStart.CFrame

mouse.Move:Connect(function()
    camera.CFrame = CFrame.new(mouse.UnitRay.Direction.X, mouse.UnitRay.Direction.Y, mouse.UnitRay.Direction.Z) * CFrame.Angles(0, math.rad(180), 0) + Vector3.new(CameraStart.Position.X, CameraStart.Position.Y, CameraStart.Position.Z)
end)