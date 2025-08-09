-- External Lua Script for Roblox (Executor required)

-- // SETTINGS (you can change these) \\ --
local lockTime = 10  -- How long the player is trapped before kick (seconds)
local kickMessageTime = 5 -- How long the fake kick message shows before real kick
-- // END SETTINGS \\ --

local uis = game:GetService("UserInputService")
local sg = game:GetService("StarterGui")
local lp = game:GetService("Players").LocalPlayer

print("Script started. Locking mouse & blocking ESC+L.")

-- STEP 1: Lock mouse and hide cursor immediately
uis.MouseBehavior = Enum.MouseBehavior.LockCenter

-- Keep mouse locked while script is running
uis.InputChanged:Connect(function()
    if uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        uis.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end)

-- STEP 2: Block ESC and L
uis.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.L then
        return true -- Block input
    end
end)

-- STEP 3: Wait for the trap duration
print("Player trapped for " .. lockTime .. " seconds.")
task.wait(lockTime)

-- STEP 4: Show fake Roblox kick message
sg:SetCore("SendNotification", {
    Title = "Disconnected",
    Text = "You have been kicked by this experience or its moderators.\n(Error Code: 267)",
    Duration = kickMessageTime
})

print("Kick message shown for " .. kickMessageTime .. " seconds.")

-- STEP 5: Wait, then actually kick the player
task.wait(kickMessageTime)
lp:Kick("You have been kicked by this experience or its moderators.\n(Error Code: 267)")
