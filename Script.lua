-- Permanent Fullscreen Lock + Triggered Mouse Lock + 50s Kick
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local sg = game:GetService("StarterGui")
local gs = game:GetService("GuiService")
local lp = game:GetService("Players").LocalPlayer

local kickDelay = 150 -- Seconds after trigger until kick
local lockActive = false

-- Always force fullscreen from script start
rs.RenderStepped:Connect(function()
    if not gs:IsFullscreen() then
        gs:ToggleFullscreen()
    end
end)

-- Function to activate lock + ESC closing
local function activateLock()
    if lockActive then return end
    lockActive = true
    print("Lock activated. Player will be kicked in " .. kickDelay .. " seconds.")

    -- Mouse lock
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

    -- Close menu on ESC/L after lock starts
    uis.InputBegan:Connect(function(i, g)
        if i.KeyCode == Enum.KeyCode.Escape then
            task.delay(0.025, closeMenu)
        elseif i.KeyCode == Enum.KeyCode.L then
            closeMenu()
        end
    end)

    -- Kick after timer
    task.delay(kickDelay, function()
        lp:Kick("You have been kicked from this experience. (Custom Script)")
    end)
end

-- Desktop only
if not uis.TouchEnabled then
    -- Trigger on ESC press
    uis.InputBegan:Connect(function(input, gp)
        if not lockActive and input.KeyCode == Enum.KeyCode.Escape then
            activateLock()
        end
    end)

    -- Trigger on alt-tab / focus loss
    uis.WindowFocusReleased:Connect(function()
        if not lockActive then
            activateLock()
        end
    end)
else
    print("Mobile detected. Script inactive.")
end
-- Kick after delay
print("Player will be kicked in " .. lockTime .. " seconds.")
task.wait(lockTime)
lp:Kick("You have been kicked from this experience. (Custom Script)")    Title = "Disconnected",
    Text = "You have been kicked by this experience or its moderators.\n(Error Code: 267)",
    Duration = kickMessageTime
})

print("Kick message shown for " .. kickMessageTime .. " seconds.")

-- STEP 5: Wait, then actually kick the player
task.wait(kickMessageTime)
lp:Kick("You have been kicked from this experience. Reason: Exploit Detected. (Error Code: 267)")
