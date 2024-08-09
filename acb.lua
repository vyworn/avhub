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

local guiWindow = {}

local Hub = _G[randomKey]

-- Fluent Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Services and variables
local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local virtualinput = game:GetService("VirtualInputManager")
local replicatedstorage = game:GetService("ReplicatedStorage")
local remotes = replicatedstorage:WaitForChild("Remotes")

local swordPosition = Vector3.new(-5922.687012, 102.940720, -8286.416016)

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

    self.swordTeleport = function()
        if character then
            character:SetPrimaryPartCFrame(CFrame.new(swordPosition))
            print("teleported to sword")
            task.wait(1)
        end
    end

    -- Function to teleport to the sword and interact with the ProximityPrompt
    self.grabSword = function()
        self:swordTeleport()

        local swordBlock = workspace:WaitForChild("ObbySword"):WaitForChild("SwordBlock")
        local proximityPrompt = swordBlock:FindFirstChild("ProximityPrompt")

        virtualinput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        virtualinput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
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

    -- Function to loop grabbing the sword
    self.autoSwordLoop = function()
        while self.autoSwordToggle.Value do 
            local swordObbyCD = player.Stats:WaitForChild("SwordObbyCD").value
            if swordObbyCD == 0 then
                self:grabSword()
            end
            task.wait(1)
        end
    end
end

-- Fluent GUI
function Hub:Gui()
    guiWindow[randomKey] = Fluent:CreateWindow({
        Title = "UK+1 Hub",
        SubTitle = "by Av",
        TabWidth = 100,
        Size = UDim2.fromOffset(500, 300),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Auto = guiWindow[randomKey]:AddTab({ Title = "Auto", Icon = "repeat" })
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

    self.autoSwordToggle = Tabs.Auto:AddToggle("AutoSword", {
        Title = "Auto Sword",
        Default = false,
    })

    Tabs.Auto:AddButton({
        Title = "Teleport to Sword",
        Callback = function()
            task.spawn(self.swordTeleport)
        end
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
    
    self.autoSwordToggle:OnChanged(function()
        if self.autoSwordToggle.Value then
            task.spawn(self.autoSwordLoop)
        end
    end)

    guiWindow[randomKey]:SelectTab(1)
end

-- init
Hub:Gui()
Hub:Functions()
