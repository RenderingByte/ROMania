local MainMenu = script.Parent.MainMenu
local SongSelect = script.Parent.SongSelect
local PlayField = script.Parent.Playfield

-- Main Menu

script.Parent.MainMenu.BG.Play.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	script.Parent.MainMenu.Enabled = false
	script.Parent.SongSelect.Enabled = true
end)

script.Parent.MainMenu.BG.Play.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	script.Parent.MainMenu.BG.Play.TextColor3 = Color3.fromRGB(0,255,0)
end)

script.Parent.MainMenu.BG.Play.MouseLeave:Connect(function()
	script.Parent.MainMenu.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- Song Select

script.Parent.SongSelect.BG.Back.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	script.Parent.SongSelect.BG.Back.TextColor3 = Color3.fromRGB(0,255,0)
end)

script.Parent.SongSelect.BG.Back.MouseLeave:Connect(function()
	script.Parent.SongSelect.BG.Back.TextColor3 = Color3.fromRGB(255,255,255)
end)

script.Parent.SongSelect.BG.Play.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	script.Parent.SongSelect.BG.Play.TextColor3 = Color3.fromRGB(0,255,0)
end)

script.Parent.SongSelect.BG.Play.MouseLeave:Connect(function()
	script.Parent.SongSelect.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)