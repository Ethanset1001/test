local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)

-- UICorner for rounded frame
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0,12)

-- Rainbow gradient
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,182,193)), -- light pink
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(173,216,230)), -- light blue
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(144,238,144)), -- light green
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255,255,224)), -- light yellow
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(221,160,221)), -- plum
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,182,193))
}

local listLayout = Instance.new("UIListLayout", frame)

-- Generate Button
local genButton = Instance.new("TextButton", frame)
genButton.Size = UDim2.new(1, -20, 0, 30) -- smaller
genButton.Position = UDim2.new(0,10,0,10)
genButton.Text = "Generate 10 Usernames"
local genCorner = Instance.new("UICorner", genButton)
genCorner.CornerRadius = UDim.new(0,8)

-- Clear Button
local clearButton = Instance.new("TextButton", frame)
clearButton.Size = UDim2.new(1, -20, 0, 30)
clearButton.Position = UDim2.new(0,10,0,50)
clearButton.Text = "Clear List"
local clearCorner = Instance.new("UICorner", clearButton)
clearCorner.CornerRadius = UDim.new(0,8)

-- Lowercase toggle
local lowercaseToggle = Instance.new("TextButton", frame)
lowercaseToggle.Size = UDim2.new(1, -20, 0, 30)
lowercaseToggle.Position = UDim2.new(0,10,0,90)
lowercaseToggle.Text = "Include Lowercase: Yes"
local toggleCorner = Instance.new("UICorner", lowercaseToggle)
toggleCorner.CornerRadius = UDim.new(0,8)

local includeLowercase = true
local generated = {}

lowercaseToggle.MouseButton1Click:Connect(function()
	includeLowercase = not includeLowercase
	lowercaseToggle.Text = "Include Lowercase: " .. (includeLowercase and "Yes" or "No")
end)

local function randomUsername(len)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	if includeLowercase then
		chars = chars .. "abcdefghijklmnopqrstuvwxyz"
	end
	local str = ""
	for i = 1, len do
		local rand = math.random(1,#chars)
		str = str .. string.sub(chars,rand,rand)
	end
	return str
end

local function checkUser(name)
	local success, response = pcall(function()
		return HttpService:GetAsync("https://api.roblox.com/users/get-by-username?username="..name)
	end)
	if success then
		local data = HttpService:JSONDecode(response)
		if data.Id then
			return true
		end
	end
	return false
end

local function generateList()
	spawn(function()
		for i=1,10 do
			local name
			repeat
				name = randomUsername(5)
			until not generated[name]

			local exists = checkUser(name)
			generated[name]=true

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1, -20, 0, 25)
			label.Position = UDim2.new(0,10,0,0)
			label.Text = name
			label.TextColor3 = exists and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
			label.BackgroundTransparency = 1

			local labelCorner = Instance.new("UICorner", label)
			labelCorner.CornerRadius = UDim.new(0,6)

			wait(0.2)
		end
	end)
end

local function clearList()
	for _,v in ipairs(frame:GetChildren()) do
		if v:IsA("TextLabel") then
			v:Destroy()
		end
	end
	generated = {}
end

genButton.MouseButton1Click:Connect(generateList)
clearButton.MouseButton1Click:Connect(clearList)
