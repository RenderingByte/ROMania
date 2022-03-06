-- ROMania Engine [In Development]

repeat wait() until game:IsLoaded()

local Player = game.Players.LocalPlayer
local Character = Player.Character

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Maps = ReplicatedStorage.Maps
local Resources = ReplicatedStorage.Resources

local MainMenu = script.Parent.MainMenu

local SongSelect = script.Parent.SongSelect
local PlayBtn = SongSelect.BG.Play
local BackBtn = SongSelect.BG.Back

local PlayField = script.Parent.Playfield
local PlayFieldBG = PlayField.Container.BG
local Notes = PlayField.Container.Notes
local JudgementLine = PlayFieldBG.JudgementLine
local JudgementText = PlayField.Container.JudgementText
local ComboText = PlayField.Container.ComboText
local ScoreText = PlayField.Container.ScoreText
local AccuracyText = PlayField.Container.AccuracyText

local CurrentMap = ReplicatedStorage.Values.CurrentMap.Value
local ScrollSpeed = ReplicatedStorage.Values.ScrollSpeed.Value/10
local EffectSpeed = ReplicatedStorage.Values.EffectSpeed.Value

local Playing = false
local PlayInfo = {
    ["Score"] = 0,
    ["Accuracy"] = 0,
    ["Combo"] = 0,

	["Health"] = 50,
	
	["Misses"] = 0,
	["Bads"] = 0,
	["Goods"] = 0,
	["Greats"] = 0,
	["Perfects"] = 0,
	["Marvelouses"] = 0,
}

local JudgementInfo = {
	["Miss"] = 0.4,
	["Bad"] = 0.3,
	["Good"] = 0.2,
	["Great"] = 0.1,
	["Perfect"] = 0.05,
	["Marvelous"] = 0.025,
}

local ScoreInfo = {
	["Miss"] = 0,
	["Bad"] = 50,
	["Good"] = 100,
	["Great"] = 200,
	["Perfect"] = 300,
	["Marvelous"] = 350,
}

local AccuracyInfo = {
	["Miss"] = 0,
	["Bad"] = 0.50,
	["Good"] = 0.75,
	["Great"] = 0.90,
	["Perfect"] = 1.00,
	["Marvelous"] = 1.00,
}

CountdownLength = 3

function Start()

	if not Maps[CurrentMap]:IsA("ModuleScript") then warn("Failed To Load Map: "..CurrentMap); Reset(); return end
	CurrentMap = require(Maps[CurrentMap])

	SongSelect.Enabled = false
	PlayField.Enabled = true
	
	wait(1)
	for i=0, CountdownLength do
		wait(1)
		game.Workspace.Countdown:Play()
		PlayField.Container.Countdown.Text = CountdownLength-i
	end
	wait(1)

	PlayField.Container.Countdown.Visible = false
	ComboText.Visible = true
	ScoreText.Visible = true
	AccuracyText.Visible = true
	JudgementText.Visible = true

	delay(0,function() RenderNotes() end); wait(1/ScrollSpeed)

	game.Workspace.Music.SoundId = "rbxassetid://"..CurrentMap.id
	game.Workspace.Music:Play()

	Playing = true
end

function Reset()

	for i,v in pairs(PlayInfo) do PlayInfo[i] = 0 end
	PlayInfo["Health"] = 100

	for _,v in pairs(Notes:GetChildren()) do v:Destroy() end
	game.Workspace.Music:Stop()

	PlayField.Container.Countdown.Text = "READY"
	PlayField.Container.Countdown.Visible = true

	ComboText.Visible = false
	ScoreText.Visible = false
	AccuracyText.Visible = false
	JudgementText.Visible = false

	SongSelect.Enabled = false
	PlayField.Enabled = false
	MainMenu.Enabled = true

	MainMenu.BG.NowPlaying.NowPlayingHandler.Disabled = true
	MainMenu.BG.NowPlaying.NowPlayingHandler.Disabled = false

	Playing = false
end

