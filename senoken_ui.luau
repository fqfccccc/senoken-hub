-- SENOKEN HUB UI LIBRARY (Drop-in replacement)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
local Colors = {
    Background = Color3.fromRGB(6, 16, 12),
    Secondary = Color3.fromRGB(10, 28, 20),
    Element = Color3.fromRGB(16, 44, 32),
    Accent = Color3.fromRGB(30, 190, 100),
    Text = Color3.fromRGB(232, 255, 242)
}

function Library:CreateWindow(config)
    local Window = {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SenokenHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 620, 0, 390)
    Main.Position = UDim2.new(0.5, -310, 0.5, -195)
    Main.BackgroundColor3 = Colors.Background
    Main.Active = true
    Main.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner", Main); UICorner.CornerRadius = UDim.new(0, 12)

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Colors.Secondary
    local UICorner2 = Instance.new("UICorner", TopBar); UICorner2.CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "SENOKEN HUB"
    Title.TextColor3 = Colors.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TabContainer = Instance.new("ScrollingFrame", Main)
    TabContainer.Size = UDim2.new(0, 150, 1, -54)
    TabContainer.Position = UDim2.new(0, 8, 0, 50)
    TabContainer.BackgroundColor3 = Colors.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local UICorner3 = Instance.new("UICorner", TabContainer); UICorner3.CornerRadius = UDim.new(0, 10)
    local UIListLayout = Instance.new("UIListLayout", TabContainer); UIListLayout.Padding = UDim.new(0, 4)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -174, 1, -54)
    PageContainer.Position = UDim2.new(0, 166, 0, 50)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local function SelectTab(tab)
        for _, t in pairs(Tabs) do
            t.Page.Visible = (t == tab)
            t.Button.BackgroundColor3 = (t == tab) and Colors.Accent or Colors.Element
        end
    end

    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton", TabContainer)
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Colors.Element
        TabButton.Text = name
        TabButton.TextColor3 = Colors.Text
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 13
        local UICorner = Instance.new("UICorner", TabButton); UICorner.CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundColor3 = Colors.Secondary
        Page.BorderSizePixel = 0
        Page.Visible = false
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local UICorner = Instance.new("UICorner", Page); UICorner.CornerRadius = UDim.new(0, 10)
        local UIListLayout = Instance.new("UIListLayout", Page); UIListLayout.Padding = UDim.new(0, 8)

        local Tab = { Button = TabButton, Page = Page, Name = name }
        table.insert(Tabs, Tab)
        TabButton.MouseButton1Click:Connect(function() SelectTab(Tab) end)
        if #Tabs == 1 then SelectTab(Tab) end

        local TabObj = {}
        function TabObj:AddLeftGroupbox(title)
            local Groupbox = Instance.new("Frame", Page)
            Groupbox.Size = UDim2.new(1, 0, 0, 0)
            Groupbox.AutomaticSize = Enum.AutomaticSize.Y
            Groupbox.BackgroundColor3 = Colors.Background
            Groupbox.BackgroundTransparency = 0.2
            local UICorner = Instance.new("UICorner", Groupbox); UICorner.CornerRadius = UDim.new(0, 8)
            local UIListLayout = Instance.new("UIListLayout", Groupbox); UIListLayout.Padding = UDim.new(0, 6)
            
            local Title = Instance.new("TextLabel", Groupbox)
            Title.Size = UDim2.new(1, 0, 0, 22)
            Title.BackgroundTransparency = 1
            Title.Text = title
            Title.TextColor3 = Colors.Accent
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local G = {}
            function G:AddToggle(id, opts)
                local ToggleBtn = Instance.new("TextButton", Groupbox)
                ToggleBtn.Size = UDim2.new(1, 0, 0, 34)
                ToggleBtn.BackgroundColor3 = Colors.Element
                ToggleBtn.Text = "  " .. (opts.Text or id)
                ToggleBtn.TextColor3 = Colors.Text
                ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
                ToggleBtn.Font = Enum.Font.Gotham
                local UICorner = Instance.new("UICorner", ToggleBtn); UICorner.CornerRadius = UDim.new(0, 6)
                local State = opts.Default or false
                ToggleBtn.MouseButton1Click:Connect(function()
                    State = not State
                    ToggleBtn.BackgroundColor3 = State and Colors.Accent or Colors.Element
                    if opts.Callback then task.spawn(opts.Callback, State) end
                end)
                return { SetValue = function(self, v) State = v; if opts.Callback then task.spawn(opts.Callback, v) end end }
            end
            function G:AddButton(opts, fn)
                if type(opts) == "string" then opts = {Text = opts, Func = fn} end
                local Btn = Instance.new("TextButton", Groupbox)
                Btn.Size = UDim2.new(1, 0, 0, 34)
                Btn.BackgroundColor3 = Colors.Element
                Btn.Text = opts.Text or "Button"
                Btn.TextColor3 = Colors.Text
                Btn.Font = Enum.Font.GothamSemibold
                local UICorner = Instance.new("UICorner", Btn); UICorner.CornerRadius = UDim.new(0, 6)
                Btn.MouseButton1Click:Connect(function() if opts.Func or opts.Callback then task.spawn(opts.Func or opts.Callback) end end)
                return Btn
            end
            function G:AddDropdown(opts)
                local Btn = Instance.new("TextButton", Groupbox)
                Btn.Size = UDim2.new(1, 0, 0, 34)
                Btn.BackgroundColor3 = Colors.Element
                Btn.Text = "  " .. (opts.Text or "Dropdown")
                Btn.TextColor3 = Colors.Text
                Btn.Font = Enum.Font.Gotham
                local UICorner = Instance.new("UICorner", Btn); UICorner.CornerRadius = UDim.new(0, 6)
                return { SetValue = function() end }
            end
            function G:AddSlider(opts)
                local Btn = Instance.new("TextButton", Groupbox)
                Btn.Size = UDim2.new(1, 0, 0, 34)
                Btn.BackgroundColor3 = Colors.Element
                Btn.Text = "  " .. (opts.Text or "Slider")
                Btn.TextColor3 = Colors.Text
                Btn.Font = Enum.Font.Gotham
                local UICorner = Instance.new("UICorner", Btn); UICorner.CornerRadius = UDim.new(0, 6)
                return { SetValue = function() end }
            end
            function G:AddInput(opts)
                local Btn = Instance.new("TextBox", Groupbox)
                Btn.Size = UDim2.new(1, 0, 0, 34)
                Btn.BackgroundColor3 = Colors.Element
                Btn.Text = opts.Default or ""
                Btn.PlaceholderText = opts.Text or "Input"
                Btn.TextColor3 = Colors.Text
                local UICorner = Instance.new("UICorner", Btn); UICorner.CornerRadius = UDim.new(0, 6)
                Btn.FocusLost:Connect(function() if opts.Callback then task.spawn(opts.Callback, Btn.Text) end end)
                return { SetValue = function(self, v) Btn.Text = v; if opts.Callback then task.spawn(opts.Callback, v) end end }
            end
            function G:AddLabel(text)
                local Lbl = Instance.new("TextLabel", Groupbox)
                Lbl.Size = UDim2.new(1, 0, 0, 20)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Colors.Text
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextSize = 13
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                return { SetText = function(self, t) Lbl.Text = t end }
            end
            return G
        end
        TabObj.AddRightGroupbox = TabObj.AddLeftGroupbox
        return TabObj
    end
    return Window
end
return Library
