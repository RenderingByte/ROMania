local menubg = game.Workspace.MenuBGPart

local TweenService = game:GetService("TweenService")
local info = TweenInfo.new(125, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
local tween = TweenService:Create(menubg.Texture, info, {OffsetStudsV=300, OffsetStudsU=300})
tween:Play()