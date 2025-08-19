-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create Frame (the box)
local frame = Instance.new("Frame")
frame.Name = "CenterBox"
frame.Size = UDim2.new(0, 200, 0, 200) -- 200x200 pixels
frame.Position = UDim2.new(0.5, -100, 0.5, -100) -- Centered on screen
frame.BackgroundColor3 = Color3.fromRGB(50, 150, 255) -- Blue color
frame.BorderSizePixel = 0
frame.Parent = screenGui
