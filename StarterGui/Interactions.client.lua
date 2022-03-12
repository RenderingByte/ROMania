local Startup = script.Parent:WaitForChild("Startup")
local MainMenu = script.Parent.MainMenu
local SongSelect = script.Parent.SongSelect
local PlayField = script.Parent.Playfield
local Results = script.Parent:WaitForChild("Results")
local Options = script.Parent:WaitForChild("Options")
local About = script.Parent:WaitForChild("About")

local Players = game:GetService("Players")

local DBRemote = game:GetService("ReplicatedStorage").Remotes:WaitForChild("Database")
local OptionsRemote = game:GetService("ReplicatedStorage").Remotes:WaitForChild("UpdateOptions")

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
	MainMenu.BG.Options.TextColor3 = Color3.fromRGB(255,255,255)
end)

MainMenu.BG.Play.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	MainMenu.BG.Play.TextColor3 = Color3.fromRGB(0,255,0)
end)

MainMenu.BG.Play.MouseLeave:Connect(function()
	MainMenu.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

MainMenu.BG.Options.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	MainMenu.Enabled = false
	Options.Enabled = true
	MainMenu.BG.Options.TextColor3 = Color3.fromRGB(255,255,255)
end)

MainMenu.BG.Options.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	MainMenu.BG.Options.TextColor3 = Color3.fromRGB(0,255,0)
end)

MainMenu.BG.Options.MouseLeave:Connect(function()
	MainMenu.BG.Options.TextColor3 = Color3.fromRGB(255,255,255)
end)

MainMenu.BG.About.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	MainMenu.Enabled = false
	About.Enabled = true
	MainMenu.BG.About.TextColor3 = Color3.fromRGB(255,255,255)
end)

MainMenu.BG.About.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	MainMenu.BG.About.TextColor3 = Color3.fromRGB(0,255,0)
end)

MainMenu.BG.About.MouseLeave:Connect(function()
	MainMenu.BG.About.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- Song Select

SongSelect.BG.Back.MouseButton1Click:Connect(function()
	SongSelect.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

SongSelect.BG.Back.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	SongSelect.BG.Back.TextColor3 = Color3.fromRGB(0,255,0)
end)

SongSelect.BG.Back.MouseLeave:Connect(function()
	SongSelect.BG.Back.TextColor3 = Color3.fromRGB(255,255,255)
end)

SongSelect.BG.Play.MouseButton1Click:Connect(function()
	SongSelect.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

SongSelect.BG.Play.MouseEnter:Connect(function()
	game.Workspace.Hover:Play()
	SongSelect.BG.Play.TextColor3 = Color3.fromRGB(0,255,0)
end)

SongSelect.BG.Play.MouseLeave:Connect(function()
	SongSelect.BG.Play.TextColor3 = Color3.fromRGB(255,255,255)
end)

-- Options

for i=1, 4 do Options.BG.General.Keybinds[i].Text = game.Players.LocalPlayer.Keybinds[i].Value end
Options.BG.General.ScrollSpeed.Input.Text = game.Players.LocalPlayer.ScrollSpeed.Value
Options.BG.General.HitLightingSpeed.Input.Text = game.Players.LocalPlayer.HitLightingSpeed.Value
Options.BG.General.HitPosY.Input.Text = game.Players.LocalPlayer.HitPosY.Value

local accepting_binds = false

function UpdateKeybind(j)
	game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
		
		if not accepting_binds then return end

		local found = false
		for _,v in pairs(game.Players.LocalPlayer.Keybinds:GetChildren()) do
			if string.upper(v.Value) == string.upper(key) then
				found = true

				local m = Options.BG.General.Keybinds[v.Name]
				local c = Options.BG.General.Keybinds[j]
				
				m.Text = c.Text
				c.Text = string.upper(key)
				break
			end
		end

		if not found then
			Options.BG.General.Keybinds[j].Text = string.upper(key)
		end

		accepting_binds = false
	end)
end

Options.BG.General.Keybinds["1"].MouseButton1Click:Connect(function()
	accepting_binds = true
	UpdateKeybind(1)
end)

Options.BG.General.Keybinds["2"].MouseButton1Click:Connect(function()
	accepting_binds = true
	UpdateKeybind(2)
end)

Options.BG.General.Keybinds["3"].MouseButton1Click:Connect(function()
	accepting_binds = true
	UpdateKeybind(3)
end)

Options.BG.General.Keybinds["4"].MouseButton1Click:Connect(function()
	accepting_binds = true
	UpdateKeybind(4)
end)

Options.BG.General.ScrollSpeed.Input:GetPropertyChangedSignal("Text"):Connect(function()
	Options.BG.General.ScrollSpeed.Input.Text = Options.BG.General.ScrollSpeed.Input.Text:gsub('%D+', '')
end)

Options.BG.General.HitLightingSpeed.Input:GetPropertyChangedSignal("Text"):Connect(function()
	Options.BG.General.HitLightingSpeed.Input.Text = Options.BG.General.HitLightingSpeed.Input.Text:gsub('%D+', '')
end)

Options.BG.General.HitPosY.Input:GetPropertyChangedSignal("Text"):Connect(function()
	Options.BG.General.HitPosY.Input.Text = Options.BG.General.HitPosY.Input.Text:gsub('%D+', '')
end)

Options.BG.Categories.General.MouseButton1Click:Connect(function()
	Options.BG.General.Visible = true
end)

Options.BG.Back.MouseButton1Click:Connect(function()
	Options.BG.General.Visible = false
	Options.Enabled = false
	MainMenu.Enabled = true
end)

Options.BG.Save.MouseButton1Click:Connect(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Saving",
		Text = "Saving Your Settings. Please Wait.",
		Duration = 3
	})
	game.Workspace.Click:Play()

	OptionsRemote:FireServer(
		Options.BG.General.Keybinds["1"].Text,
		Options.BG.General.Keybinds["2"].Text,
		Options.BG.General.Keybinds["3"].Text,
		Options.BG.General.Keybinds["4"].Text,
		Options.BG.General.ScrollSpeed.Input.Text,
		Options.BG.General.HitLightingSpeed.Input.Text,
		Options.BG.General.HitPosY.Input.Text
	)

	local success = DBRemote:InvokeServer("Set")
	if success then
		success = DBRemote:InvokeServer("Get")
		if success then
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Saved Successfully",
				Text = "Your settings have been saved.",
				Duration = 5
			})
		end
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Settings Not Saved",
			Text = "An error occured while saving your settings. No changes were made.",
			Duration = 5
		})
	end
end)

-- About

About.BG.Close.MouseButton1Click:Connect(function()
	About.Enabled = false
	MainMenu.Enabled = true
end)