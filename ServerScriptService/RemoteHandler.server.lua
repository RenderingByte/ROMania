local KeybindRemote = game.ReplicatedStorage.Remotes.UpdateKeybind

KeybindRemote.OnServerEvent:Connect(function(player, k1, k2, k3, k4)
    player.Keybinds["1"].Value = k1
    player.Keybinds["2"].Value = k2
    player.Keybinds["3"].Value = k3
    player.Keybinds["4"].Value = k4
end)