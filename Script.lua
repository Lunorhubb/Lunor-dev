-- Services
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local sg = game:GetService("StarterGui")
local gs = game:GetService("GuiService")
local lp = game:GetService("Players").LocalPlayer

-- Config
local pcKickDelay = 200       -- Seconds after trigger (PC)
local mobileKickDelay = 70   -- Seconds from script start (Mobile)
local lockActive = false

-- Function to show fake ban screen
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

-- Function to activate PC lock & countdown
local function activateLock(kickDelay)
    if lockActive then return end
    lockActive = true
    print("Lock activated. Fake kick screen in " .. kickDelay .. " seconds.")

    -- Force fullscreen always
    rs.RenderStepped:Connect(function()
        if not gs:IsFullscreen() then
            gs:ToggleFullscreen()
        end
    end)

    -- Mouse lock
    uis.MouseBehavior = Enum.MouseBehavior.LockCenter
    rs.RenderStepped:Connect(function()
        if uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            uis.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end)

    -- Menu close function
    local function closeMenu()
        sg:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        task.wait(0.025)
        sg:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    end

    uis.InputBegan:Connect(function(i, g)
        if i.KeyCode == Enum.KeyCode.Escape then
            task.delay(0.025, closeMenu)
        elseif i.KeyCode == Enum.KeyCode.L then
            closeMenu()
        end
    end)

    -- Show fake ban screen after delay
    showFakeBan(
        "You have been kicked by this experience or its moderators.\n(Error Code: 267)",
        kickDelay
    )
end

-- Detect platform
if not uis.TouchEnabled then
    -- Desktop trigger logic
    uis.InputBegan:Connect(function(input, gp)
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
    -- Mobile auto-delay logic
    print("Mobile detected. Fake kick in " .. mobileKickDelay .. " seconds.")
    task.delay(mobileKickDelay, function()
        showFakeBan(
            "You have been kicked by this experience or its moderators.\n(Error Code: 267)",
            0 -- instantly kicks after showing
        )
    end)
end
