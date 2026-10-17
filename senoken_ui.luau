-- 1. KEY SYSTEM
local UserInputService = game:GetService("UserInputService")
local KeyGUI = Instance.new("ScreenGui")
KeyGUI.Name = "SenokenKey"
KeyGUI.Parent = game:GetService("CoreGui")

local Gate = Instance.new("Frame")
Gate.Size = UDim2.new(0, 380, 0, 260)
Gate.Position = UDim2.new(0.5, -190, 0.5, -130)
Gate.BackgroundColor3 = Color3.fromRGB(6, 16, 12)
Gate.Parent = KeyGUI
Instance.new("UICorner", Gate).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", Gate).Color = Color3.fromRGB(30, 190, 100)

local Top = Instance.new("Frame", Gate)
Top.Size = UDim2.new(1, 0, 0, 46)
Top.BackgroundColor3 = Color3.fromRGB(10, 28, 20)
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)
local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SENOKEN HUB | Key System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(232, 255, 242)

local Input = Instance.new("TextBox", Gate)
Input.Size = UDim2.new(1, -40, 0, 38)
Input.Position = UDim2.new(0, 20, 0, 84)
Input.BackgroundColor3 = Color3.fromRGB(16, 44, 32)
Input.PlaceholderText = "Enter key..."
Input.Text = ""
Input.Font = Enum.Font.Gotham
Input.TextSize = 15
Input.TextColor3 = Color3.fromRGB(232, 255, 242)
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)

local Msg = Instance.new("TextLabel", Gate)
Msg.Size = UDim2.new(1, -40, 0, 18)
Msg.Position = UDim2.new(0, 20, 0, 128)
Msg.BackgroundTransparency = 1
Msg.Text = ""
Msg.Font = Enum.Font.Gotham
Msg.TextSize = 13
Msg.TextColor3 = Color3.fromRGB(255, 90, 100)

local function btn(text, x, w, color)
    local b = Instance.new("TextButton", Gate)
    b.Size = UDim2.new(0, w, 0, 38)
    b.Position = UDim2.new(0, x, 0, 156)
    b.BackgroundColor3 = color
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(232, 255, 242)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end
local CheckBtn = btn("Check Key", 20, 168, Color3.fromRGB(30, 190, 100))
local GetBtn = btn("Get Key", 192, 168, Color3.fromRGB(16, 44, 32))

GetBtn.MouseButton1Click:Connect(function()
    pcall(setclipboard, "https://link-target.net/962265/cpZeUpgKCxnk")
    Msg.Text = "Link copied!"
    Msg.TextColor3 = Color3.fromRGB(110, 255, 160)
end)

local loaded = false
local function tryKey()
    if string.upper((Input.Text:gsub("%s", ""))) == "SENOKEN-872529" then
        Msg.Text = "Key accepted. Loading..."
        Msg.TextColor3 = Color3.fromRGB(110, 255, 160)
        task.wait(0.5)
        Gate:Destroy()
        loaded = true
    else
        Msg.Text = "Invalid key"
        Msg.TextColor3 = Color3.fromRGB(255, 90, 100)
    end
end
CheckBtn.MouseButton1Click:Connect(tryKey)
Input.FocusLost:Connect(function(e) if e then tryKey() end end)

while not loaded do task.wait(1) end

-- 2. LOAD THE UI LIBRARY (Fixed to read text correctly)
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/fqfccccc/senoken-hub/main/senoken_ui.luau"))()

-- 3. PATCH BANANA HUB TO USE THIS UI
local HubSource = game:HttpGet("https://raw.githubusercontent.com/fqfccccc/senoken-hub/main/BananaHub_Blox_Fruits.lua")
-- Replace the old UI loading line with our Lib
local PatchedSource = HubSource:gsub('local lib = loadstring%(game:HttpGet%(".*"%)%)%(%)', 'local lib = ...')

local Loader = loadstring(PatchedSource)
if Loader then
    -- We pass the UI library directly into Banana Hub
    Loader(Lib)
else
    warn("Failed to parse Banana Hub source.")
end
