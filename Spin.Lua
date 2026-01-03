-- Delta Executor Compatible Spin Script with Speed Control
-- Works perfectly in Delta, Fluxus, Codex, etc.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpinGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")  -- Safe for most executors including Delta

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "SPIN BOT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleButton.Text = "SPIN: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.TextSize = 16
ToggleButton.Parent = Frame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.8, 0, 0, 35)
SpeedBox.Position = UDim2.new(0.1, 0, 0.65, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.PlaceholderText = "Speed (e.g. 100)"
SpeedBox.Text = "100"
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.Parent = Frame

-- Corners for buttons
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 8)

-- Variables
local Spinning = false
local SpinSpeed = 100
local Spinner = nil

-- Update speed when textbox changes
SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(SpeedBox.Text)
        if num and num > 0 then
            SpinSpeed = num
        else
            SpeedBox.Text = tostring(SpinSpeed)
        end
    end
end)

-- Main spin function
local function StartSpin()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    if Spinner then Spinner:Destroy() end

    Spinner = Instance.new("BodyAngularVelocity")
    Spinner.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
    Spinner.MaxTorque = Vector3.new(0, math.huge, 0)
    Spinner.P = 1250
    Spinner.Parent = HumanoidRootPart
end

local function StopSpin()
    if Spinner then
        Spinner:Destroy()
        Spinner = nil
    end
end

-- Toggle button
ToggleButton.MouseButton1Click:Connect(function()
    Spinning = not Spinning

    if Spinning then
        ToggleButton.Text = "SPIN: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        StartSpin()

        -- Keep spinning even if character respawns
        Player.CharacterAdded:Connect(function()
            if Spinning then
                task.wait(0.5)  -- Wait for character to load
                StartSpin()
            end
        end)
    else
        ToggleButton.Text = "SPIN: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        StopSpin()
    end
end)

-- Optional: Close with Right Click on title
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        ScreenGui:Destroy()
    end
end)

print("Spin GUI Loaded! Drag to move • Right-click title to close • Made for Delta Executor")
