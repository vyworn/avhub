local function generateRandomKey(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local key = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        key = key .. string.sub(chars, randIndex, randIndex)
    end
    return key
end

local randomKey = generateRandomKey(11)
_G[randomKey] = {}
_G.ahKey = randomKey

local Hub = _G[randomKey]

-- Load Fluent library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Services and variables
local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Functions Section
function Hub:Functions()
    -- Function to grab potions
    self.grabPotions = function()
        local activePotions = workspace:WaitForChild("ActivePotions")

        for _, potion in ipairs(activePotions:GetChildren()) do
            local base = potion:FindFirstChild("Base")
            if base and base:FindFirstChild("TouchInterest") then
                -- Simulate touch begin
                firetouchinterest(base, humanoidRootPart, 1)
                task.wait(0.1) -- Short wait to simulate touch duration
                -- Simulate touch end
                firetouchinterest(base, humanoidRootPart, 0)
            end
        end
    end

    -- Function to run the potion grabber in a loop
    self.autoPotionsLoop = function()
        while self.autoPotionsToggle.Value do
            self:grabPotions()
            task.wait(1)
        end
    end
end

-- GUI Section
function Hub:Gui()
    -- Create the GUI Window
    local _G[randomKey] = Fluent:Create_G[randomKey]({
        Title = ,
        SubTitle = "by Av",
        TabWidth = 100,
        Size = UDim2.fromOffset(500, 300),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Add Tabs
    local Tabs = {
        Auto = _G[randomKey]:AddTab({ Title = "Auto", Icon = "repeat" })
    }

    -- Access Fluent Options
    local Options = Fluent.Options

    -- Add Auto Potions Toggle
    self.autoPotionsToggle = Tabs.Auto:AddToggle("AutoPotions", {
        Title = "Auto Potions",
        Default = false,
    })

    -- Connect the toggle to the loop function
    self.autoPotionsToggle:OnChanged(function()
        if self.autoPotionsToggle.Value then
            task.spawn(self.autoPotionsLoop)
        end
    end)

    -- Set default tab
    _G[randomKey]:SelectTab(1)
end

-- Initialize GUI
Hub:Gui()

-- Initialize Hub Functions
Hub:Functions()
