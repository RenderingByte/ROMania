local DataStoreService = game:GetService("DataStoreService")
local ROManiaDB = DataStoreService:GetDataStore("ROManiaDB")

local DBRemote = game:GetService("ReplicatedStorage").Remotes:WaitForChild("Database")

local function Get(player)
    
    local data
	local success, err = pcall(function()
		data = ROManiaDB:GetAsync(player.UserId)
	end)
	
	if success and data then
		player.Keybinds["1"].Value = data[1]
        player.Keybinds["2"].Value = data[2]
        player.Keybinds["3"].Value = data[3]
        player.Keybinds["4"].Value = data[4]

	    player.ScrollSpeed.Value = data[5]
        player.EffectSpeed.Value = data[6]

        return true
    elseif success and not data then
		print("No data found for player "..player.Name)
        return false
	else
        print("Error while getting data for player "..player.Name)
        warn(err)
        return false
    end
end

local function Set(player)
	
	local dbinfo = {
	    player.Keybinds["1"].Value;
        player.Keybinds["2"].Value;
        player.Keybinds["3"].Value;
        player.Keybinds["4"].Value;

	    player.ScrollSpeed.Value;
        player.EffectSpeed.Value;
	}

    local success, err = pcall(function() ROManiaDB:SetAsync(player.UserId, dbinfo) end)
	
	if success then
		print("Data saved for player "..player.Name)
        return true
	else
		print("Data NOT saved for player "..player.Name)
		warn(err)
        return false
	end
end

-- Automatic Gets/Sets

game.Players.PlayerAdded:Connect(function(player)
    -- Clone Default Settings
    for _, v in pairs(game.ReplicatedStorage.Values:GetChildren()) do
        local item = v:Clone()
        item.Parent = player
    end

    Get(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
    Set(player)
end)

game:BindToClose(function() -- When the server shuts down
	for _, player in pairs(game.Players:GetPlayers()) do
		Set(player)
	end
end)

-- Manual Gets/Sets

DBRemote.OnServerInvoke = function(player, action)
    if action == "Get" then return Get(player)
    elseif action == "Set" then return Set(player) end
end