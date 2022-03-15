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

local MainMenu = script.Parent:WaitForChild("MainMenu")

local SongSelect = script.Parent:WaitForChild("SongSelect")
local PlayBtn = SongSelect.BG.Play
local BackBtn = SongSelect.BG.Back

local PlayField = script.Parent:WaitForChild("Playfield")
local PlayFieldBG = PlayField.Container.BG
local Notes = PlayField.Container.Notes
local JudgementLine = PlayFieldBG.JudgementLine
local JudgementText = PlayField.Container.JudgementText
local ComboText = PlayField.Container.ComboText
local ScoreText = PlayField.Container.ScoreText
local AccuracyText = PlayField.Container.AccuracyText

local Results = script.Parent:WaitForChild("Results")

local CurrentMap = Player.CurrentMap.Value
local ScrollSpeed = Player.ScrollSpeed.Value/10
local HitLightingSpeed = Player.HitLightingSpeed.Value
local HitPosY = Player.HitPosY.Value/1000

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

	["MA"] = 0,
	["PA"] = 0,

	["Failed"] = nil,
}

local JudgementInfo = {
	["Ghost"] = HitPosY-(0.2*ScrollSpeed),
	["Miss"] = ((ScrollSpeed*10)/1)/100, -- 0.2
	["Bad"] = ((ScrollSpeed*10)/1.33)/100, -- 0.15
	["Good"] = ((ScrollSpeed*10)/1.6)/100, -- 0.125
	["Great"] = ((ScrollSpeed*10)/2.66)/100, -- 0.075
	["Perfect"] = ((ScrollSpeed*10)/5.7)/100, -- 0.035
	["Marvelous"] = ((ScrollSpeed*10)/19.9)/100, -- 0.01
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
	["Bad"] = 75,
	["Good"] = 80,
	["Great"] = 95,
	["Perfect"] = 100,
	["Marvelous"] = 100,
}

local CountdownLength = 3

function Start()

	if not Maps[CurrentMap]:IsA("ModuleScript") then warn("Failed To Load Map: "..CurrentMap); Reset(); return end
	CurrentMap = require(Maps[CurrentMap])

	ScrollSpeed = Player.ScrollSpeed.Value/10
	HitLightingSpeed = Player.HitLightingSpeed.Value
	HitPosY = Player.HitPosY.Value/1000

	PlayField.Container.BG.JudgementLine.Position = UDim2.new(0, 0, HitPosY, 0)

	SongSelect.Enabled = false
	PlayField.Enabled = true
	
	CountdownLength = CurrentMap.CountdownLength or CountdownLength

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

	Playing = true
	delay(0,function() RenderNotes() end); wait(1/ScrollSpeed)

	game.Workspace.Music.SoundId = "rbxassetid://"..CurrentMap.id
	game.Workspace.Music:Play()
end

function Reset()

	Playing = false
	for _,v in pairs(Notes:GetChildren()) do v:Destroy() end
	game.Workspace.Music:Stop()
	
	PlayField.Container.Countdown.Text = "READY"
	PlayField.Container.Countdown.Visible = true

	JudgementText.Text = ""

	ComboText.Visible = false
	ScoreText.Visible = false
	AccuracyText.Visible = false
	JudgementText.Visible = false

	SongSelect.Enabled = false
	PlayField.Enabled = false

	if PlayInfo["Failed"] ~= nil then

		MainMenu.Enabled = false
		Results.Enabled = true

		if PlayInfo["Failed"] then
			Results.BG.Passed.TextColor3 = Color3.new(1,0,0)
			Results.BG.Passed.Text = "Failed"
			Resources.FailMusic:Play()
		else
			Results.BG.Passed.TextColor3 = Color3.new(0,1,0)
			Results.BG.Passed.Text = "Passed"
			Resources.PassMusic:Play()
		end
		Results.BG.Score.Text = "Total Score: "..PlayInfo["Score"]
		Results.BG.Accuracy.Text = "Accuracy: "..(tonumber(string.format("%." .. 2 .. "f", PlayInfo["Accuracy"]))).."%"
		Results.BG.Difficulty.Text = "Difficulty: ".. (tonumber(string.format("%." .. 0 .. "f", CurrentMap.difficulty/(PlayInfo["Accuracy"]/10))))
		Results.BG.Marvelouses.Text = "Marvelouses: "..PlayInfo["Marvelouses"]
		Results.BG.Perfects.Text = "Perfects: "..PlayInfo["Perfects"]
		Results.BG.Greats.Text = "Greats: "..PlayInfo["Greats"]
		Results.BG.Goods.Text = "Goods: "..PlayInfo["Goods"]
		Results.BG.Bads.Text = "Bads: "..PlayInfo["Bads"]
		Results.BG.Misses.Text = "Misses: "..PlayInfo["Misses"]
		Results.BG.MA.Text = "MA: "..(tonumber(string.format("%." .. 2 .. "f", PlayInfo["MA"])))
		Results.BG.PA.Text = "PA: "..(tonumber(string.format("%." .. 2 .. "f", PlayInfo["PA"])))
	else
		MainMenu.Enabled = true
		Results.Enabled = false
	end

	for i,_ in pairs(PlayInfo) do PlayInfo[i] = 0 end
	PlayInfo["Health"] = 50
	PlayInfo["Failed"] = nil