function JudgeHit(close)

	if close == "Miss" then

		JudgementText.Text = "Miss"
		ComboText.Text = "0"
		PlayInfo["Misses"] += 1
		PlayInfo["Score"] += ScoreInfo["Miss"]
		PlayInfo["Combo"] = 0
		PlayInfo["Health"] -= 10

		local miss = ReplicatedStorage.Resources.Miss:Clone()
		miss.Parent = game.Workspace
		miss:Destroy()
	else

		if (close >= JudgementInfo["Miss"]) or (close <= JudgementInfo["Miss"] * -1) then

			JudgementText.Text = "Miss"
			PlayInfo["Misses"] += 1
			PlayInfo["Score"] += ScoreInfo["Miss"]
			PlayInfo["Combo"] = 0
			PlayInfo["Health"] -= 10

			local miss = ReplicatedStorage.Resources.Miss:Clone()
			miss.Parent = game.Workspace
			miss:Destroy()

		elseif (close <= JudgementInfo["Bad"] and close >= 0) or (close <= JudgementInfo["Bad"] * -1 and close <= 0) then

			if (close <= JudgementInfo["Good"] and close >= 0) or (close <= JudgementInfo["Good"] * -1 and close <= 0) then

				if (close <= JudgementInfo["Great"] and close >= 0) or (close <= JudgementInfo["Great"] * -1 and close <= 0) then

					if (close <= JudgementInfo["Perfect"] and close >= 0) or (close <= JudgementInfo["Perfect"] * -1 and close <= 0) then

						if (close <= JudgementInfo["Marvelous"] and close >= 0) or (close <= JudgementInfo["Marvelous"] * -1 and close <= 0) then

							JudgementText.Text = "Marvelous"
							PlayInfo["Marvelouses"] += 1
							PlayInfo["Score"] += ScoreInfo["Marvelous"]
							PlayInfo["Combo"] += 1
							PlayInfo["Health"] += 5
						end
					else
						JudgementText.Text = "Perfect"
						PlayInfo["Perfects"] += 1
						PlayInfo["Score"] += ScoreInfo["Perfect"]
						PlayInfo["Combo"] += 1
						PlayInfo["Health"] += 3
					end
				else
					JudgementText.Text = "Great"
					PlayInfo["Greats"] += 1
					PlayInfo["Score"] += ScoreInfo["Great"]
					PlayInfo["Combo"] += 1
					PlayInfo["Health"] -= 2
				end
			else 
				JudgementText.Text = "Good"
				PlayInfo["Goods"] += 1
				PlayInfo["Score"] += ScoreInfo["Good"]
				PlayInfo["Combo"] += 1
				PlayInfo["Health"] -= 5
			end
		else
			JudgementText.Text = "Bad"
			PlayInfo["Bads"] += 1
			PlayInfo["Score"] += ScoreInfo["Bad"]
			PlayInfo["Combo"] += 1
			PlayInfo["Health"] -= 8
		end
	end

	ComboText.Text = PlayInfo["Combo"]
	ScoreText.Text = PlayInfo["Score"]
end

function PlayEffect(key, transparency)
	TweenService:Create(JudgementLine[key].Effect, TweenInfo.new(EffectSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = transparency}):Play()
end

function KeyPress(key, ispressed)

	local close = math.huge
	local target = nil
	local endpos = 0

	for _, v in pairs(Notes:GetChildren()) do		
		if v.Name == key then
			if v.ImageTransparency == 1 then
				endpos = v.Position.Y.Scale+(v.Base.Endpoint.Position.Y.Scale/10)
			else
				endpos = v.Position.Y.Scale
			end
			
			if math.abs(endpos-JudgementLine.Position.Y.Scale) <= close then
				close = math.abs(endpos-JudgementLine.Position.Y.Scale)
				target = v
			end
		end
	end
	
	if target then
		if ispressed and target.ImageTransparency == 0 then
			if target.Position.Y.Scale >= 0.6-(0.2*ScrollSpeed) then

				if target:FindFirstChild("Base") then
					target.ImageTransparency = 1
				else
					target:Destroy()
				end

				JudgeHit(close)
			end
		elseif not ispressed and target.ImageTransparency == 1 then

			target:Destroy();
			PlayInfo["Combo"] += 1
			ComboText.Text = PlayInfo["Combo"]

			JudgeHit(close)
		end
	end
end

function RenderNotes()

	local last = tick()
	local time = 0

	for i=1, #CurrentMap.notes do
		
		time = last + (CurrentMap.notes[i][1]/1000) + (CurrentMap.offset/1000)
		if tick() <= time then repeat RunService.RenderStepped:Wait() until tick() > time end
		
		if CurrentMap.notes[i][3] then

			local note = Resources.Hold:Clone()
			note.Name = CurrentMap.notes[i][2]
			note.Parent = Notes
			note.AnchorPoint = JudgementLine[CurrentMap.notes[i][2]].AnchorPoint
			note.Position = UDim2.new(JudgementLine[CurrentMap.notes[i][2]].Position.X.Scale,0,-0.2,0)
			
			local tail = note.Base.Tail
			tail.Size = UDim2.new(tail.Size.X.Scale,0,(CurrentMap.notes[i][3]/100)*ScrollSpeed,0)
			
			local endpoint = note.Base.Endpoint
			endpoint.Position = UDim2.new(0,0,-tail.Size.Y.Scale,0)
		else
			local note = Resources.Note:Clone()
			note.Name = CurrentMap.notes[i][2]
			note.Parent = Notes
			note.AnchorPoint = JudgementLine[CurrentMap.notes[i][2]].AnchorPoint
			note.Position = UDim2.new(JudgementLine[CurrentMap.notes[i][2]].Position.X.Scale,0,-0.2,0)
		end
	end

	wait(3) -- map completed, wait x
	Reset()
