local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local character = player.Character or player.CharacterAdded:Wait()
local hum = character:FindFirstChildOfClass("Humanoid")

local savedWalkSpeed = 16
local currentJumpPower = 50
local jumpPowerBoostEnabled = false
local walkSpeedBoostEnabled = false

local jumpBoostConnection
local infiniteJumpConnection

Library:Notify({
    Title = "Success",
    Description = "Prism loaded successfully",
    Time = 5,
})

local Window = Library:CreateWindow({
    Title = "Prism Script Hub",
    Footer = "v0.0.1",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
}) 

local LocalPlayerTab = Window:AddTab("Local Player", "user")
local LeftGroupbox = LocalPlayerTab:AddLeftGroupbox("Movement")

LeftGroupbox:AddToggle("WalkSpeedBoost", {
    Text = "Walk Speed Boost",
    Default = false,
    Tooltip = "Enables Walk Speed Control",
    Callback = function(Value)
        walkSpeedBoostEnabled = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value and savedWalkSpeed or 16
        end
    end
})

LeftGroupbox:AddSlider("WalkspeedSlider", {
    Text = "Walk Speed",
    Default = savedWalkSpeed,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        savedWalkSpeed = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and walkSpeedBoostEnabled then
            hum.WalkSpeed = Value
            Library:Notify({
                Title = "Success",
                Description = "Set Walk Speed To " .. Value,
                Time = 5,
            })
          elseif not walkSpeedBoostEnabled then
              Library:Notify({
                Title = "Nuh Uh",
                Description = "Turn On The Walk Speed Switch First.",
                Time = 3
            })
        end
    end
})

LeftGroupbox:AddToggle("ToggleJumpBoost", {
    Text = "Jump Power Boost",
    Default = false,
    Tooltip = "Lets jump power be controlled",
    Callback = function(Value)
        jumpPowerBoostEnabled = Value

        if jumpBoostConnection then
            jumpBoostConnection:Disconnect()
            jumpBoostConnection = nil
        end

        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")

        if Value then
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = currentJumpPower
            end
            jumpBoostConnection = UIS.JumpRequest:Connect(function()
                if not jumpPowerBoostEnabled then return end
                local char = player.Character or player.CharacterAdded:Wait()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = currentJumpPower
                    task.wait(0.25)
                    hum.JumpPower = currentJumpPower
                end
            end)
            Library:Notify({
                Title = "Jump Power Boost",
                Description = "Enabled. Slider will work now.",
                Time = 4
            })
        else
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = 50
            end
            Library:Notify({
                Title = "Jump Power Boost",
                Description = "Disabled. Slider won’t apply.",
                Time = 4
            })
        end
    end
})

LeftGroupbox:AddSlider("JumpPowerSlider", {
    Text = "Jump Power",
    Default = currentJumpPower,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentJumpPower = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not jumpPowerBoostEnabled then
              Library:Notify({
                Title = "Nuh Uh",
                Description = "Turn On The Jump Power Switch First.",
                Time = 3
            })
            return
        end
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
            Library:Notify({
                Title = "Success",
                Description = "Set Jump Power To " .. Value,
                Time = 5,
            })
        end
    end
})

LeftGroupbox:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
    Tooltip = "Enables Infinite Jump",
    Callback = function(Value)
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end

        if Value then
            infiniteJumpConnection = UIS.JumpRequest:Connect(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.1)

    if walkSpeedBoostEnabled then
        hum.WalkSpeed = savedWalkSpeed
    end

    if jumpPowerBoostEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = currentJumpPower
    end
end)
