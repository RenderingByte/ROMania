local NextSongInterval = 2

local module
local song

local function PlaySong()
	local r = math.random(1, #game.ReplicatedStorage.Maps:GetChildren())
	
	for i,v in pairs(game.ReplicatedStorage.Maps:GetChildren()) do
		if i == r then
			module = v
		end
	end
	
	module = require(module)

	local found = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MenuMusic")
	if found then game.Players.LocalPlayer.PlayerGui.MenuMusic:Destroy() end
	
	song = Instance.new("Sound")
	song.Parent = game.Players.LocalPlayer.PlayerGui
	song.Name = "MenuMusic"
	song.SoundId = "rbxassetid://"..module.id
	song:Play()
end

PlaySong()

while wait() do
	if not song.IsPlaying then
		song:Destroy()
		script.Parent.SongName.Text = "Selecting Next Song..."
		script.Parent.PBarBG.PBar.Size = UDim2.new(0, 0,0.05, 0)
		wait(NextSongInterval)
		PlaySong()
	else
		local seconds = math.floor(song.TimeLength - song.TimePosition)
		
		local min, sec = tostring(math.floor(seconds/60)), tostring(seconds%60)
		if #sec == 1 then sec = sec.."0" end
		local Time = tostring(min)..":"..tostring(sec)
		
		script.Parent.SongName.Text = module.mapname.." ("..Time..")"
		script.Parent.PBarBG.PBar.Size = UDim2.new(song.TimePosition / song.TimeLength, 0, 0.7, 0)

		local volume = song.PlaybackLoudness * 0.6
		for _,v in pairs(script.Parent.Parent.AV:GetChildren()) do
			if not v:IsA("UIListLayout") then
				v:TweenSize(UDim2.new(0.012,0,volume/math.random(300,750),0),"Out","Quad",0)
			end
		end
	end
end