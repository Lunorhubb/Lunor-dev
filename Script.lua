-- Permanent Fullscreen Lock + Triggered Lock + Unified Fake Kick Screen
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local sg = game:GetService("StarterGui")
local gs = game:GetService("GuiService")
local lp = game:GetService("Players").LocalPlayer

local pcKickDelay = 200     -- Delay after trigger on PC
local mobileKickDelay = 70 -- Delay from script start on mobile
local lockActive = false

local kickMessage = "You have been kicked by this experience or its moderators.\n(Error Code: 267)"

-- Function to show fake ban screen then kick
local function showFakeBan(reason, delayBeforeKick)
    local screen = Instance.new("ScreenGui")
    screen.IgnoreGuiInset = true
    screen.Parent = game:GetService("CoreGui")

    local bg = Instance.new("Frame", screen)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local title = Instance.new("TextLabel", bg)
    title.Text = "Disconnected"
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true
    title.Size = UDim2.new(1, 0, 0, 100)
    title.Position = UDim2.new(0, 0, 0.35, 0)
    title.TextColor3 = Color3.fromRGB(0, 0, 0)

    local reasonText = Instance.new("TextLabel", bg)
    reasonText.Text = reason
    reasonText.Font = Enum.Font.SourceSans
    reasonText.TextSize = 24
    reasonText.Size = UDim2.new(1, -40, 0, 60)
    reasonText.Position = UDim2.new(0, 20, 0.45, 0)
    reasonText.TextColor3 = Color3.fromRGB(0, 0, 0)
    reasonText.TextWrapped = true

    task.delay(delayBeforeKick, function()
        lp:Kick(reason)
    end)
end

-- Function to activate lock and countdown on PC
local function activateLock(kickDelay)
    if lockActive then return end
    lockActive = true
    print("Lock activated. Fake kick screen in " .. kickDelay .. " seconds.")

    -- Force fullscreen
    rs.RenderStepped:Connect(function()
        if not gs:IsFullscreen() then
            gs:ToggleFullscreen()
        end
    end)

    -- Lock mouse
    uis.MouseBehavior = Enum.MouseBehavior.LockCenter
    rs.RenderStepped:Connect(function()
        if uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            uis.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end)

    -- Esc/L keys close menu
    local function closeMenu()
        sg:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        task.wait(0.025)
        sg:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    end

    uis.InputBegan:Connect(function(i, _)
        if i.KeyCode == Enum.KeyCode.Escape then
            task.delay(0.025, closeMenu)
        elseif i.KeyCode == Enum.KeyCode.L then
            closeMenu()
        end
    end)

    -- Show the fake ban screen after the delay
    showFakeBan(kickMessage, kickDelay)
end

-- Desktop vs Mobile logic
if not uis.TouchEnabled then
    -- PC: Trigger upon ESC or focus loss
    uis.InputBegan:Connect(function(input, _)
        if not lockActive and input.KeyCode == Enum.KeyCode.Escape then
            activateLock(pcKickDelay)
        end
    end)

    uis.WindowFocusReleased:Connect(function()
        if not lockActive then
            activateLock(pcKickDelay)
        end
    end)
else
    -- Mobile: Start countdown immediately
    print("Mobile detected. Fake kick in " .. mobileKickDelay .. " seconds.")
    task.delay(mobileKickDelay, function()
        showFakeBan(kickMessage, 0)
    end)
end
