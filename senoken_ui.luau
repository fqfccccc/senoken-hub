-- Load the original Banana Hub UI
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Banana/refs/heads/main/Banana/ui.luau"))()

-- Wait a moment for it to load
task.wait(0.5)

-- OVERRIDE THE COLORS TO GREEN
-- This makes it green without rewriting 15,000 lines of code
if Lib and Lib.Theme then
    -- Some UI libraries use a Theme table
    pcall(function()
        Lib.Theme.Accent = Color3.fromRGB(30, 190, 100)
        Lib.Theme.Main = Color3.fromRGB(6, 16, 12)
        Lib.Theme.Background = Color3.fromRGB(10, 28, 20)
    end)
end

-- Change the title of the window
local oldCreateWindow = Lib.CreateWindow
Lib.CreateWindow = function(self, config)
    if config then
        config.Title = "SENOKEN HUB"
        config.Subtitle = "Blox Fruits"
    end
    return oldCreateWindow(self, config)
end

return Lib
