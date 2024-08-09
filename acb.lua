-- Services and variables
_G.avhub = _G.avhub or {}
local Hub = _G.avhub
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local replicatedstorage = game:GetService("ReplicatedStorage")
local remotes = replicatedstorage:WaitForChild("Remotes")

function Hub:Functions()
    -- Function to grab potions
    self.grabPotions = function()
        local activePotions = workspace:WaitForChild("ActivePotions")

        for _, potion in ipairs(activePotions:GetChildren()) do
            local base = potion:FindFirstChild("Base")
            if base and base:FindFirstChild("TouchInterest") then
                firetouchinterest(base, humanoidRootPart, 1)
                task.wait(0.1)
                firetouchinterest(base, humanoidRootPart, 0)
            end
        end
    end

    -- Function to roll
    self.rollEvent = function()
        local success, response = pcall(function()
            remotes:WaitForChild("RollEvent"):FireServer()
        end)
    end

    -- Function to loop the potion grabbing function
    self.autoPotionsLoop = function()
        while self.autoPotionsToggle.Value do
            self:grabPotions()
            task.wait(1)
        end
    end

    -- Function to loop the roll function
    self.autoRollLoop = function()
        while self.autoRollToggle.Value do
            self:rollEvent()
            task.wait(0.01)
        end
    end
end

-- GUI Section
function Hub:Gui()
    local Window = Fluent:CreateWindow({
        Title = "UK+1 Hub",
        SubTitle = "by Av",
        TabWidth = 100,
        Size = UDim2.fromOffset(500, 300),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Auto = Window:AddTab({ Title = "Auto", Icon = "repeat" })
    }

    local Options = Fluent.Options

    self.autoPotionsToggle = Tabs.Auto:AddToggle("AutoPotions", {
        Title = "Auto Potions",
        Default = false,
    })

    self.autoRollToggle = Tabs.Auto:AddToggle("AutoRoll", {
        Title = "Auto Roll",
        Default = false,
    })

    self.autoPotionsToggle:OnChanged(function()
        if self.autoPotionsToggle.Value then
            task.spawn(self.autoPotionsLoop)
        end
    end)

    self.autoRollToggle:OnChanged(function()
        if self.autoRollToggle.Value then
            task.spawn(self.autoRollLoop)
        end
    end)

    Window:SelectTab(1)
end

-- init
Hub:Gui()
Hub:Functions()
