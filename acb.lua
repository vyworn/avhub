-- Wait till game is loaded
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(math.random())

-- Generate random key
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
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Services and variables
local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local placeid = game.PlaceId
local playerid = player.UserId
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local virtualinput = game:GetService("VirtualInputManager")
local virtualuser = game:GetService("VirtualUser")
local replicatedstorage = game:GetService("ReplicatedStorage")
local remotes = replicatedstorage:WaitForChild("Remotes")
local teleportservice = game:GetService("TeleportService")

-- Services and variables for tools
local api = "https://games.roblox.com/v1/games/"
local http = game:GetService("HttpService")
local teleportservice = game:GetService("TeleportService")
local username = player.Name
local displayname = player.DisplayName
local playerage = player.AccountAge
local creatorid = game.CreatorId
local creatortype = game.CreatorType
local jobid = game.JobId

local devid = {
    164011583,
}

local isdeveloper = table.find(devid, playerid) ~= nil

local swordTimer

local otherLocations = {
    "Sword",
    "Old Position"
}

local otherCoordinates = {
    ["Sword"] = Vector3.new(-5922.687012, 102.940720, -8286.416016),
}

local npcTeleports = {
    "Charm Merchant",
    "Potion Shop",
    "Card Fusion",
}

local areaTeleports = {
    "Heavens Arena",
    "Portal 5",
    "Portal 4",
    "Portal 3",
    "Portal 2",
    "Portal 1",
}

local npcTeleportsCoordinates = {
    ["Charm Merchant"] = Vector3.new(-5902.000977, 158.624985, -8741.383789),
    ["Potion Shop"] = Vector3.new(-45.672028, 256.645111, 5976.190918),
    ["Card Fusion"] = Vector3.new(13131.391602, 84.905922, 11281.490234),
}

local areaTeleportCoordinates = {
    ["Heavens Arena"] = Vector3.new(461.994751, 247.374268, 5954.683105),
    ["Portal 5"] = Vector3.new(13116.553711, 84.124977, 11327.412109),
    ["Portal 4"] = Vector3.new(-7902.407227, 734.204712, 6737.871582),
    ["Portal 3"] = Vector3.new(-24.246572, 256.645111, 5886.447754),
    ["Portal 2"] = Vector3.new(4260.783203, 31.724993, 7455.575684),
    ["Portal 1"] = Vector3.new(10932.377930, 351.924957, -5078.314941),
}

function Hub:Functions()
    -- Anti AFK
    player.Idled:connect(function()
        virtualuser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(0.5)
        virtualuser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(0.5)
        virtualuser:CaptureController()
        task.wait(0.5)
        virtualuser:ClickButton2(Vector2.new())
    end)
    
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

    -- Function to teleport the character to the destination
    self.characterTeleport = function(destination)
        if character then
            character:SetPrimaryPartCFrame(CFrame.new(destination))
            task.wait(0.1)
        end
    end

    self.getOldPosition = function()
        if character and humanoidRootPart then
            local position = humanoidRootPart.Position
            otherCoordinates["Old Position"] = Vector3.new(position.X, position.Y, position.Z)
        end
    end

    -- Function to teleport to the sword and interact with the ProximityPrompt
    self.grabSword = function()
        local swordBlock = workspace:WaitForChild("ObbySword"):WaitForChild("SwordBlock")
        local proximityPrompt = swordBlock:FindFirstChild("ProximityPrompt")

        self.getOldPosition()
        self.characterTeleport(otherCoordinates["Sword"])

        virtualinput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        virtualinput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        task.wait(2)
        self.characterTeleport(otherCoordinates["Old Position"])
    end

    -- Function to loop the potion grabbing function
    self.autoPotionsLoop = function()
        while self.autoPotionsToggle.Value do
            self.grabPotions()
            task.wait(0.5)
        end
    end

    -- Function to loop the roll function
    self.autoRollLoop = function()
        while self.autoRollToggle.Value do
            self.rollEvent()
            task.wait(0.01)
        end
    end

    -- Function to loop grabbing the sword
    self.autoSwordLoop = function()
        while self.autoSwordToggle.Value do 
            local swordObbyCD = player.Stats:WaitForChild("SwordObbyCD").value
            if swordObbyCD == 0 then
                self.grabSword()
            end
            task.wait(0.5)
        end
    end

    -- Function to rejoin the game
    self.rejoinGame = function()
        teleportservice:Teleport(placeid, player)
    end
end