end

RunService.RenderStepped:Connect(function(delta)
	if Playing then

		PlayInfo["Accuracy"] = ((PlayInfo["Marvelouses"] * AccuracyInfo["Marvelous"]) + (PlayInfo["Perfects"] * AccuracyInfo["Perfect"]) + (PlayInfo["Greats"] * AccuracyInfo["Great"]) + (PlayInfo["Goods"] * AccuracyInfo["Good"]) + (PlayInfo["Bads"] * AccuracyInfo["Bad"]) + (PlayInfo["Misses"] * AccuracyInfo["Miss"])) / PlayInfo["Marvelouses"] + PlayInfo["Perfects"]+ PlayInfo["Greats"] + PlayInfo["Goods"] + PlayInfo["Bads"] + PlayInfo["Misses"]
		PlayInfo["Accuracy"] *= 100
		PlayInfo["Accuracy"] = math.floor(PlayInfo["Accuracy"])
		PlayInfo["Accuracy"] = PlayInfo["Accuracy"] / 100
		AccuracyText.Text = (100-PlayInfo["Accuracy"]).."%"

		if PlayInfo["Health"] >= 100 then PlayInfo["Health"] = 100 end
		if PlayInfo["Health"] <= 0 then Reset() end
		PlayField.Container.HBarBG.HBar.Size = UDim2.new(PlayInfo["Health"]/100, 0,1.1, 0)
		

		PlayField.Container.PBarBG.PBar.Size = UDim2.new(game.Workspace.Music.TimePosition / game.Workspace.Music.TimeLength, 0, 0.7, 0)

		for _, v in pairs(Notes:GetChildren()) do
			
			v.Position = UDim2.new(v.Position.X.Scale, 0, v.Position.Y.Scale+(delta*ScrollSpeed), 0)
			
			if v:FindFirstChild("Base") then
				if v.ImageTransparency == 1 then

					local tail = v.Base.Tail
					local endpoint = v.Base.Endpoint
					local dist = JudgementLine.Position.Y.Scale-(v.Position.Y.Scale+(endpoint.Position.Y.Scale/10))
					local dist2 = (v.Position.Y.Scale-JudgementLine.Position.Y.Scale)*10

					tail.Size = UDim2.new(tail.Size.X.Scale,0,math.clamp(dist*10,0,math.huge),0)
					tail.Position = UDim2.new(tail.Position.X.Scale,0,0.5-dist2,0)

					if v.Position.Y.Scale >= 1-(endpoint.Position.Y.Scale/10) then
						v:Destroy()
						JudgeHit("Miss")
					end
				else
					if v.Position.Y.Scale >= 1 then
						v:Destroy()
						JudgeHit("Miss")
					end
				end
			else
				if v.Position.Y.Scale >= 1 then
					v:Destroy()
					JudgeHit("Miss")
				end
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input)		
	for _,v in pairs(ReplicatedStorage.Values.Keybinds:GetChildren()) do
		if input.KeyCode == Enum.KeyCode[v.Value] then
			if Playing then

				local hs = ReplicatedStorage.Resources.Hitsound:Clone()
				hs.Parent = game.Workspace
				hs:Destroy()

				PlayEffect(v.Name, 0); KeyPress(v.Name, true)
			end
			return
		end
	end

	if input.KeyCode == Enum.KeyCode.Backspace and Playing then Reset() end
end)

UserInputService.InputEnded:Connect(function(input)
	for _,v in pairs(ReplicatedStorage.Values.Keybinds:GetChildren()) do
		if input.KeyCode == Enum.KeyCode[v.Value] then
			PlayEffect(v.Name, 1); KeyPress(v.Name, false)
			return
		end
	end
end)

PlayBtn.MouseButton1Click:Connect(function()
	if ReplicatedStorage.Values.CurrentMap.Value ~= nil and ReplicatedStorage.Values.CurrentMap.Value ~= "" then
		CurrentMap = ReplicatedStorage.Values.CurrentMap.Value
		if game.Players.LocalPlayer.PlayerGui.MenuMusic then game.Players.LocalPlayer.PlayerGui.MenuMusic:Destroy() end
		game.Workspace.Click:Play()
		Start() 
	end
end)

BackBtn.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	Reset()
end)

Character:WaitForChild("Humanoid").Died:Connect(function() Reset() end)