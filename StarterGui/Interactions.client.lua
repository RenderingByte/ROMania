local Startup = script.Parent:WaitForChild("Startup")
local MainMenu = script.Parent.MainMenu
local SongSelect = script.Parent.SongSelect
local PlayField = script.Parent.Playfield
local Results = script.Parent:WaitForChild("Results")

local DBRemote = game:GetService("ReplicatedStorage").Remotes:WaitForChild("Database")

local clicked = true

-- Startup

wait(2)

Startup.BG.Title:TweenPosition(
	UDim2.new(0.5, 0, 0.35, 0),
	Enum.EasingDirection.In,
	Enum.EasingStyle.Sine,
	1,
	true
)
wait(1)
Startup.BG.Status.Visible = true
Startup.BG.PressAnyKey:TweenSizeAndPosition(UDim2.new(0.4, 0, 0.1, 0), UDim2.new(0.5, 0, 0.7, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.5)

local clicked = false
game:GetService("UserInputService").InputBegan:Connect(function()
    if not clicked then
        clicked = true
        MainMenu.Enabled = true
        Startup.Enabled = false
    end
end)

-- Main Menu

MainMenu.BG.Play.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	MainMenu.Enabled = false
	SongSelect.Enabled = true
end)

MainMenu.BG.Play.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	MainMenu.BG.Play.TextColor3 = Color3.fromRGB(0,255,0)
end)

MainMenu.BG.Play.MouseLeave:Connect(function()
	MainMenu.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- Song Select

SongSelect.BG.Back.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	SongSelect.BG.Back.TextColor3 = Color3.fromRGB(0,255,0)
end)

SongSelect.BG.Back.MouseLeave:Connect(function()
	SongSelect.BG.Back.TextColor3 = Color3.fromRGB(255,255,255)
end)

SongSelect.BG.Play.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	SongSelect.BG.Play.TextColor3 = Color3.fromRGB(0,255,0)
end)

SongSelect.BG.Play.MouseLeave:Connect(function()
	SongSelect.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- TEMP [WIP to be implemented in options page]:
while wait(5) do
	local success = DBRemote:InvokeServer("Set")
	if success then
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Saved Successfully",
			Text = "Your settings have been saved.",
			Duration = 5
		})
	end
end