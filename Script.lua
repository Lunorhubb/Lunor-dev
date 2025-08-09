-- High-fidelity fake "Disconnected" UI with optional real kick at the end.
-- Put this LocalScript in StarterPlayerScripts (or StarterGui).

local totalDelay = 40 -- seconds to block before enabling Leave (and before optional real kick)
local doRealKick = false -- set true if you want to call Player:Kick() after the delay

local reasons = {
    "Your account is temporarily suspended pending review.",
    "Your account is temporarily suspended pending review.\n(Error Code: 267)",
    "Suspicious activity detected on your account.\n(Error Code: 267)",
    "Multiple account logins detected.\n(Error Code: 267)"
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Avoid creating duplicate GUIs if script runs twice
if playerGui:FindFirstChild("FakeDisconnectedGui") then
    playerGui.FakeDisconnectedGui:Destroy()
end

-- Blur the world for that official feel
local blur = Lighting:FindFirstChild("FakeKickBlur") or Instance.new("BlurEffect")
blur.Name = "FakeKickBlur"
blur.Size = 0
blur.Parent = Lighting
local blurTween = TweenService:Create(blur, TweenInfo.new(0.18), {Size = 8})
blurTween:Play()

-- Full-screen ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeDisconnectedGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Input-blocker (captures any clicks/touches so game world is unusable)
local inputBlock = Instance.new("TextButton")
inputBlock.Name = "InputBlocker"
inputBlock.Size = UDim2.new(1, 0, 1, 0)
inputBlock.Position = UDim2.new(0, 0, 0, 0)
inputBlock.BackgroundTransparency = 1
inputBlock.AutoButtonColor = false
inputBlock.Text = ""
inputBlock.Parent = screenGui

-- Main centered modal (tries to match Roblox disconnected modal proportions)
local modal = Instance.new("Frame")
modal.Name = "Modal"
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.Size = UDim2.new(0, 600, 0, 300) -- fairly close to Roblox size on desktop
modal.Position = UDim2.new(0.5, 0, 0.5, 0)
modal.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
modal.BorderSizePixel = 0
modal.Parent = screenGui

local modalCorner = Instance.new("UICorner", modal)
modalCorner.CornerRadius = UDim.new(0, 6)

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 60)
title.Position = UDim2.new(0, 20, 0, 12)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 34
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Text = "Disconnected"
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = modal

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -40, 0, 1)
divider.Position = UDim2.new(0, 20, 0, 82)
divider.BackgroundColor3 = Color3.fromRGB(140,140,140)
divider.BorderSizePixel = 0
divider.Parent = modal

-- Message header (matching official wording)
local header = Instance.new("TextLabel")
header.Name = "Header"
header.Size = UDim2.new(1, -60, 0, 70)
header.Position = UDim2.new(0, 30, 0, 94)
header.BackgroundTransparency = 1
header.Font = Enum.Font.SourceSans
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(210,210,210)
header.TextWrapped = true
header.Text = "You have been kicked by this experience or its moderators. Moderation message:"
header.TextXAlignment = Enum.TextXAlignment.Center
header.TextYAlignment = Enum.TextYAlignment.Top
header.Parent = modal

-- Moderation message (random pick)
local modMsg = Instance.new("TextLabel")
modMsg.Name = "ModMessage"
modMsg.Size = UDim2.new(1, -60, 0, 70)
modMsg.Position = UDim2.new(0, 30, 0, 160)
modMsg.BackgroundTransparency = 1
modMsg.Font = Enum.Font.SourceSans
modMsg.TextSize = 20
modMsg.TextColor3 = Color3.fromRGB(230,230,230)
modMsg.TextWrapped = true
modMsg.Text = reasons[math.random(1, #reasons)]
modMsg.TextXAlignment = Enum.TextXAlignment.Center
modMsg.TextYAlignment = Enum.TextYAlignment.Top
modMsg.Parent = modal

-- White rounded Leave button
local leaveButton = Instance.new("TextButton")
leaveButton.Name = "LeaveButton"
leaveButton.Size = UDim2.new(0.6, 0, 0, 48)
leaveButton.Position = UDim2.new(0.5, 0, 1, -72)
leaveButton.AnchorPoint = Vector2.new(0.5, 0)
leaveButton.BackgroundColor3 = Color3.fromRGB(250,250,250)
leaveButton.Font = Enum.Font.SourceSansSemibold
leaveButton.TextSize = 22
leaveButton.TextColor3 = Color3.fromRGB(20,20,20)
leaveButton.Text = "Leave"
leaveButton.AutoButtonColor = true
leaveButton.Parent = modal

local leaveCorner = Instance.new("UICorner", leaveButton)
leaveCorner.CornerRadius = UDim.new(0, 10)

-- Disabled state initially
local clickable = false
leaveButton.Active = false
leaveButton.AutoButtonColor = false
leaveButton.Text = ("Leave (%d)"):format(totalDelay)

-- Block keyboard shortcuts (Escape / menu) by binding a dummy action while modal active
local blockActionName = "BLOCK_ALL_INPUTS"
local function blockAction(actionName, inputState, inputObject)
    -- do nothing (consumes the input)
    if inputState == Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Sink
end
ContextActionService:BindAction(blockActionName, blockAction, false,
    Enum.KeyCode.Escape, Enum.KeyCode.Backspace, Enum.KeyCode.F1, Enum.KeyCode.F2, Enum.KeyCode.L)

-- Prevent mouse cursor interactions with world
local oldMouseBehavior = UIS.MouseBehavior
local oldMouseIcon = UIS.MouseIconEnabled
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
UIS.MouseIconEnabled = false

-- Countdown coroutine
spawn(function()
    for i = totalDelay, 1, -1 do
        if not leaveButton or not leaveButton.Parent then break end
        leaveButton.Text = ("Leave (%d)"):format(i)
        task.wait(1)
    end

    -- enable the fake leave button
    clickable = true
    if leaveButton then
        leaveButton.Text = "Leave"
        leaveButton.Active = true
        leaveButton.AutoButtonColor = true
    end

    -- restore inputs and mouse
    ContextActionService:UnbindAction(blockActionName)
    UIS.MouseBehavior = oldMouseBehavior
    UIS.MouseIconEnabled = oldMouseIcon

    -- Optionally perform a real kick immediately
    if doRealKick then
        local reason = modMsg.Text
        -- small delay to allow cleanup/visual smoothing
        task.wait(0.15)
        player:Kick(reason)
        -- note: after this, Roblox's official "Disconnected" dialog will appear and is out of your control
    else
        -- keep fake UI until player clicks Leave
        -- clicking the fake button simply clears the GUI
        leaveButton.MouseButton1Click:Connect(function()
            if not clickable then return end
            -- clean up
            if screenGui and screenGui.Parent then screenGui:Destroy() end
            if blur and blur.Parent then blur:Destroy() end
        end)
    end
end)

-- If you want to forcibly close the fake UI from code elsewhere, call:
-- playerGui:FindFirstChild("FakeDisconnectedGui") and :Destroy()
