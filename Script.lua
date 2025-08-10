-- Permanent Fullscreen Lock + Triggered Lock + Real Moderation Kick with Backups
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local sg = game:GetService("StarterGui")
local gs = game:GetService("GuiService")
local lp = game:GetService("Players").LocalPlayer

local pcKickDelay = 200
local mobileKickDelay = 70
local lockActive = true

-- List of moderation messages (order matters)
local kickMessages = {
    "Your account status has been reviewed. Please rejoin to continue playing.",
    "Your inventory has been reset. Please rejoin the game.",
    "Please reconnect to continue playing this experience.",
    "A change was made to your account. Rejoin to continue."
}

-- Function to kick with multiple attempts
local function kickWithBackup(messages, delayBeforeKick)
    task.delay(delayBeforeKick, function()
        for _, msg in ipairs(messages) do
            lp:Kick(msg)
            task.wait(0.5) -- Small pause before trying next
        end
    end)
end

-- Function to activate lock and countdown on PC
local function activateLock(kickDelay)
    if lockActive then return end
    lockActive = true
    print("Lock activated. Real kick in " .. kickDelay .. " seconds.")

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

    -- Esc/L keys close menu quickly
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

    -- Kick with backup messages
    kickWithBackup(kickMessages, kickDelay)
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
    print("Mobile detected. Real kick in " .. mobileKickDelay .. " seconds.")
    task.delay(mobileKickDelay, function()
        kickWithBackup(kickMessages, 0)
    end)
end