-- Fluent GUI
function Hub:Gui()
    guiWindow[randomKey] = Fluent:CreateWindow({
        Title = "UK1 Hub",
        SubTitle = "by Av",
        TabWidth = 100,
        Size = UDim2.fromOffset(500, 300),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Auto = guiWindow[randomKey]:AddTab({ Title = "Auto", Icon = "repeat"}),
        Teleports = guiWindow[randomKey]:AddTab({ Title = "Teleports", Icon = "navigation"}),
        Misc = guiWindow[randomKey]:AddTab({ Title = "Misc", Icon = "circle-ellipsis"}),
        Settings = guiWindow[randomKey]:AddTab({ Title = "Settings", Icon = "settings"}),
    }

    local Options = Fluent.Options

    -- Auto Tab
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

    swordTimer = Tabs.Auto:AddParagraph({
        Title = "Obby Sword Timer",
        Content = "timer",
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
            while self.autoSwordToggle.Value do 
                local timeLeft = player.Stats:WaitForChild("SwordObbyCD").value
                swordTimer:SetDesc("Time left: " .. tostring(timeLeft))
                task.wait(0.1)
            end
        end
    end)

    -- Teleports Tab
    local npcTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
        Title = "Npc Teleports",
        Values = npcTeleports,
        Multi = false,
        Default = nil,
    })

    local areaTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
        Title = "Area Teleports",
        Values = areaTeleports,
        Multi = false,
        Default = nil,
    })

    npcTeleportDropdown:OnChanged(function(Value)
        local destination = npcTeleportsCoordinates[Value]
        if destination then
            self.characterTeleport(destination)
        end
    end)
    
    areaTeleportDropdown:OnChanged(function(Value)
        local destination = areaTeleportCoordinates[Value]
        if destination then
            self.characterTeleport(destination)
        end
    end)

    -- Misc Tab
    Tabs.Misc:AddButton({
        Title = "Rejoin game",
        Callback = function()
            task.spawn(self.rejoinGame)
        end
    })

    -- Settings Tab
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("UK1")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)

    -- Tools Tab
    if isdeveloper then
        Tabs.Tools = guiWindow[randomKey]:AddTab({ Title = "Tools", Icon = "wrench"})
        Tabs.Tools:AddButton({
            Title = "Remote Spy",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Infinite Yield",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Join Public Server",
            Callback = function()
                task.spawn(self.joinPublicServer)
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Rejoin Game",
            Callback = function()
                task.spawn(self.rejoinGame)
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Leave Game",
            Callback = function()
                task.spawn(self.leaveGame)
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Get Position",
            Callback = function()
                task.spawn(self.getPosition)
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Teleport to Logged Position",
            Callback = function()
                task.spawn(self.teleportToLoggedPosition)
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Copy Player Id",
            Callback = function()
                setclipboard(tostring(playerid))
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Copy Place Id",
            Callback = function()
                setclipboard(tostring(placeid))
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Copy Job Id",
            Callback = function()
                setclipboard(tostring(jobid))
            end
        })
    
        Tabs.Tools:AddButton({
            Title = "Copy Creator Id",
            Callback = function()
                setclipboard(tostring(creatorid))
            end
        })

        Tabs.Tools:AddParagraph({
            Title = "Info",
            Content = "User: " .. username .. " (" .. displayname .. ")" 
            .. "\nPlayer Id: " .. playerid 
            .. "\nAccount Age: " .. playerage
            .. "\nPlace Id: " .. placeid 
            .. "\nJob Id: " .. jobid 
            .. "\nCreator Id: " .. creatorid .. " (" .. tostring(creatortype) .. ")"
        })
    end

    guiWindow[randomKey]:SelectTab(1)

end

function Hub:Tools()
    -- Function to teleport to a position
    self.teleportToPosition = function(x, y, z)
        if character then
            local pos = Vector3.new(x, y, z)
            character:SetPrimaryPartCFrame(CFrame.new(pos))
        else
            warn("Character not found.")
        end
    end
    
    -- Function to join a random public server
    self.joinPublicServer = function()
        local serversurl = api .. placeid .. "/servers/Public?sortOrder=Asc&limit=10"
        local function listServers(cursor)
            local raw = game:HttpGet(serversurl .. ((cursor and "&cursor=" .. cursor) or ""))
            return http:JSONDecode(raw)
        end
        local servers = listServers()
        local server = servers.data[math.random(1, #servers.data)]
        teleportService:TeleportToPlaceInstance(placeid, server.id, player)
    end
    
    -- Function to rejoin the game
    self.rejoinGame = function()
        teleportService:Teleport(placeid, player)
    end
    
    -- Function to leave the game
    self.leaveGame = function()
        if player then
            player:Kick("Left game via hub")
        end
    end
    
    -- Function to get the current position
    local loggedPositionX, loggedPositionY, loggedPositionZ
    self.getPosition = function()
        if character and humanoidRootPart then
            local position = humanoidRootPart.Position
            loggedPositionX, loggedPositionY, loggedPositionZ = position.X, position.Y, position.Z
            local dataString = string.format("X: %.6f, Y: %.6f, Z: %.6f", position.X, position.Y, position.Z)
            setclipboard(dataString)
            return loggedPositionX, loggedPositionY, loggedPositionZ
        else
            if not character then
                warn("Character not found for player:", player.Name)
            end
            if not humanoidRootPart then
                warn("HumanoidRootPart not found for player:", player.Name)
            end
            return nil, nil, nil
        end
    end
    
    -- Function to teleport to the logged position
    self.teleportToLoggedPosition = function()
        if loggedPositionX and loggedPositionY and loggedPositionZ then
            self.teleportToPosition(loggedPositionX, loggedPositionY, loggedPositionZ)
        else
            warn("Logged position is not set.")
        end
    end
end

-- init
if isdeveloper then 
    Hub:Tools()
end
Hub:Functions()
Hub:Gui()
