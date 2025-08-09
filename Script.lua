-- SETTINGS
local lockTime = 10 -- Seconds before kick

-- Services
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local lp = game:GetService("Players").LocalPlayer

print("Script started.")

-- Detect platform
if not uis.TouchEnabled then
    -- DESKTOP: Lock mouse & block ESC/L keys
    print("Desktop detected. Locking mouse & blocking ESC/L keys.")

    -- Lock mouse immediately
    uis.MouseBehavior = Enum.MouseBehavior.LockCenter

    -- Keep mouse locked EVERY frame
    rs.RenderStepped:Connect(function()
        if uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            uis.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end)

    -- Block ESC and L keys
    uis.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.L then
            return true -- Block input
        end
    end)

else
    -- MOBILE: Skip mouse lock/key block
    print("Mobile detected. Skipping mouse lock & key block.")
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
lp:Kick("You have been kicked by this experience or its moderators.\n(Error Code: 267)")
