-- // Settings
local totalDelay = 40 -- seconds before actual kick
local reasons = {
    "Your Inventory has just been cleared!\n(Error Code: 267)",
    "Suspicious activity detected on your account.\n(Error Code: 267)",
    "Data corruption detected in your save file.\n(Error Code: 267)",
    "Multiple account logins detected.\n(Error Code: 267)",
    "Your account is temporarily suspended pending review.\n(Error Code: 267)"
}

-- // Services
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- // Detect platform
local isPC = not UIS.TouchEnabled and not UIS.GamepadEnabled

-- // Create Roblox-style kick UI
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "You have been kicked from this experience"
title.TextWrapped = true
title.Parent = frame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 50)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = frame

local reasonLabel = Instance.new("TextLabel")
reasonLabel.Size = UDim2.new(1, -20, 1, -110)
reasonLabel.Position = UDim2.new(0, 10, 0, 60)
reasonLabel.BackgroundTransparency = 1
reasonLabel.Font = Enum.Font.SourceSans
reasonLabel.TextSize = 18
reasonLabel.TextColor3 = Color3.new(1, 1, 1)
reasonLabel.TextWrapped = true
reasonLabel.TextYAlignment = Enum.TextYAlignment.Top
reasonLabel.Text = reasons[math.random(1, #reasons)]
reasonLabel.Parent = frame

local leaveButton = Instance.new("TextButton")
leaveButton.Size = UDim2.new(0, 100, 0, 30)
leaveButton.Position = UDim2.new(0.5, -50, 1, -40)
leaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leaveButton.Font = Enum.Font.SourceSansBold
leaveButton.TextSize = 18
leaveButton.TextColor3 = Color3.new(0, 0, 0)
leaveButton.Text = "Leave"
leaveButton.AutoButtonColor = true
leaveButton.Parent = frame

-- Disable leave button at first
local clickable = false
leaveButton.MouseButton1Click:Connect(function()
    if clickable then
        Player:Kick(reasonLabel.Text) -- Kicks for real
    end
end)

-- Restrict PC inputs before delay ends
if isPC then
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    UIS.MouseIconEnabled = false
    UIS.InputBegan:Connect(function(input, processed)
        if not clickable then
            if processed then return end
            if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.L then
                return -- Block keys
            end
        end
    end)
end

-- Kick after totalDelay
task.delay(totalDelay, function()
    clickable = true
    if isPC then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
    end
    Player:Kick(reasonLabel.Text) -- Auto-kick after delay
end)title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "You have been kicked from this experience"
title.TextWrapped = true
title.Parent = frame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 50)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = frame

local reasonLabel = Instance.new("TextLabel")
reasonLabel.Size = UDim2.new(1, -20, 1, -110)
reasonLabel.Position = UDim2.new(0, 10, 0, 60)
reasonLabel.BackgroundTransparency = 1
reasonLabel.Font = Enum.Font.SourceSans
reasonLabel.TextSize = 18
reasonLabel.TextColor3 = Color3.new(1, 1, 1)
reasonLabel.TextWrapped = true
reasonLabel.TextYAlignment = Enum.TextYAlignment.Top
reasonLabel.Text = reasons[math.random(1, #reasons)]
reasonLabel.Parent = frame

local leaveButton = Instance.new("TextButton")
leaveButton.Size = UDim2.new(0, 100, 0, 30)
leaveButton.Position = UDim2.new(0.5, -50, 1, -40)
leaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leaveButton.Font = Enum.Font.SourceSansBold
leaveButton.TextSize = 18
leaveButton.TextColor3 = Color3.new(0, 0, 0)
leaveButton.Text = "Leave"
leaveButton.AutoButtonColor = true
leaveButton.Parent = frame

-- // Initially disable leave button
local clickable = false
leaveButton.MouseButton1Click:Connect(function()
    if clickable then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId)
    end
end)

-- // PC restrictions before delay ends
if isPC then
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    UIS.MouseIconEnabled = false
    UIS.InputBegan:Connect(function(input, processed)
        if not clickable then
            if processed then return end
            if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.L then
                return -- Block these keys
            end
        end
    end)
end

-- // Unlock after totalDelay
task.delay(totalDelay, function()
    clickable = true
    if isPC then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = true
    end
end)
