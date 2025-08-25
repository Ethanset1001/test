 -- THIS IS F E THIS DOESNT AFFECT THE GAME IN ANY WAY 

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)

local listLayout = Instance.new("UIListLayout", frame)

local genButton = Instance.new("TextButton", frame)
genButton.Size = UDim2.new(1, 0, 0, 40)
genButton.Text = "Generate 10 Usernames"

local clearButton = Instance.new("TextButton", frame)
clearButton.Size = UDim2.new(1, 0, 0, 40)
clearButton.Position = UDim2.new(0, 0, 0, 40)
clearButton.Text = "Clear List"

local lowercaseToggle = Instance.new("TextButton", frame)
lowercaseToggle.Size = UDim2.new(1, 0, 0, 40)
lowercaseToggle.Position = UDim2.new(0, 0, 0, 80)
lowercaseToggle.Text = "Include Lowercase: Yes"
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
		local rand = math.random(1, #chars)
		str = str .. string.sub(chars, rand, rand)
	end
	return str
end

local function checkUser(name)
	local success, response = pcall(function()
		return HttpService:GetAsync("https://api.roblox.com/users/get-by-username?username=" .. name)
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
		for i = 1, 10 do
			local name
			repeat
				name = randomUsername(5)
			until not generated[name]

			local exists = checkUser(name)
			generated[name] = true

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1, 0, 0, 30)
			label.Text = name
			label.TextColor3 = exists and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)

			wait(0.2)
		end
	end)
end

local function clearList()
	for _, v in ipairs(frame:GetChildren()) do
		if v:IsA("TextLabel") then
			v:Destroy()
		end
	end
	generated = {}
end

genButton.MouseButton1Click:Connect(generateList)
clearButton.MouseButton1Click:Connect(clearList)
