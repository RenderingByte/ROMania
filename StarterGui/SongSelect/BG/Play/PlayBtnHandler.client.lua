script.Parent.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	script.Parent.TextColor3 = Color3.fromRGB(0,255,0)
end)

script.Parent.MouseLeave:Connect(function()
	script.Parent.TextColor3 = Color3.fromRGB(255,255,255)
end)