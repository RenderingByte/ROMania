-- Clone Default Settings from replicated storage

for _, v in pairs(game.ReplicatedStorage.Values:GetChildren()) do
    local item = v:Clone()
    item.Parent = game.Players.LocalPlayer
end