local ReplicatedStorage = game:GetService("ReplicatedStorage")
	
local SongSelect = script.Parent.SongSelect
local BG = SongSelect.BG
local Songs = BG.Songs
local SongInfo = BG.Info

print("Populating Song List... [This could take some time]")

for _, v in pairs(ReplicatedStorage.Maps:GetChildren()) do
		
	local module = require(v)
	local button = ReplicatedStorage.Resources.Song:Clone()
	button.Text = module.mapname.." | "..module.mapdiff
	button.Visible = true
	button.Parent = Songs

	button.MouseButton1Click:Connect(function()

		notes = 0
		holds = 0
		for i=1, #module.notes do
			if module.notes[i][3] then
				holds = holds + 1
			else
				notes = notes + 1
			end
		end

		game.Players.LocalPlayer.CurrentMap.Value = v.Name

		SongInfo.SongName.Text = v.Name
		SongInfo.SongMapArtist.Text = module.songartist.." | "..module.mapcreator
		SongInfo.DifficultyName.Text = module.mapdiff
		SongInfo.Difficulty.Text = "Difficulty: "..module.difficulty
		SongInfo.Objects.Text = "Objects: "..notes+holds
		SongInfo.Notes.Text = "Notes: "..notes
		SongInfo.Holds.Text = "Holds: "..holds
		SongInfo.Background.Image = "rbxassetid://"..module.bgid

		if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MenuMusic") then
			game.Players.LocalPlayer.PlayerGui.MenuMusic.SoundId = "rbxassetid://"..module.id
			game.Players.LocalPlayer.PlayerGui.MenuMusic:Play()
		end
	end)

	button.MouseEnter:Connect(function()
		game.Workspace.Hover:Play()
		button.TextColor3 = Color3.fromRGB(0,255,0)
	end)
	
	button.MouseLeave:Connect(function()
		button.TextColor3 = Color3.fromRGB(255,255,255)
	end)
end

print("Song List Populated")

-- Song Search
local Search = SongSelect.BG.Search

function update()
	local query = string.lower(Search.Text)
	for _, v in pairs(Songs:GetChildren()) do
		if v:IsA("GuiButton") then
			if query ~= "" then
				if string.find(string.lower(v.Text), query) then
					v.Visible = true
				else
					v.Visible = false
				end
			end
		end
	end
end

Search.Changed:Connect(update)