end

function JudgeHit(close)

	JudgementText.Size = UDim2.new(0.001, 0, 0.001, 0)

	if close == "Miss" then

		JudgementText.TextColor3 = Color3.new(1,0,0)
		JudgementText.Text = "Miss"
		ComboText.Text = "0"
		PlayInfo["Misses"] += 1
		PlayInfo["Score"] += ScoreInfo["Miss"]
		PlayInfo["Combo"] = 0
		PlayInfo["Health"] -= 5

		local miss = ReplicatedStorage.Resources.Miss:Clone()
		miss.Parent = game.Workspace
		miss:Destroy()

		JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)

		return
	else

		if (close >= JudgementInfo["Miss"]) or (close <= JudgementInfo["Miss"] * -1) then

			JudgementText.TextColor3 = Color3.new(1,0,0)
			JudgementText.Text = "Miss"
			PlayInfo["Misses"] += 1
			PlayInfo["Score"] += ScoreInfo["Miss"]
			PlayInfo["Combo"] = 0
			PlayInfo["Health"] -= 5

			local miss = ReplicatedStorage.Resources.Miss:Clone()
			miss.Parent = game.Workspace
			miss:Destroy()

			JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)

			return

		elseif (close < JudgementInfo["Miss"] and close >= 0) or (close <= JudgementInfo["Miss"] * -1 and close <= 0) then

			if (close <= JudgementInfo["Bad"] and close >= 0) or (close <= JudgementInfo["Bad"] * -1 and close <= 0) then

				if (close <= JudgementInfo["Good"] and close >= 0) or (close <= JudgementInfo["Good"] * -1 and close <= 0) then

					if (close <= JudgementInfo["Great"] and close >= 0) or (close <= JudgementInfo["Great"] * -1 and close <= 0) then

						if (close <= JudgementInfo["Perfect"] and close >= 0) or (close <= JudgementInfo["Perfect"] * -1 and close <= 0) then

							if (close <= JudgementInfo["Marvelous"] and close >= 0) or (close <= JudgementInfo["Marvelous"] * -1 and close <= 0) then
								JudgementText.TextColor3 = Color3.new(0,0.5,1)
								JudgementText.Text = "Marvelous"
								PlayInfo["Marvelouses"] += 1
								PlayInfo["Score"] += ScoreInfo["Marvelous"]
								PlayInfo["Health"] += 5
								PlayInfo["Combo"] += 1
								JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
								return
							else
								JudgementText.TextColor3 = Color3.new(0,0.5,1)
								JudgementText.Text = "Marvelous"
								PlayInfo["Marvelouses"] += 1
								PlayInfo["Score"] += ScoreInfo["Marvelous"]
								PlayInfo["Health"] += 5
								PlayInfo["Combo"] += 1
								JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
								return
							end
						else
							JudgementText.TextColor3 = Color3.new(1,1,0)
							JudgementText.Text = "Perfect"
							PlayInfo["Perfects"] += 1
							PlayInfo["Score"] += ScoreInfo["Perfect"]
							PlayInfo["Health"] += 3
							PlayInfo["Combo"] += 1
							JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
							return
						end
					else
						JudgementText.TextColor3 = Color3.new(0,1,0)
						JudgementText.Text = "Great"
						PlayInfo["Greats"] += 1
						PlayInfo["Score"] += ScoreInfo["Great"]
						PlayInfo["Health"] -= 2
						PlayInfo["Combo"] += 1
						JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
						return
					end
				else
					JudgementText.TextColor3 = Color3.fromRGB(255, 230, 0)
					JudgementText.Text = "Good"
					PlayInfo["Goods"] += 1
					PlayInfo["Score"] += ScoreInfo["Good"]
					PlayInfo["Health"] -= 3
					PlayInfo["Combo"] += 1
					JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
					return
				end
			else
				JudgementText.TextColor3 = Color3.fromRGB(255, 0, 128)
				JudgementText.Text = "Bad"
				PlayInfo["Bads"] += 1
				PlayInfo["Score"] += ScoreInfo["Bad"]
				PlayInfo["Health"] -= 4
				PlayInfo["Combo"] += 1
				JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
				return
			end
		else
			JudgementText.TextColor3 = Color3.new(1,0,0)
			JudgementText.Text = "Miss"
			PlayInfo["Misses"] += 1
			PlayInfo["Score"] += ScoreInfo["Miss"]
			PlayInfo["Health"] -= 5
			PlayInfo["Combo"] = 0
			JudgementText:TweenSize(UDim2.new(1, 0, 0.075, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.05, false)
			local miss = ReplicatedStorage.Resources.Miss:Clone()
			miss.Parent = game.Workspace
			miss:Destroy()
			return
		end
	end
end

function PlayEffect(key, transparency)
	TweenService:Create(JudgementLine[key].Effect, TweenInfo.new(HitLightingSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = transparency}):Play()
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
			
			if math.abs(endpos-HitPosY) <= close then
				close = math.abs(endpos-HitPosY)
				target = v
			end
		end
	end
	
	if target then
		if ispressed and target.ImageTransparency == 0 then
			if target.Position.Y.Scale >= JudgementInfo["Ghost"] then

				if target:FindFirstChild("Base") then
					target.ImageTransparency = 1
				else
					target:Destroy()
				end
				
				-- Judge both hit & release
				JudgeHit(close)
			end
		elseif not ispressed and target.ImageTransparency == 1 then
			target:Destroy();
			JudgeHit(close)
		end
	end
end

function RenderNotes()

	local last = tick()
	local time = 0

	for i=1, #CurrentMap.notes do
		
		if Playing then

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
		else break end
	end

	wait(3)

	if PlayField.Enabled == true then
		PlayInfo["Failed"] = false
		Reset()
	end
end

RunService.RenderStepped:Connect(function(delta)
	if Playing then

		ComboText.Text = PlayInfo["Combo"]
		ScoreText.Text = PlayInfo["Score"]

		PlayInfo["Accuracy"] = (AccuracyInfo["Marvelous"] * PlayInfo["Marvelouses"] + AccuracyInfo["Perfect"] * PlayInfo["Perfects"] + AccuracyInfo["Great"] * PlayInfo["Greats"] + AccuracyInfo["Good"] * PlayInfo["Goods"] + AccuracyInfo["Bad"] * PlayInfo["Bads"]) / (PlayInfo["Marvelouses"] + PlayInfo["Perfects"] + PlayInfo["Greats"] + PlayInfo["Goods"] + PlayInfo["Bads"] + PlayInfo["Misses"])
		
		PlayInfo["MA"] = PlayInfo["Marvelouses"] / PlayInfo["Perfects"]
		PlayInfo["PA"] = PlayInfo["Perfects"] / PlayInfo["Greats"]

		-- NaN Bypass
		if PlayInfo["Accuracy"] ~= PlayInfo["Accuracy"] then PlayInfo["Accuracy"] = 0 end
		AccuracyText.Text = (tonumber(string.format("%." .. 2 .. "f", PlayInfo["Accuracy"]))).."%"

		if PlayInfo["Health"] >= 100 then PlayInfo["Health"] = 100 end
		if PlayInfo["Health"] <= 0 then PlayInfo["Failed"] = true; Reset() end
		PlayField.Container.HBarBG.HBar:TweenSize(UDim2.new(PlayInfo["Health"]/100, 0,1.1, 0), "Out", "Quint", 0.25)

		PlayField.Container.PBarBG.PBar.Size = UDim2.new(game.Workspace.Music.TimePosition / game.Workspace.Music.TimeLength, 0, 0.7, 0)

		for _, v in pairs(Notes:GetChildren()) do
			
			v.Position = UDim2.new(v.Position.X.Scale, 0, v.Position.Y.Scale + (delta * ScrollSpeed), 0)
			
			if v:FindFirstChild("Base") then
				if v.ImageTransparency == 1 then

					local tail = v.Base.Tail
					local endpoint = v.Base.Endpoint
					local dist = HitPosY-(v.Position.Y.Scale+(endpoint.Position.Y.Scale/10))
					local dist2 = (v.Position.Y.Scale-HitPosY)*10

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
	for _,v in pairs(game.Players.LocalPlayer.Keybinds:GetChildren()) do
		if UserInputService:GetStringForKeyCode(input.KeyCode) == v.Value then
			if Playing then

				local hs = ReplicatedStorage.Resources.Hitsound:Clone()
				hs.Parent = game.Workspace
				hs:Destroy()

				PlayEffect(v.Name, 0); KeyPress(v.Name, true)
			end
			return
		end
	end

	if input.KeyCode == Enum.KeyCode.Backspace and Playing then PlayInfo["Failed"] = true; Reset() end
end)

UserInputService.InputEnded:Connect(function(input)
	for _,v in pairs(game.Players.LocalPlayer.Keybinds:GetChildren()) do
		if UserInputService:GetStringForKeyCode(input.KeyCode) == v.Value then
			PlayEffect(v.Name, 1); KeyPress(v.Name, false)
			return
		end
	end
end)

PlayBtn.MouseButton1Click:Connect(function()
	if Player.CurrentMap.Value ~= nil and Player.CurrentMap.Value ~= "" then
		CurrentMap = Player.CurrentMap.Value
		if Player.PlayerGui.MenuMusic then Player.PlayerGui.MenuMusic:Destroy() end
		game.Workspace.Click:Play()
		Start() 
	end
end)

BackBtn.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	Reset()
end)

Results.BG.Back.MouseButton1Click:Connect(function()
	game.Workspace.Click:Play()
	Results.Enabled = false
	MainMenu.Enabled = true
	MainMenu.BG.NowPlaying.NowPlayingHandler.Disabled = true
	MainMenu.BG.NowPlaying.NowPlayingHandler.Disabled = false
end)

Character:WaitForChild("Humanoid").Died:Connect(function() Reset() end)