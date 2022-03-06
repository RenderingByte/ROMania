local Player = game.Players.LocalPlayer
local content, isready = game.Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
script.Parent.Image = content