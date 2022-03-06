script.Parent.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	script.Parent.Parent.Parent.Enabled = false
	script.Parent.Parent.Parent.Parent.SongSelect.Enabled = true
end)

script.Parent.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	script.Parent.TextColor3 = Color3.fromRGB(0,255,0)
end)

script.Parent.MouseLeave:Connect(function()
	script.Parent.TextColor3 = Color3.fromRGB(255,255,255)
end)