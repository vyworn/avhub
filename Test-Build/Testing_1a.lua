-- Check If Loaded
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local name = "UK1 Hub"
local version = "1.6.6"
local release = "test_1a"

_G.versionControl = version .. "." .. release

if _G.desiredVersion ~= nil and _G.desiredVersion ~= _G.versionControl then
    warn("\t\t\t  [ avhub ]")
    warn("Version Mismatch Detected")
    warn("Desired Version: " .. tostring(_G.desiredVersion))
    warn("Current Version: " .. tostring(_G.versionControl))
    _G.desiredVersion = nil 
    return
end

local functionsInit = false
local guiInit = false
local hubInit = false

-- Roblox Services & Variables
local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidrootpart = character:WaitForChild("HumanoidRootPart")

local workspace = game:GetService("Workspace")
local virtualinput = game:GetService("VirtualInputManager")
local virtualuser = game:GetService("VirtualUser")
local guiservice = game:GetService("GuiService")
local playergui = player:WaitForChild("PlayerGui")
local userinputservice = game:GetService("UserInputService")
local replicatedstorage = game:GetService("ReplicatedStorage")
local remotes = replicatedstorage:WaitForChild("Remotes")
local httpservice = game:GetService("HttpService")
local proximitypromptservice = game:GetService("ProximityPromptService")
local teleportservice = game:GetService("TeleportService")
local textchatservice = game:GetService("TextChatService")
local textchannel = textchatservice.TextChannels:WaitForChild("RBXGeneral")

local playerid = player.UserId
local username = player.Name
local displayname = player.DisplayName
local playerage = player.AccountAge

local placeid = game.PlaceId
local creatorid = game.CreatorId
local creatortype = game.CreatorType
local jobid = game.JobId
local api = "https://games.roblox.com/v1/games/"

local stats = player:WaitForChild("Stats")
local gamenpcs = workspace:WaitForChild("NPCs")
local gamebosses = workspace:WaitForChild("Bosses")

-- Libraries
local Fluent = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/update/Fluent/Beta-FluentLibrary.lua")))()
local InterfaceManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/main/Fluent/Beta-InterfaceManager.lua")))()
local SaveManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/main/Fluent/Beta-SaveManager.lua")))()

-- Helper Functions
local function generateRandomKey(length)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	local key = ""
	for i = 1, length do
		local randIndex = math.random(1, #chars)
		key = key .. string.sub(chars, randIndex, randIndex)
	end
	return key
end

local function antiAfk()
	player.Idled:Connect(function()
		virtualuser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		task.wait(0.1)
		virtualuser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end)
    return true
end

local function rejoinGame()
	task.wait(1)
	teleportservice:Teleport(placeid, player)
end

local function joinPublicServer()
    task.wait(1)
    local serversurl = api .. placeid .. "/servers/Public?sortOrder=Asc&limit=10"
    local function listServers(cursor)
        local raw = game:HttpGet(serversurl .. (cursor and "&cursor=" .. cursor or ""))
        return httpservice:JSONDecode(raw)
    end
    local servers = listServers()
    local server = servers.data[math.random(1, #servers.data)]
    teleportservice:TeleportToPlaceInstance(placeid, server.id, player)
end

-- Universal Functions
local function formatNumberWithCommas(number)
    local numStr = tostring(number)
    local formattedStr = numStr:reverse():gsub("(%d%d%d)", "%1,"):gsub(",%-$", ""):reverse()
    if formattedStr:sub(1, 1) == "," then
        formattedStr = formattedStr:sub(2)
    end
    return formattedStr
end

local function waitForTarget(targetName, parentObject, timeout)
    local startTime = tick()
    local target = parentObject:FindFirstChild(targetName)
    
    while not target and (tick() - startTime) < (timeout or 10) do
        target = parentObject:FindFirstChild(targetName)
        
        task.wait(0.5)
    end
    
    if target then
        local hrp = target:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp
        end
    end
    return nil
end

local function waitUntil(condition)
    while not condition() do
        task.wait(0.5)
    end
end

local function waitForProximityPrompt(hrp, timeout)
    local startTime = tick()
    local proximityPrompt = hrp:FindFirstChild("ProximityPrompt")
    
    while not proximityPrompt and (tick() - startTime) < (timeout or 10) do
        proximityPrompt = hrp:FindFirstChild("ProximityPrompt")
        
        task.wait(0.5)
    end
    
    if proximityPrompt then
        fireproximityprompt(proximityPrompt)
        return true
    end
    return false
end

-- Developer Check
local devid = 
{
	["av"] = 164011583,
	["psuw"] = 417954849,
	["hari"] = 85087803,
    ["marc"] = 57061551,
}

local function isDeveloper(userid)
	for _, id in pairs(devid) do
		if id == userid then
			return true
		end
	end
	return nil
end

-- Library Variables
local randomKey = generateRandomKey(9)
_G[randomKey] = {}
_G.ahKey = randomKey
local guiWindow = {}
local AvHub = _G[randomKey]

-- Position Tables
local interactionNames = 
{
    "Raid Shop",
	"Potion Shop",
	"Card Fusion",
	"Card Deconstruction",
	"Charm Merchant",
	"Strange Trader",
	"Card Index",
	"Card Packs",
}

local battleNames = 
{
	"Heaven Infinite",
	"Heaven Tower",
    "Adaptive Titan",
    "Black Sea Warlord",
    "Starlight Devourer",
}

local areaNames = 
{
    "Daily Chest",
    "Sword",
	"Spawn",
    "Follow Leaderboard",
    "Roll Leaderboard",
	"Card Leaderboard",
    "Luck Fountain",
}

local repeatBossNames =
{
    "Infernal Pugilist",
	"Bald Hero",
	"Rubber Boy",
	"Substitute Reaper",
	"Limitless",
	"Rogue Ninja",
	"Knucklehead Ninja",
	"Prince",
	"Earth's Mightiest",
}

local normalBossNames =
{
	"Immortal Demon",
	"Cosmic Menace",
	"Wicked Weaver",
	"Cifer",
	"King Of Curses",
	"Shinobi God",
	"Galactic Tyrant",
}

local interactionPositions = 
{
    ["Raid Shop"] = Vector3.new(-7933.645020, 179.723953,-9347.706055),
    ["Potion Shop"] = Vector3.new(-7744.11376953125, 180.14158630371094, -9369.5908203125),
	["Card Fusion"] = Vector3.new(13131.391602, 84.905922, 11281.490234),
	["Card Deconstruction"] = Vector3.new(-7837.935059, 180.831451,-9281.571289),
	["Charm Merchant"] = Vector3.new(-7764.36572265625, 179.71200561523438, -9194.859375),
	["Strange Trader"] = Vector3.new(523.097717, 247.374268, 6017.144531),
	["Card Index"] = Vector3.new(-7846.603515625, 180.50991821289062, -9371.1884765625),
	["Card Packs"] = Vector3.new(-7708.05810546875, 180.46566772460938, -9310.736328125),
}

local battlePositions = 
{
    ["Heaven Infinite"] = Vector3.new(454.615417, 260.529327,5928.994629),
    ["Heaven Tower"] = Vector3.new(451.595367, 247.374268, 5980.721191),
    ["Adaptive Titan"] = Vector3.new(-11600.375000, 250.031403,-11486.458984),
    ["Black Sea Warlord"] = Vector3.new(-23600.302734, 172.318451,-9145.819336),
    ["Starlight Devourer"] = Vector3.new(-13947.146484, 250.910126,-9549.314453),
}

local areaPositions = 
{
	["Daily Chest"] = Vector3.new(-7785.53173828125, 180.8318634033203, -9339.9423828125),
    ["Sword"] = Vector3.new(-7714.85205078125, 211.64096069335938, -9588.51953125),
    ["Spawn"] = Vector3.new(-7810.774902, 179.706451,-9363.508789),
    ["Follow Leaderboard"] = Vector3.new(-7799.123535, 179.436554,-9539.000000),
    ["Roll Leaderboard"] = Vector3.new(-7920.541015625, 186.38790893554688, -9144.70703125),
    ["Card Leaderboard"] = Vector3.new(-7920.541015625, 186.38800048828125, -9170.8369140625),
    ["Luck Fountain"] = Vector3.new(-7811.5751953125, 180.41331481933594, -9278.078125),
}

local repeatBossPositions =
{
    ["Infernal Pugilist"] = Vector3.new(-13618.935547, 249.765564,8330.528320),
    ["Bald Hero"] = Vector3.new(-11790.704102, 152.171967, -8566.525391),
    ["Rubber Boy"] = Vector3.new(13150.526367, 84.124977, 11365.570312),
    ["Substitute Reaper"] = Vector3.new(-7901.751465, 734.372009, 6714.296875),
    ["Limitless"] = Vector3.new(-12.537902, 272.422241, 5996.07666),
    ["Rogue Ninja"] = Vector3.new(4306.954102, 31.724993, 7506.855469),
    ["Knucklehead Ninja"] = Vector3.new(4219.748535, 31.724997, 7506.525391),
    ["Prince"] = Vector3.new(10987.201172, 344.049896, -5241.321777),
    ["Earth's Mightiest"] = Vector3.new(10939.111328, 340.554169, -5141.633789),
}

local normalBossPositions =
{
    ["Immortal Demon"] = Vector3.new(-13607.038086, 249.765564,8309.548828),
    ["Cosmic Menace"] = Vector3.new(-11721.826172, 156.702225, -8551.984375),
    ["Wicked Weaver"] = Vector3.new(13107.546875, 84.274979, 11333.648438),
    ["Cifer"] = Vector3.new(-7899.03418, 734.354736, 6741.601562),
    ["King Of Curses"] = Vector3.new(-25.217384, 256.795135, 5882.467773),
    ["Shinobi God"] = Vector3.new(4258.674805, 31.874994, 7444.705078),
    ["Galactic Tyrant"] = Vector3.new(10927.65918, 352.19986, -5072.885254),
}

local previousPositions = 
{
    ["Previous Position Sword"] = Vector3.new(0,0,0),
    ["Previous Position Chest"] = Vector3.new(0,0,0),
    ["Previous Position Infinite"] = Vector3.new(0,0,0),
    ["Previous Position Raid"] = Vector3.new(0,0,0),
}

-- Codes Table
local codes = 
{
    "SUB2VALK!",
    "SUB2TOADBOI!",
    "SUB2RIJORO!",
    "SUB2WIRY!",
    "SUB2CONSUME!",
    "SUB2D1SGUISED!",
    "SUB2ItsHappyYT1!",
    "SUB2Joltzy!",
    "10KLIKES!",
    "15KLIKES!",
    "20KLIKES!",
    "5MVISITS!",
    "DAVIDSTHEBEST!",
    "25KLIKES!",
    "30KLIKES!",
    "10MVISITS!",
    "UPDATE3!",
    "2KTWITTERFOLLOWS!",
    "20MVISITS!",
    "UPDATE3.5!",
}

-- Farming Variables
local autoPotionsActive, autoSwordActive = false, false

local potionCount = 0
local activePotions

local canGoBack, grabbedSword, teleportedBack = false, false, false
local swordCooldown, swordObbyCD
local obbySwordPrompt, swordBlock, swordProximityPrompt

local dailyChest, dailyChestProximityPrompt
local grabbingChest = false

-- Battle Variables
local autoRaidActive, autoInfiniteActive = false, false
local inBattle
local rsra, currentRaidValue
local raidBar, progressBar
local raidActive, raidTimer, timerText, lastTimerText
local maxStableInterval = 3
local startTime, currentTries, maxTries
local raidDamageTracker = stats:FindFirstChild("RaidDamageTracker")
local damageThreshold = 1000000
local davidNPC, davidHRP, davidProximityPrompt
local titanBoss, titanHRP, titanProximityPrompt 
local npcDialogue, dialogueFrame, responseFrame, dialogueOption
local battleLabel
local hideBattle
local BATTLETOWERUI
local rankedRemote = remotes:FindFirstChild("RankedMenuEvents")

-- Paragraph Variables
local hubInfoParagraph, farmParagraph, battleParagraph  
local tickCount, uptimeInSeconds, hours, minutes, seconds
local uptimeText = "N/Ah N/Am N/As"
local damageDealt, previousRunDamage = 0, 0
local battleLabelText, raidText
local highestFloor, previousRunFloor, currentRunFloor = 0, 0, 0
local floorMatch
local formattedRaidDamageTracker, formattedDamageDealt, formattedThreshold
local formattedHighestFloor, formattedLoggedHighestFloor, formattedCurrentRunFloor
local battleInProgress = false

-- Coroutine Variables
local coroutinesTable = {}

-- Webhook Stuff
local webhookUrl = "https://discord.com/api/webhooks/1282383049803436052/SZV7j2tQQvUYcA-_x_o-ILSljzI6q98LGA0Vk5AuIak_ar7k5G2izQVIsLYy6QMIUUvE"
local discordId
local cardChanceThreshold = 1000000
local request = syn and syn.request or http and http.request or http_request or request or (v2 and v2.request)

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local function escapeDiscordFormatting(text)
    return text:gsub("([>_*~`|])", "\\%1")
end

local function convertToRobloxCdnUrl(assetId)
    return string.format("https://assetdelivery.roblox.com/v1/asset/?id=%s", assetId)
end

local footerIconAssetId = 123957080365902
local footerIconUrl = footerIconAssetId and convertToRobloxCdnUrl(footerIconAssetId) or nil

local function getUniverseId()
    return game.GameId
end

local function getPlaceThumbnailUrl()
    local universeId = getUniverseId()
    if not universeId then
        return
    end
    
    local apiUrl = "https://thumbnails.roblox.com/v1/games/icons?universeIds=" .. universeId .. "&size=512x512&format=Png&isCircular=false"
    
    local success, response = pcall(function()
        return request({
            Url = apiUrl,
            Method = "GET"
        })
    end)

    if success and response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)
        if data and data.data and #data.data > 0 then
            return data.data[1].imageUrl
        end
    end
end

local function sendChangedWebhook(old, new, name)
    if webhookUrl == "" or webhookUrl == nil then
        warn("Webhook URL not set.")
        return
    end

    local contentStr = " "
    local userStr = tostring(player)
    local changeStr = "From:\n" .. tostring(old) .. "\n" .. "To:\n" .. tostring(new)

    if discordId and discordId ~= "" and discordId ~= 0 and "0" then
        contentStr = "<@!" .. discordId .. ">"
    end
    
    local data = {
        content = contentStr .. "\n ",
        username = "Anime Card Battles",
        avatar_url = getPlaceThumbnailUrl(),
        embeds = {{
            title = "Changed Value",
            color = 14239544,
            fields = {
                { name = "Changed: " .. tostring(name), value = changeStr , inline = false },
            },
            footer = {
                text = "UK1 Hub by Av" .. " | " .. "v_" .. _G.versionControl,
                icon_url = footerIconUrl
            }
        }}
    }
    
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Body = httpservice:JSONEncode(data),
            Headers = { ["Content-Type"] = "application/json" }
        })
    end)
    
    if not success then
        warn("Failed to send webhook:", response)
    end
end

local function sendRolledWebhook(cardChance, cardRarity, cardName, packType)
    if webhookUrl == "" or webhookUrl == nil then
        warn("Webhook URL not set.")
        return
    end

    local contentStr = " "
    local userStr = tostring(player)
    local descStr = "Obtained by: " .. userStr .. "\n" .. "Threshold: " ..  tostring(cardChanceThreshold)

    if discordId and discordId ~= "" and discordId ~= 0 and "0" then
        contentStr = "<@!" .. discordId .. ">"
    end
    
    local data = {
        content = contentStr .. "\n ",
        username = "Anime Card Battles",
        avatar_url = getPlaceThumbnailUrl(),
        embeds = {{
            title = "Rare Card Obtained",
            description = descStr,
            color = 5459883,
            fields = {
                { name = "From: ", value = "Card Roll", inline = false },
                { name = "Card Chance", value = "1 / " .. formatNumberWithCommas(cardChance), inline = false },
                { name = "Card Rarity", value = cardRarity, inline = false },
                { name = "Card Name", value = cardName, inline = false },
                { name = "Pack Type", value = packType, inline = false }
            },
            footer = {
                text = "UK1 Hub by Av" .. " | " .. "v_" .. _G.versionControl,
                icon_url = footerIconUrl
            }
        }}
    }
    
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Body = httpservice:JSONEncode(data),
            Headers = { ["Content-Type"] = "application/json" }
        })
    end)
    
    if not success then
        warn("Failed to send webhook:", response)
    end
end

local function sendInfiniteWebhook(cardChance, cardName, cardRarity)
    if webhookUrl == "" or webhookUrl == nil then
        warn("Webhook URL not set.")
        return
    end

    local contentStr = " "
    local userStr = tostring(player)
    local descStr = "Obtained by: " .. userStr .. "\n" .. "Threshold: " ..  tostring(cardChanceThreshold)

    if discordId and discordId ~= "" and discordId ~= 0 and "0" then
        contentStr = "<@!" .. discordId .. ">"
    end

    local data = {
        content = contentStr .. "\n ",
        username = "Anime Card Battles",
        avatar_url = getPlaceThumbnailUrl(),
        embeds = {{
            title = "Rare Card Obtained",
            description = descStr,
            color = 16761889,
            fields = {
                { name = "From: ", value = "Infinite Mode", inline = false },
                { name = "Card Chance", value = "1 / " .. formatNumberWithCommas(cardChance), inline = false },
                { name = "Card Rarity", value = cardRarity, inline = false },
                { name = "Card Name", value = cardName, inline = false },
            },
            footer = {
                text = "UK1 Hub by Av" .. " | " .. "v_" .. _G.versionControl,
                icon_url = footerIconUrl
            }
        }}
    }
    
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Body = httpservice:JSONEncode(data),
            Headers = { ["Content-Type"] = "application/json" }
        })
    end)
    
    if not success then
        warn("Failed to send webhook:", response)
    end
end

local function sendTestWebhook()
    if webhookUrl == "" or webhookUrl == nil then
        warn("Webhook URL not set.")
        return
    end

    local contentStr = "> " .. name .. "\n" .. "> " .. "v_" .. _G.versionControl .. "\n "
    local escapedContent = escapeDiscordFormatting(contentStr)
    local userStr = tostring(player)

    local idStr = "Not Set"
    if discordId and discordId ~= "" and discordId ~= 0 and "0" then
        idStr = "<@!" .. discordId .. ">"
    end

    local data = {
        content = escapedContent,
        username = "Anime Card Battles",
        avatar_url = getPlaceThumbnailUrl(),
        embeds = {{
            title = "Webhook Test",
            description = "Checking Webhook Functionality",
            color = 65280,
            fields = {
                { name = "Card Threshold", value = formatNumberWithCommas(cardChanceThreshold), inline = false },
                { name = "Discord ID", value = idStr, inline = false },
                { name = "User", value = userStr, inline = false },
                { name = "Place ID", value = tostring(game.PlaceId), inline = false },
                { name = "Thumbnail", value = "[Click Here](" .. getPlaceThumbnailUrl() .. ")", inline = false }
            },
            footer = {
                text = "UK1 Hub by Av" .. " | " .. "v_" .. _G.versionControl,
                icon_url = footerIconUrl
            },
        }}
    }
    
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Body = httpservice:JSONEncode(data),
            Headers = { ["Content-Type"] = "application/json" }
        })
    end)
    
    if not success then
        warn("Failed to send test webhook:", response)
    end
end

function AvHub:Function()
    -- Coroutine Functions
    self.startFunction = function(id, func)
        if not coroutinesTable[id] then
            coroutinesTable[id] = coroutine.create(func)
            coroutine.resume(coroutinesTable[id], true)
        end
    end
    
    self.stopFunction = function(id)
        if coroutinesTable[id] then
            coroutine.close(coroutinesTable[id])
            coroutinesTable[id] = nil
        end
    end

    -- Character & Positioning Functions
    self.setPrimaryPart = function()
		player = game.Players.LocalPlayer
		character = player.Character

		if character:FindFirstChild("HumanoidRootPart") then
			character.PrimaryPart = character.HumanoidRootPart
		end
	end

    self.setPrimaryPart()

	player.CharacterAdded:Connect(function(newCharacter)
		player = game.Players.LocalPlayer
		character = newCharacter
		humanoidrootpart = character:WaitForChild("HumanoidRootPart")

		if humanoidrootpart then
			character.PrimaryPart = humanoidrootpart
		end

        task.wait(0.1)
	end)

    self.getPreviousPosition = function(positionKey)
        if character and humanoidrootpart then
            local previousPosition = humanoidrootpart.Position

            previousPositions[positionKey] = Vector3.new(previousPosition.X, (previousPosition.Y + 5), previousPosition.Z)
        end
    end

    self.characterTeleport = function(destination)
        if character and character.PrimaryPart then
            character:SetPrimaryPartCFrame(CFrame.new(destination))
        else
            character = player.Character
            self.setPrimaryPart()
        end
    end

    -- Codes Functions
	self.sendMessage = function(message)
		if textchannel then
			local success, result = pcall(function()
				return textchannel:SendAsync(message)
			end)
		else
			warn("TextChannel not found.")
		end
	end

	self.useCodes = function()
		for i = #codes, 1, -1 do
			task.wait(2.5)
			local message = "/code " .. codes[i]
			self.sendMessage(message)
		end
	end

	self.reverseCodes = function()
		local reversedCodesString = ""

		for i = #codes, 1, -1 do
            task.wait(0.1)
			
            reversedCodesString = reversedCodesString .. codes[i]

			if i > 1 then
				reversedCodesString = reversedCodesString .. "\n"
			end
		end

		return reversedCodesString
	end

	self.reverseCodesCopy = function()
		local copyReversedCodesStr = ""
        
		for i = #codes, 1, -1 do
            task.wait(0.1)
			
            copyReversedCodesStr = copyReversedCodesStr .. "/code " .. codes[i]

			if i > 1 then
				copyReversedCodesStr = copyReversedCodesStr .. "\n"
			end
		end

		return copyReversedCodesStr
	end

    -- Farming Functions
    local function isAutoSwordActive()
        return self.autoSwordToggle.Value
    end

    local function isAutoPotionsActive()
        return self.autoPotionsToggle.Value
    end

    local function hasGrabbedSword() 
		return grabbedSword
	end

    local function isGrabbingChest()
        return grabbingChest
    end

    self.getSword = function()
        local obbySwordPrompt = workspace:FindFirstChild("ObbySwordPrompt")
        if obbySwordPrompt then
            local swordBlock = obbySwordPrompt:FindFirstChild("SwordBlock")
            if swordBlock then
                local swordProximityPrompt = swordBlock:FindFirstChild("ProximityPrompt")
                if swordProximityPrompt then
                    fireproximityprompt(swordProximityPrompt)
                    task.wait(0.2)
                    canGoBack = true
                else
                    if waitForProximityPrompt(swordBlock, 10) then
                        task.wait(0.2)
                        canGoBack = true
                    end
                end
            end
        end
    end
    
    self.autoGetSword = function()
        while isAutoSwordActive() do
            task.wait(1)
            local swordObbyCD = stats:FindFirstChild("SwordObbyCD").Value
            if swordObbyCD == 0 then
                grabbedSword = false
                teleportedBack = false
    
                self.getPreviousPosition("Previous Position Sword")
                task.wait(0.2)
                self.characterTeleport(areaPositions["Sword"])
                task.wait(0.5)
                self.getSword()
    
                if canGoBack and not teleportedBack then
                    task.wait(1)
                    self.characterTeleport(previousPositions["Previous Position Sword"])
                    teleportedBack = true
                    grabbedSword = true
                    canGoBack = false
                end
            elseif swordObbyCD > 0 then
                grabbedSword = true
            end
        end
    end

    self.getPotions = function()
        local activePotions = workspace:FindFirstChild("ActivePotions")
        
        if not activePotions then return end
    
        local function onPotionGrabbed()
            potionCount = potionCount + 1
        end
        
        local connection = activePotions.ChildRemoved:Connect(onPotionGrabbed)
    
        while isAutoPotionsActive() do
            task.wait(0.5)
            for _, potion in ipairs(activePotions:GetChildren()) do
                task.wait(0.5)
                local base = potion:FindFirstChild("Base")
                if base then
                    firetouchinterest(humanoidrootpart, base, 0)
                    task.wait(0.05)
                    firetouchinterest(humanoidrootpart, base, 1)
                end
            end
        end
    
        connection:Disconnect()
        return
    end

    self.claimDailyChest = function()
        grabbingChest = true
        self.getPreviousPosition("Previous Position Chest")
        task.wait(0.25)
        self.characterTeleport(areaPositions["Daily Chest"])
        task.wait(0.75)

        dailyChest = workspace:FindFirstChild("DailyChestPrompt")
        
        if dailyChest then
            dailyChestProximityPrompt = dailyChest:FindFirstChild("ProximityPrompt")
            
            if dailyChestProximityPrompt then
                fireproximityprompt(dailyChestProximityPrompt)
            else
                if waitForProximityPrompt(dailyChest, 10) then
                    grabbingChest = false
                    task.wait(0.5)
                end
            end
        end
        
        task.wait(0.75)
        
        self.characterTeleport(previousPositions["Previous Position Chest"])
    end

    local infRunComplete = false

    -- Battle Functions
    local function isAutoInfiniteActive()
        return self.autoInfiniteToggle.Value
    end
    
    local function isAutoRaidActive()
        return self.autoRaidToggle.Value
    end
    
    local function isAutoRankedActive()
        return self.autoRankedToggle.Value
    end
    
    local function isAutoCloseResultActive()
        return self.autoCloseResultToggle.Value
    end
    
    local function isAutoHideBattleActive()
        return self.autoHideBattleToggle.Value
    end

    local function isWebhookToggleActive()
        return self.webhookToggle.Value
    end
    
    local function isBattleCDActive()
        return player:FindFirstChild("BattleCD") ~= nil
    end
    
    local function waitForBattleCDToEnd()
        while isBattleCDActive() do
            task.wait(0.2)
        end
    end
    
    local function dialogueExists()
        local npcDialogue = playergui:FindFirstChild("NPCDialogue")
        return npcDialogue and npcDialogue.DialogueFrame.Visible
    end
    
    local function foundDialogue()
        return dialogueExists()
    end
    
    local hasSelectedOption = false
    local function handleDialogue()
        local npcDialogue = playergui:FindFirstChild("NPCDialogue")
        if not npcDialogue then return end
        
        local dialogueFrame = npcDialogue:FindFirstChild("DialogueFrame")
        if not dialogueFrame then return end
        
        local responseFrame = dialogueFrame:FindFirstChild("ResponseFrame")
        if not responseFrame then return end
        
        local dialogueOption = responseFrame:FindFirstChild("DialogueOption")
        if dialogueOption and dialogueOption.Visible and dialogueOption:IsDescendantOf(playergui) then
            if not hasSelectedOption then
                guiservice.SelectedObject = dialogueOption
                hasSelectedOption = true
            end
            if guiservice.SelectedObject then
                waitForBattleCDToEnd()
                virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                hasSelectedOption = false
            end
        end

        task.wait(0.5)
        guiservice.SelectedObject = nil
    end
    
    local dialogueConnection
    local function waitForDialogueAndHandle()
        task.wait(0.2)
        if dialogueExists() then
            handleDialogue()
            return
        end
    
        if not dialogueConnection then
            dialogueConnection = playergui.ChildAdded:Connect(function(child)
                if child.Name == "NPCDialogue" then
                    handleDialogue()
                    dialogueConnection:Disconnect()
                    dialogueConnection = nil
                end
            end)
        end
    end
    
    local function isRaidComplete()
        local raidDamageTracker = stats:FindFirstChild("RaidDamageTracker")
        if raidDamageTracker then
            return raidDamageTracker.Value >= damageThreshold
        end
        return false
    end
    
    local function isRaidActive()
        local raidBar = playergui:FindFirstChild("RaidBar")
        local raidActive = raidBar and raidBar:FindFirstChild("RaidActive")
        return raidActive and raidActive.Visible
    end
    
    local function canRaidCheck()
        return isRaidActive() and isAutoRaidActive() and not isRaidComplete()
    end
    
    local function canInfiniteCheck()
        return isAutoInfiniteActive() and (not isAutoRaidActive() or isRaidComplete() or not isRaidActive())
    end
    
    local function toggleProgressBar()
        local raidBar = playergui:FindFirstChild("RaidBar")
        local pb = raidBar and raidBar:FindFirstChild("RaidBar")
        if pb then
            pb.Visible = canRaidCheck()
        end
    end
    
    local function isInVicinity(targetName, margin)
        local targetPosition = battlePositions[targetName]
        if not targetPosition then return false end
    
        local playerPosition = humanoidrootpart.Position
        return (playerPosition - targetPosition).Magnitude <= margin
    end
    
    local bossConditions = {
        ["Adaptive Titan"] = function()
            return canRaidCheck() and not canInfiniteCheck()
        end,
        ["Black Sea Warlord"] = function()
            return canRaidCheck() and not canInfiniteCheck()
        end,
        ["Starlight Devourer"] = function()
            return canRaidCheck() and not canInfiniteCheck()
        end
    }

    local function canTeleport(targetName)
        if isAutoSwordActive() then
            waitUntil(hasGrabbedSword)
            task.wait(0.5)
        end

        waitUntil(function() return not isGrabbingChest() end)

        self.characterTeleport(battlePositions[targetName])
    end
    
    self.checkRaidBoss = function()
        local currentRaidBoss
        local rsCurrentRaid = replicatedstorage:FindFirstChild("RaidActive"):FindFirstChild("CurrentRaid").Value
        local guiRaidBoss = playergui:FindFirstChild("RaidBar"):FindFirstChild("RaidBar"):FindFirstChild("RaidBoss").Text
        
        if rsCurrentRaid == guiRaidBoss then
            currentRaidBoss = tostring(rsCurrentRaid)
            return currentRaidBoss
        end
    end

    local function decideAndTeleport(desiredBoss, current)
        if desiredBoss == "raid" then
            for _, bossName in ipairs(battleNames) do
                if current == bossName then
                    local condition = bossConditions[bossName]
                    if condition and not condition() then
                        return
                    end

                    if not isInVicinity(bossName, 20) and not self.isInRaidBattle() then
                        canTeleport(bossName)
                    end
        
                    break
                end
            end
        elseif desiredBoss == "Heaven Infinite" then
            if not isInVicinity("Heaven Infinite", 20) then
                canTeleport("Heaven Infinite")
            end
            return
        end
    end
    
    self.isInInfiniteBattle = function()
        local battleTowerStat = stats:FindFirstChild("BattleTower")
        return battleTowerStat and battleTowerStat.Value
    end
    
    self.isInRaidBattle = function()
        local battleLabel = playergui:WaitForChild("HideBattle"):FindFirstChild("BATTLE")
        if not battleLabel or battleLabel.Text ~= "CURRENTLY IN BATTLE" then
            return false
        end
    
        local battleMenu = playergui:FindFirstChild("BattleMenu")
        local battle = battleMenu and battleMenu:FindFirstChild("Battle")
        local cardName = battle and battle:FindFirstChild("EnemyCard")
            and battle:FindFirstChild("LibraryFrame")
            and battle:FindFirstChild("CardName")
            and battle:FindFirstChild("CardName").Text
    
        return cardName == "Adaptive Titan" and #battle:FindFirstChild("EnemyParty"):GetChildren() == 2
    end

    local function waitForBattleToEnd(battleType)
    
        local checkFunction = (battleType == "raid") and self.isInRaidBattle or self.isInInfiniteBattle
        while checkFunction() do
            task.wait(0.5)
        end
    end
    
    local infStatus = ""
    local function pauseInfinite(child)
        if child.Name == "BATTLETOWERUI" then
            local giveUpButton = child:FindFirstChild("Background"):FindFirstChild("PauseButton")
            if giveUpButton then
                guiservice.SelectedObject = giveUpButton
                virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.1)
                virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                infStatus = "paused"
            end
        end
    end
    
    self.cancelInfiniteBattle = function()
        if not self.isInInfiniteBattle() then return end
    
        local towerConnection
        towerConnection = playergui.ChildAdded:Connect(function(child)
            if not canInfiniteCheck() then
                pauseInfinite(child)
                if not self.isInInfiniteBattle() then
                    towerConnection:Disconnect()
                    towerConnection = nil
                end
            end
        end)
    end

    self.autoRaid = function()
        while isAutoRaidActive() do
            task.wait(0.5)
            if canRaidCheck() then
                toggleProgressBar()
    
                if self.isInInfiniteBattle() then
                    infRunComplete = false
                    self.cancelInfiniteBattle()
                    waitForBattleToEnd("infinite")
                end
                
                local current = self.checkRaidBoss()

                if not self.isInRaidBattle() then
                    decideAndTeleport("raid", current)
                end

                local titanHRP = waitForTarget(current, gamebosses, 10)
                if titanHRP then
                    waitForBattleToEnd("raid")
                    while not waitForProximityPrompt(titanHRP, 10) do
                        if not canRaidCheck() then break end
                        task.wait(0.2)
                    end
                end
    
                repeat
                    if not canRaidCheck() or self.isInRaidBattle() then break end
                    local hasDialogue = foundDialogue()
                    if hasDialogue then
                        handleDialogue()
                    else
                        waitUntil(function() return not hasDialogue end)
                        waitForDialogueAndHandle()
                        break
                    end
                    task.wait(1)
                until self.isInRaidBattle()
    
                task.wait(0.5)
            end
        end
    end    

    self.autoInfinite = function()
        task.wait(1)
        while isAutoInfiniteActive() do
            task.wait(0.5)
    
            if isAutoRaidActive() and isRaidActive() and not isRaidComplete() then
                self.cancelInfiniteBattle()
                break
            end
    
            if canInfiniteCheck() then
                if not self.isInInfiniteBattle() then
                    decideAndTeleport("Heaven Infinite", "Heaven Infinite")
                end
    
                if self.isInInfiniteBattle() then
                    infRunComplete = false
                    repeat 
                        if canRaidCheck() then return end
                        if not canInfiniteCheck() then return end
                        task.wait(0.5) 
                    until not self.isInInfiniteBattle()
                    infRunComplete = true
                end
                
                toggleProgressBar()
    
                local davidHRP = waitForTarget("David", gamenpcs, 10)
                if davidHRP then
                    waitForBattleToEnd("infinite")
                    while not waitForProximityPrompt(davidHRP, 10) do
                        if not canInfiniteCheck() then return end
                        task.wait(0.2)
                    end
                end
    
                local dialogueFound = foundDialogue()
                repeat
                    if canRaidCheck() then return end
                    if not canInfiniteCheck() then return end
    
                    if dialogueFound then
                        handleDialogue()
                    else
                        waitUntil(function() return not dialogueFound end)
                        waitForDialogueAndHandle()
                        break
                    end
    
                    task.wait(1)
                until self.isInInfiniteBattle()
                
                infStatus = "running"
                task.wait(0.5)
            end
        end
    end   

    self.autoHideBattle = function()
        while isAutoHideBattleActive() do
            hideBattle = stats:FindFirstChild("HideBattle")
            if hideBattle then
                hideBattle.Value = true
            end
            task.wait(1)
        end
    end

    local function handleRemoteEvent(remoteEvent)
        remoteEvent.OnClientEvent:Connect(function(...)
            if not isWebhookToggleActive() then
                return
            end
    
            local args = {...}
            if args[1] == "OpenQuickPack" then
                local cardChance = args[2].CardChance
                if cardChance and cardChance >= cardChanceThreshold then
                    sendRolledWebhook(
                        cardChance,
                        args[2].CardRarity,
                        args[2].CardName,
                        args[2].PackType
                    )
                end
            end

            local args = {...}
            if args[1] == "OpenQuickPack" or args[1] == "OpenCardPack" then 
                
            end
        end)
    end

    local function getCardInfo(itemName)
        local rarities = {"Normal", "Gold", "Rainbow", "Universal"}
       
        local nameParts = string.split(itemName, " ")
        
        local cardRarity = "Unknown"
        local cardName = itemName
        
        for _, rarity in ipairs(rarities) do
            if nameParts[1] == rarity then
                cardRarity = rarity
                cardName = table.concat(nameParts, " ", 2)
                break
            end
        end
        
        return cardRarity, cardName
    end    

    local function destroyInstantRoll(instance)
        if instance.Name == "InstantRoll" then
            task.wait(0.5)

            instance:Destroy()
        end
    end

    local currentlyChecking = false
    local doneProcessing = false
    local function checkInventory()

        if doneProcessing then
            return true
        end
        
        if currentlyChecking then
            return false
        end

        currentlyChecking = true

        local inventory
        for _, child in ipairs(playergui:GetChildren()) do
            task.wait(0.2)
            if child.Name == "InstantRoll" then
                inventory = playergui.InstantRoll.InstantPullLibrary.Inventory
                break
            end
        end
    
        inventory = inventory or playergui.InstantRoll.InstantPullLibrary.Inventory
        local cardChances = {}
        local totalItems = #inventory:GetChildren()
        local itemsProcessed = 1
    
        for _, item in pairs(inventory:GetChildren()) do
            local cardChanceText = item:FindFirstChild("CardChance")
            local cardRarity, cardName = getCardInfo(item.Name)
    
            if cardChanceText and tonumber(cardChanceText.Text) then
                local cardChance = tonumber(cardChanceText.Text)
    
                if math.floor(cardChance) == cardChance then
                    table.insert(cardChances, cardChance)
                    itemsProcessed = itemsProcessed + 1
                    
                    if cardChance >= cardChanceThreshold then
                        if isWebhookToggleActive() then
                            sendInfiniteWebhook(cardChance, cardName, cardRarity)
                        end
                    end
                end
            end
        end
    
        if itemsProcessed == totalItems then

            doneProcessing = true
            currentlyChecking = false
        
            destroyInstantRoll(playergui.InstantRoll)

            return true
        end
        return itemsProcessed == totalItems
    end    

    local function waitUntilAllCardsLogged()
        return function()
            return currentlyChecking
        end
    end

    local cardConnection, instantConnection
    local function onInstantAdded(child)
        if child:IsA("InstantRoll") then
            if child.Name == "InstantRoll" then
                checkInventory()
            end
        else
            return
        end
    end

    self.handleWebhooks = function()
        local function onRemoteAdded(remote)
            if not isWebhookToggleActive() then
                if cardConnection then
                    cardConnection:Disconnect()
                    cardConnection = nil
                end
                return
            end
    
            if remote:IsA("RemoteEvent") and remote.Name == "ClientEffects" then
                handleRemoteEvent(remote)
            end
        end
    
        for _, remote in pairs(replicatedstorage.Remotes:GetChildren()) do
            if not isWebhookToggleActive() then
                return
            end
            onRemoteAdded(remote)
        end
    
        for _, child in ipairs(playergui:GetChildren()) do
            if child.Name == "InstantRoll" then
                checkInventory()
                break
            end
        end

        if not cardConnection then
            cardConnection = replicatedstorage.Remotes.ChildAdded:Connect(onRemoteAdded) 
        end

        while isWebhookToggleActive() do
            task.wait(0.5)
            if not instantConnection then
                instantConnection = playergui.ChildAdded:Connect(onInstantAdded)
            end
        end
    
        if cardConnection then
            cardConnection:Disconnect()
            cardConnection = nil
        end

        if instantConnection then
            instantConnection:Disconnect()
            instantConnection = nil
        end
    end  
    
    self.autoCloseResult = function()
        local connection
    
        for _, child in ipairs(playergui:GetChildren()) do
            task.wait(0.2)
            destroyInstantRoll(child)
        end
    
        while isAutoCloseResultActive() do
            task.wait(0.2)
            if not connection then
                connection = playergui.ChildAdded:Connect(destroyInstantRoll)
            end
        end
    
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    -- Paragraph Functions    
    self.updateFarmParagraph = function()
        local timeLeft, swordTimer
        while isAutoSwordActive() or isAutoPotionsActive() do
            task.wait(0.2)
            
            swordTimer = stats:FindFirstChild("SwordObbyCD").Value

            if swordTimer then
                timeLeft = swordTimer
            else
                timeLeft = "N/A"
            end

            farmParagraph:SetDesc("Potions Collected: " .. tostring(potionCount) 
            .. "\n" .. "Sword Cooldown: " .. tostring(timeLeft) 
            )
        end
    end

    local loggedHighestFloor = 0
    local function logHighestFloor()
        if previousRunFloor > 0 then
            loggedHighestFloor = previousRunFloor
        end
    end
    
    local function checkFloors()
        local currentFloorValue = stats:FindFirstChild("CurrentInfFloorProgress").Value
        if self.isInInfiniteBattle() then
            currentRunFloor = currentFloorValue
            if currentRunFloor >= previousRunFloor then
                previousRunFloor = currentRunFloor
            end
        else
            logHighestFloor()
            highestFloor = 0
            currentRunFloor = 0
        end
    end

    self.updateBattleParagraph = function()
        while isAutoRaidActive() or isAutoInfiniteActive() do
            if isRaidComplete() then
                previousRunDamage = 0
            end

            raidDamageTracker = stats.RaidDamageTracker.Value
            
            if raidDamageTracker > previousRunDamage then
                if raidDamageTracker <= damageThreshold then
                    damageDealt = (tonumber(raidDamageTracker) - tonumber(previousRunDamage))
                end
                previousRunDamage = raidDamageTracker
            end

            if previousRunDamage == raidDamageTracker then
                damageDealt = 0
            end

            formattedRaidDamageTracker = formatNumberWithCommas(raidDamageTracker)
            formattedThreshold = formatNumberWithCommas(damageThreshold)
            formattedDamageDealt = formatNumberWithCommas(damageDealt)

            highestFloor = stats:FindFirstChild("HeavensArenaInfiniteFloor").Value

            local percentage = (raidDamageTracker / damageThreshold) * 100
            local formattedPercentage = string.format("%.2f", percentage)

            if self.isInInfiniteBattle() then
                checkFloors()
            end

           if self.isInInfiniteBattle() or self.isInRaidBattle() then
                battleInProgress = true
            else
                battleInProgress = false
            end

            if isRaidActive() then
                raidText = "Open"
            else
                raidText = "Closed"
            end

            if isRaidActive() and isRaidComplete() then
                raidText = raidText .. " (completed)"
            elseif isRaidActive() and not isRaidComplete() then
                raidText = raidText .. " (raiding)"
            elseif not isRaidActive() and isRaidComplete() then
                raidText = raidText .. " (waiting)"
            end

            formattedHighestFloor = formatNumberWithCommas(highestFloor)
            formattedLoggedHighestFloor = formatNumberWithCommas(loggedHighestFloor)
            formattedCurrentRunFloor = formatNumberWithCommas(currentRunFloor)

            local runStr = ""
            if infStatus == "paused" then
                runStr = "Paused on: " .. formattedCurrentRunFloor
            elseif infStatus == "running" then
                runStr = "Current Floor: " .. formattedCurrentRunFloor
            elseif infStatus == "" then
                runStr = "Current Floor: N/A"
            end

            battleParagraph:SetDesc("Raid Status: " .. raidText
                .. "\nRaid Progress: " .. formattedPercentage .. "%"
                .. "\nRaid Damage: " .. formattedRaidDamageTracker
                .. "\nPrevious Attempt: " .. formattedDamageDealt
                .. "\nHighest Floor: " .. formattedHighestFloor
                .. "\nPrevious Run: " .. formattedLoggedHighestFloor
                .. "\n" .. runStr
            )

            task.wait(0.5)
        end
    end

    self.updateHubInfoParagraph = function ()
        while hubInit do
            uptimeInSeconds = tick() - tickCount
			hours = math.floor(uptimeInSeconds / 3600)
			minutes = math.floor((uptimeInSeconds % 3600) / 60)
			seconds = uptimeInSeconds % 60
			uptimeText = string.format("%dh %dm %ds", hours, minutes, seconds)

            antiAfkStatus = antiAfk()
            local antiAFKstring
            if antiAfkStatus then
                antiAFKstring = "On"
            else
                antiAFKstring = "Off"
            end

            local autoLoadStatus
            if _G.autoLoad then
                autoLoadStatus = "On"
            else
                autoLoadStatus = "Off"
            end

            hubInfoParagraph:SetDesc(
            "Uptime: " .. tostring(uptimeText)
            .. "\n" .. "Anti-AFK: " .. antiAFKstring
            .. "\n" .. "Autoload: " .. autoLoadStatus
            )

            task.wait(0.2)
        end
    end

    -- Coroutine Functions
    self.manageFarmParagraph = function()
        if isAutoSwordActive() or isAutoPotionsActive() then
            if not coroutinesTable["farmParagraph"] then
                self.startFunction("farmParagraph", self.updateFarmParagraph)
            end
        else
            self.stopFunction("farmParagraph")
        end
    end

    self.manageBattleParagraph = function()
        if isAutoRaidActive() or isAutoInfiniteActive() then
            if not coroutinesTable["battleParagraph"] then
                self.startFunction("battleParagraph", self.updateBattleParagraph)
            end
        else
            self.stopFunction("battleParagraph")
        end
    end

    self.manageHubInfoParagraph = function()
        if hubInit then
            self.startFunction("hubInfoParagraph", self.updateHubInfoParagraph)
        else
            self.stopFunction("hubInfoParagraph")
        end
    end

    self.manageRaidCoroutine = function()
        while isAutoRaidActive() and canRaidCheck() do
            if not coroutinesTable["raid"] then
                self.startFunction("raid", self.autoRaid)
                self.manageBattleParagraph()
            end
            task.wait(0.5)
        end
        if not isAutoRaidActive() or not canRaidCheck() then
            self.stopFunction("raid")
        end
    end

    self.manageInfiniteCoroutine = function()
        while isAutoInfiniteActive() and canInfiniteCheck() do
            if not coroutinesTable["infinite"] then
                self.startFunction("infinite", self.autoInfinite)
                self.manageBattleParagraph()
            end
            task.wait(0.5)
        end
        if not isAutoInfiniteActive() and not canInfiniteCheck() then
            self.stopFunction("infinite")
        end
    end

    self.managePotionsCoroutine = function()
        while isAutoPotionsActive() do
            if not coroutinesTable["potions"] then
                self.startFunction("potions", self.getPotions)
                self.manageFarmParagraph()
            end
            task.wait(0.5)
        end
        if not isAutoPotionsActive() then
            self.stopFunction("potions")
        end
    end

    self.manageSwordCoroutine = function()
        while isAutoSwordActive() do
            if not coroutinesTable["sword"] then
                self.startFunction("sword", self.autoGetSword)
                self.manageFarmParagraph()
            end
            task.wait(0.5)
        end
        if not isAutoSwordActive() then
            self.stopFunction("sword")
        end
    end

    self.manageRankedCoroutine = function()
        while isAutoRankedActive() do
            if not coroutinesTable["ranked"] then
                self.startFunction("ranked", self.autoRanked)
            end
            task.wait(0.5)
        end
        if not isAutoRankedActive() then
            self.stopFunction("ranked")
        end
    end

    self.manageCloseResultCoroutine = function()
        while isAutoCloseResultActive() do
            if not coroutinesTable["closeResult"] then
                self.startFunction("closeResult", self.autoCloseResult)
            end
            task.wait(0.5)
        end
        if not isAutoCloseResultActive() then
            self.stopFunction("closeResult")
        end
    end

    self.manageHideBattleCoroutine = function()
        while isAutoHideBattleActive() do
            if not coroutinesTable["hideBattle"] then
                self.startFunction("hideBattle", self.autoHideBattle)
            end
            task.wait(0.5)
        end
        if not isAutoHideBattleActive() then
            self.stopFunction("hideBattle")
        end
    end

    self.manageWebhookCoroutine = function()
        while isWebhookToggleActive() do
            if not coroutinesTable["webhook"] then
                self.startFunction("webhook", self.handleWebhooks)
            end
            task.wait(0.5)
        end
        if not isWebhookToggleActive() then
            self.stopFunction("webhook")
        end
    end
    functionsInit = true
end

function AvHub:GUI()
    -- Window & Tabs
	guiWindow[randomKey] = Fluent:CreateWindow({
		Title = "UK1",
		SubTitle = "Anime Card Battles",
		TabWidth = 80,
		Size = UDim2.fromOffset(420, 372.5),
		Acrylic = true,
		Theme = "Avalanche",
		MinimizeKey = Enum.KeyCode.LeftControl
	})
	local Tabs = {
		Main = guiWindow[randomKey]:AddTab({
			Title = "Main",
			Icon = "info"
		}),
		Auto = guiWindow[randomKey]:AddTab({
			Title = "Auto",
			Icon = "repeat"
		}),
		Stats = guiWindow[randomKey]:AddTab({
			Title = "Stats",
			Icon = "bar-chart"
		}),
		Teleports = guiWindow[randomKey]:AddTab({
			Title = "Teleports",
			Icon = "navigation"
		}),
        Cards = guiWindow[randomKey]:AddTab({
            Title = "Cards",
            Icon = "book-open"
        }),
		Codes = guiWindow[randomKey]:AddTab({
			Title = "Codes",
			Icon = "baseline"
		}),
		Misc = guiWindow[randomKey]:AddTab({
			Title = "Misc",
			Icon = "circle-ellipsis"
		}),
        Settings = guiWindow[randomKey]:AddTab({
			Title = "Settings",
			Icon = "save"
		}),
	}

    -- GUI Variables
    local informationParagraph, latestParagraph, previousUpdateParagraph

    local farmSection, battleSection, miscSection

    local bossesSection
    local interactionsDropdown, battlesDropdown, areasDropdown, repeatBossDropdown, normalBossDropdown

    local codesSection, codeInfoText
    local codeInfoParagraph, codesParagraph

    -- GUI Information
	local Options = Fluent.Options
    local versionStr = "v_" .. version .. "_" .. release
	local devs = "Av"

    -- Main Tab
	informationParagraph = Tabs.Main:AddParagraph({
		Title = "Information" .. "\n",
		Content = "Version :" 
		.. "\n" .. versionStr
		.. "\n\n" .. "Made By :" 
		.. "\n" .. devs
        .. "\n\n" .. "Extra :"
        .. "\n" .. "Add the following before the loadstring to customise"
        .. "\n" .. "_G.autoLoad = true"
        .. "\n" .. "loads config on startup"
        .. "\n" .. "_G.desiredVersion = \"" .. tostring(_G.versionControl)  .. "\""
        .. "\n" .. "checks for desired version, prints error if not found"
	})

	latestParagraph = Tabs.Main:AddParagraph({
		Title = "Latest" .. "\n",
		Content = "Changes :"
        .. "\n" .. "Added new bosses to Auto Raid"
        .. "\n" .. "Added Webhooks in Settings"

        .. "\n\n" .. "Coming Soon :"
		.. "\n" .. "Webhooks"
		.. "\n\n" .. "Future :"
		.. "\n" .. "Auto repeat Bosses"
	})

    previousUpdateParagraph = Tabs.Main:AddParagraph({
        Title = "Previous Update" .. "\n",
        Content = "Changes :"
        .. "\n" .. "Auto Raid pauses Infinite instead of giving up now"
        .. "\n" .. "Fixed Auto Raids Lag"
        .. "\n" .. "Fixed Auto Infinite Lag"
        .. "\n" .. "Added 3 new themes:\nHellfire, Nebula, Dusk"
    })

    -- Auto Tab
    farmSection = Tabs.Auto:AddSection("Farm")
    self.autoPotionsToggle = Tabs.Auto:AddToggle("AutoPotions", {
		Title = "Auto Potions",
		Description = "Auto Grabs Potions",
		Default = false
	})
	self.autoSwordToggle = Tabs.Auto:AddToggle("AutoSword", {
		Title = "Auto Sword",
		Description = "Auto Claims Sword",
		Default = false
	})

    battleSection = Tabs.Auto:AddSection("Battle")
    self.autoRaidToggle = Tabs.Auto:AddToggle("AutoRaid", {
		Title = "Auto Raid",
		Description = "Auto Starts Raid",
		Default = false
	})
	self.autoInfiniteToggle = Tabs.Auto:AddToggle("AutoInfinite", {
		Title = "Auto Infinite",
		Description = "Auto Starts Infinite",
		Default = false
	})
    self.autoRankedToggle = Tabs.Auto:AddToggle("AutoRanked", {
        Title = "Auto Ranked",
        Description = "Auto Starts Ranked",
        Default = false
    })
    self.autoCloseResultToggle = Tabs.Auto:AddToggle("AutoCloseResult", {
        Title = "Auto Close Result",
        Description = "Auto Closes Result",
        Default = false
    })
    self.autoHideBattleToggle = Tabs.Auto:AddToggle("AutoHideBattle", {
        Title = "Auto Hide Battle",
        Description = "Auto Hides Battle",
        Default = false
    })

    miscSection = Tabs.Auto:AddSection("Misc")
	self.claimChestButton = Tabs.Auto:AddButton({
		Title = "Claim Daily Chest",
		Description = "Claims Daily Chest",
		Callback = function()
			task.spawn(self.claimDailyChest)
		end
	})

    self.webhookToggle = Tabs.Settings:AddToggle("WebhookToggle", {
        Title = "Enable Webhooks",
        Description = "Sends Webhooks for Rare Cards",
        Default = false
    })

    self.testWebhook = Tabs.Settings:AddButton({
        Title = "Test Webhook",
        Callback = function()
            sendChangedWebhook("Value 1", "Value 2", "Test Webhook")
        end
    })

    self.cardThresholdInput = Tabs.Settings:AddInput("CardThresholdInput", {
        Title = "Card Threshold",
        Default = cardChanceThreshold,
        Placeholder = formatNumberWithCommas(cardChanceThreshold),
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            cardChanceThreshold = tonumber(Value)
        end
    })

    self.discordIdInput = Tabs.Settings:AddInput("discordIdInput", {
        Title = "Discord User ID",
        Default = discordId,
        Placeholder = "Discord User ID",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            discordId = Value
        end
    })

    self.webhookUrlInput = Tabs.Settings:AddInput("WebhookUrlInput", {
        Title = "Webhook URL",
        Default = webhookUrl,
        Placeholder = "Webhook URL",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            webhookUrl = Value
        end
    })

    self.webhookToggle:OnChanged(function()
        if hubInit then
            if self.webhookToggle.Value then
                if webhookUrl == "" then
                    guiWindow[randomKey]:Dialog({
                        Title = "Error",
                        Content = "Please enter your Discord UserId & Webhook URL",
                        Buttons = {
                            {
                                Title = "Confirm",
                                Callback = function()
                                    self.webhookToggle.Value = false
                                    self.webhookToggle:SetValue(false)
                                end
                            }
                        }
                    })
                    self.webhookToggle.Value = false
                    self.webhookToggle:SetValue(false)
                    return
                end
        
                local state = true
                self.manageWebhookCoroutine(state)
            elseif not self.webhookToggle.Value then
                local state = false
                self.manageWebhookCoroutine(state)
            end
        end
    end)
    
    self.discordIdInput:OnChanged(function(Value)
        if hubInit then
            sendChangedWebhook(discordId, Value, "Discord User ID")
            discordId = Value
        end
    end)

    self.webhookUrlInput:OnChanged(function(Value)
        if hubInit then
            webhookUrl = Value
        end
    end)

    self.cardThresholdInput:OnChanged(function(Value)
        if hubInit then
            sendChangedWebhook(cardChanceThreshold, Value, "Card Threshold")
            cardChanceThreshold = tonumber(Value)
        end
    end)

    -- Stats Tab
    farmParagraph = Tabs.Stats:AddParagraph({
        Title = "Farm",
        Content = "Potions Collected: " .. "N/A"
        .. "\n" .. "Sword Cooldown: " .. "N/A"
    })
    battleParagraph = Tabs.Stats:AddParagraph({
        Title = "Battle",
        Content = "Raid Status: " .. "N/A"
        .. "\n" .. "Total Damage: " .. "N/A" .. " / " .. "N/A"
        .. "\n" .. "Damage Dealt: " .. "N/A"
        .. "\n" .. "Highest Floor: " .. "N/A"
        .. "\n" .. "Previous Run: " .. "N/A"
        .. "\n" .. "Current Run: " .. "N/A"
    })
    hubInfoParagraph = Tabs.Stats:AddParagraph({
        Title = "Extra",
        Content = "Uptime: " .. "N/A"
        .. "\n" .. "Anti-AFK: " .. "N/A"
        .. "\n" .. "AutoLoad: " .. "N/A"
    })

    -- Teleports Tab
    interactionsDropdown = Tabs.Teleports:AddDropdown("Interactions", {
        Title = "Interactions",
        Values = interactionNames,
        Multi = false,
        Default = nil
    })

    battlesDropdown = Tabs.Teleports:AddDropdown("Battles", {
        Title = "Battles",
        Values = battleNames,
        Multi = false,
        Default = nil
    })

    areasDropdown = Tabs.Teleports:AddDropdown("Areas", {
        Title = "Areas",
        Values = areaNames,
        Multi = false,
        Default = nil
    })

    bossesSection = Tabs.Teleports:AddSection("Bosses")
    repeatBossDropdown = Tabs.Teleports:AddDropdown("Repeat", {
        Title = "Repeat",
        Values = repeatBossNames,
        Multi = false,
        Default = nil
    })

    normalBossDropdown  = Tabs.Teleports:AddDropdown("Normal", {
        Title = "Normal",
        Values = normalBossNames,
        Multi = false,
        Default = nil
    })

    -- Codes Tab
    self.claimCodesButton = Tabs.Codes:AddButton({
		Title = "Claim All Codes",
		Description = "Claims all codes",
		Callback = function()
			self.useCodes()
		end
	})

	self.copyCodesButton = Tabs.Codes:AddButton({
		Title = "Copy All Codes",
		Description = "Copies all codes",
		Callback = function()
			setclipboard(self.reverseCodesCopy())
		end
	})

    codeInfoText = "Total Codes: " .. #codes
    .. "\n" .. "Some Codes Might Not Work" 
    .. "\n" .. "Newest -> Oldest"

    codeInfoParagraph = Tabs.Codes:AddParagraph({
        Title = "SCROLL DOWN",
        Content = codeInfoText
    })

    codesSection = Tabs.Codes:AddSection("List Of Codes")

    local MAX_CODES_PER_PARAGRAPH = 15
    self.displayCodesInParagraphs = function()
        local codeCount = #codes
    
        local numChunks = math.ceil(codeCount / MAX_CODES_PER_PARAGRAPH)
    
        local codesPerChunk = math.ceil(codeCount / numChunks)
    
        local startIndex = codeCount
    
        while startIndex > 0 do
            local endIndex = math.max(startIndex - codesPerChunk + 1, 1)
    
            local codesChunk = ""
            for i = startIndex, endIndex, -1 do
                codesChunk = codesChunk .. codes[i]
                if i > endIndex then
                    codesChunk = codesChunk .. "\n"
                end
            end
    
            Tabs.Codes:AddParagraph({
                Title = "Page " .. tostring(math.ceil((codeCount - startIndex + 1) / codesPerChunk)) .. "\n",
                Content = codesChunk
            })
    
            startIndex = endIndex - 1
        end
    end
    
	self.displayCodesInParagraphs()

    -- Misc Tab
    self.miscRejoinGameButton = Tabs.Misc:AddButton({
		Title = "Rejoin game",
		Description = "Rejoins the game",
		Callback = function()
			rejoinGame()
		end
	})
	self.miscJoinRandomServerButton = Tabs.Misc:AddButton({
		Title = "Join Random Server",
		Description = "Joins a random public server",
		Callback = function()
			self.joinPublicServer()
		end
	})

    -- Tools Tab
    if isDeveloper(playerid) then 
        local toolsAdded = false
        Tabs.Tools = guiWindow[randomKey]:AddTab({
            Title = "Tools",
            Icon = "bug"
        })

        self.funcButton1 = Tabs.Tools:AddButton({
            Title = "Current Function",
            Description = "isInInfiniteBattle",
            Callback = function()
                local isInInfiniteBattle = self.isInInfiniteBattle()
            end
        })

        local funcPos2
        self.funcInput2 = Tabs.Tools:AddInput("Function Input", {
            Title = "Function Input",
            Default = "",
            Placeholder = "Function Input",
            Numeric = false,
            Finished = false,
            Callback = function(Value)
                local x, y, z = Value:match("^%s*([%d.-]+),%s*([%d.-]+),%s*([%d.-]+)%s*$")
                if x and y and z then
                    funcPos2 = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
                end
            end
        })
        
        self.funcButton2 = Tabs.Tools:AddButton({
            Title = "Current Function",
            Description = "characterTeleport",
            Callback = function()
                if funcPos2 then
                    self.characterTeleport(funcPos2)
                end
            end
        })        

        self.showToolsButton = Tabs.Tools:AddButton({
            Title = "Show Tools",
            Description = "Adds Tools",
            Callback = function()
                local function showTools()
                    if toolsAdded then
                        return
                    end
                    -- Tools Variables
                    local loggedPositionX, loggedPositionY, loggedPositionZ
                
                    -- Tools Functions
                    self.teleportToPosition = function(x, y, z)
                        if character and character.PrimaryPart then
                            local pos = Vector3.new(x, y, z)
                            character:SetPrimaryPartCFrame(CFrame.new(pos))
                        else
                            character = player.Character
                            self.setPrimaryPart()
                        end
                    end
                    self.getPosition = function()
                        if character and humanoidrootpart then
                            local position = humanoidrootpart.Position
                            loggedPositionX, loggedPositionY, loggedPositionZ = position.X, position.Y, position.Z
                            local dataString = string.format("%.6f, %.6f,%.6f", position.X, position.Y, position.Z)
                            setclipboard(dataString)
                            return loggedPositionX, loggedPositionY, loggedPositionZ
                        else
                            if not character then
                                warn("Character not found for player:", player.Name)
                            end
                            if not humanoidrootpart then
                                warn("HumanoidRootPart not found for player:", player.Name)
                            end
                            return nil, nil, nil
                        end
                    end
                    self.teleportToLoggedPosition = function()
                        if loggedPositionX and loggedPositionY and loggedPositionZ then
                            self.teleportToPosition(loggedPositionX, loggedPositionY, loggedPositionZ)
                        else
                            warn("Logged position is not set.")
                        end
                    end
                    self.joinPublicServer = function()
                        task.wait(1)
                        local serversurl = api .. placeid .. "/servers/Public?sortOrder=Asc&limit=10"
                        local function listServers(cursor)
                            local raw = game:HttpGet(serversurl .. (cursor and "&cursor=" .. cursor or ""))
                            return httpservice:JSONDecode(raw)
                        end
                        local servers = listServers()
                        local server = servers.data[math.random(1, #servers.data)]
                        teleportservice:TeleportToPlaceInstance(placeid, server.id, player)
                    end
                    
                    -- Tools Tab
                    self.toolsRejoinGameButton = Tabs.Tools:AddButton({
                        Title = "Rejoin Game",
                        Callback = function()
                            rejoinGame()
                        end
                    })
                    self.toolsJoinPublicServerButton = Tabs.Tools:AddButton({
                        Title = "Join Public Server",
                        Callback = function()
                            joinPublicServer()
                        end
                    })
                    self.toolsDexButton = Tabs.Tools:AddButton({
                        Title = "Dex",
                        Callback = function()
                            local dexLink = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"
                            (loadstring(game:HttpGet(dexLink)))()
                        end
                    })
                    self.toolsRemoteSpyButton = Tabs.Tools:AddButton({
                        Title = "Remote Spy",
                        Callback = function()
                            local remoteSpyLink = "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"
                            (loadstring(game:HttpGet(remoteSpyLink)))()
                        end
                    })
                    self.toolsInfiniteYieldButton = Tabs.Tools:AddButton({
                        Title = "Infinite Yield",
                        Callback = function()
                            local infiniteYieldLink = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
                            (loadstring(game:HttpGet(infiniteYieldLink)))()
                        end
                    })
                    self.toolsGetPositionButton = Tabs.Tools:AddButton({
                        Title = "Get Position",
                        Callback = function()
                            task.spawn(self.getPosition)
                        end
                    })
                    self.toolsTeleportToPositionButton = Tabs.Tools:AddButton({
                        Title = "Teleport to Logged Position",
                        Callback = function()
                            task.spawn(self.teleportToLoggedPosition)
                        end
                    })
                    self.toolsCopyPlayerIdButton = Tabs.Tools:AddButton({
                        Title = "Copy Player Id",
                        Callback = function()
                            setclipboard(tostring(playerid))
                        end
                    })
                    self.toolsCopyPlaceIdButton = Tabs.Tools:AddButton({
                        Title = "Copy Place Id",
                        Callback = function()
                            setclipboard(tostring(placeid))
                        end
                    })
                    self.toolsCopyJobIdButton = Tabs.Tools:AddButton({
                        Title = "Copy Job Id",
                        Callback = function()
                            setclipboard(tostring(jobid))
                        end
                    })
                    self.toolsCopyCreatorIdButton = Tabs.Tools:AddButton({
                        Title = "Copy Creator Id",
                        Callback = function()
                            setclipboard(tostring(creatorid))
                        end
                    })
                    local infodata = "User: " .. username .. " (" .. displayname .. ")" .. "\nPlayer Id: " .. playerid .. "\nAccount Age: " .. playerage .. "\nPlace Id: " .. placeid .. "\nJob Id: " .. jobid .. "\nCreator Id: " .. creatorid .. " (" .. tostring(creatortype) .. ")"
                    Tabs.Tools:AddParagraph({
                        Title = "Info",
                        Content = infodata
                    })
                    toolsAdded = true
                end
                showTools()
            end
        })
    end

    -- OnChanged
    self.autoPotionsToggle:OnChanged(function()
        if hubInit then
            local state = self.autoPotionsToggle.Value
            if self.autoPotionsToggle.Value then
                self.managePotionsCoroutine(state)
            elseif not self.autoPotionsToggle.Value then
                self.managePotionsCoroutine(state)
            end
        end
    end)

    self.autoSwordToggle:OnChanged(function()
        if hubInit then
            if self.autoSwordToggle.Value then
                local swordState = true
                self.manageSwordCoroutine(swordState)
            elseif not self.autoSwordToggle.Value then
                local swordState = false
                self.manageSwordCoroutine(swordState)
            end
        end
    end)

    self.autoRaidToggle:OnChanged(function()
        if hubInit then
            if self.autoRaidToggle.Value then
                local raidState = true
                self.manageRaidCoroutine(raidState)
            elseif not self.autoRaidToggle.Value then
                local raidState = false
                self.manageRaidCoroutine(raidState)
            end
        end
    end)

    self.autoInfiniteToggle:OnChanged(function()
        if hubInit then
            if self.autoInfiniteToggle.Value then
                local infiniteState = true
                self.manageInfiniteCoroutine(infiniteState)
            elseif not self.autoInfiniteToggle.Value then
                local infiniteState = false
                self.manageInfiniteCoroutine(infiniteState)
            end
        end
    end)

    self.autoRankedToggle:OnChanged(function()
        if hubInit then
            if self.autoRankedToggle.Value then
                local rankedState = true
                self.manageRankedCoroutine(rankedState)
            elseif not self.autoRankedToggle.Value then
                local rankedState = false
                self.manageRankedCoroutine(rankedState)
            end
        end
    end)

    self.autoCloseResultToggle:OnChanged(function()
        if hubInit then
            if self.autoCloseResultToggle.Value then
                local state = true
                self.manageCloseResultCoroutine(state)
            elseif not self.autoCloseResultToggle.Value then
                local state = false
                self.manageCloseResultCoroutine(state)
            end
        end
    end)

    self.autoHideBattleToggle:OnChanged(function()
        if hubInit then
            if self.autoHideBattleToggle.Value then
                local state = true
                self.manageHideBattleCoroutine(state)
            elseif not self.autoHideBattleToggle.Value then
                local state = false
                self.manageHideBattleCoroutine(state)
            end
        end
    end)

    interactionsDropdown:OnChanged(function(value)
        if hubInit then
            local destination = interactionPositions[value]
            if destination then
                self.characterTeleport(destination)
                interactionsDropdown:SetValue(nil)
            end
        end
    end)
    battlesDropdown:OnChanged(function(value)
        if hubInit then
            local destination = battlePositions[value]
            if destination then
                self.characterTeleport(destination)
                battlesDropdown:SetValue(nil)
            end
        end
    end)
    areasDropdown:OnChanged(function(value)
        if hubInit then
            local destination = areaPositions[value]
            if destination then
                self.characterTeleport(destination)
                areasDropdown:SetValue(nil)
            end
        end
    end)
    repeatBossDropdown:OnChanged(function(value)
        if hubInit then
            local destination = repeatBossPositions[value]
            if destination then
                self.characterTeleport(destination)
                repeatBossDropdown:SetValue(nil)
            end
        end
    end)
    normalBossDropdown:OnChanged(function(value)
        if hubInit then
            local destination = normalBossPositions[value]
            if destination then
                self.characterTeleport(destination)
                normalBossDropdown:SetValue(nil)
            end
        end
    end)

    -- Configs Section
    SaveManager:SetLibrary(Fluent)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder("UK1/acb")
	SaveManager:BuildConfigSection(Tabs.Settings)

    -- Interface Section
	InterfaceManager:SetLibrary(Fluent)
	InterfaceManager:SetFolder("UK1")
	InterfaceManager:BuildInterfaceSection(Tabs.Misc)

    local path = game:GetService("ReplicatedStorage").Modules.CardInfo
    local cardInfo = require(path)

    local moduleName = {}
    local moduleTable = {}

    local cardNames = {}
    local cardTables = {}

    local selectCardDropdown, cardDataParagraph

    local cardCoroutine

    local function getCardData()
        for moduleKey, moduleValue in pairs(cardInfo) do
            table.insert(moduleName, moduleKey)
            moduleTable[moduleKey] = moduleValue
    
            for cardName, cardDetails in pairs(moduleValue) do
                table.insert(cardNames, cardName)
                cardTables[cardName] = cardDetails
            end
        end

        table.sort(cardNames)
        selectCardDropdown:SetValues(cardNames)
    end

    local function startGetCardData()
        cardCoroutine = coroutine.create(getCardData)
        coroutine.resume(cardCoroutine)
    end

    local fieldOrder = {
        "Name", "Origin", "Series", "CardPack", "Gender", "Alignment", "Chance", "Passive", "Description"
    }

    local fieldString = ""

    for _, field in ipairs(fieldOrder) do
        if field == "Chance" then
            fieldString = fieldString .. field .. ": " .. "\n"
        elseif field == "Description" then
            fieldString = fieldString .. field .. ":"
        else
            fieldString = fieldString .. field .. ": " .. "\n"
        end
    end
    
    startGetCardData()
    
    selectCardDropdown = Tabs.Cards:AddDropdown("Select Card", { 
        Title = "Card",
        Values = cardNames,
        Multi = false,
        Default = nil,
    })

    cardDataParagraph = Tabs.Cards:AddParagraph({
        Title = "Card Info" .. "\n",
        Content = fieldString
    })

    local function updateCardDataParagraph(selectedCard)
        local cardDetails = cardTables[selectedCard]
        if not cardDetails then
            cardDataParagraph:SetDesc(fieldString)
            return
        end

        local detailsString = ""

        for _, field in ipairs(fieldOrder) do
            task.wait(0.1)
            local value = cardDetails[field]
            if value then
                if field == "Chance" then
                    local formattedValue = formatNumberWithCommas(tonumber(value))
                    local valueWithoutPercent = "1 / " .. formattedValue:gsub("%%", "")
                    detailsString = detailsString .. field .. ": " .. valueWithoutPercent .. "\n"
                elseif field == "Gender" or field == "Alignment" then
                    if cardDetails["Gender"] then
                        detailsString = detailsString .. "Gender: " .. tostring(cardDetails["Gender"]) .. "\n"
                    elseif cardDetails["Alignment"] then
                        detailsString = detailsString .. "Alignment: " .. tostring(cardDetails["Alignment"]) .. "\n"
                    end
                elseif field == "Description" then
                    detailsString = detailsString .. field .. ":\n" .. tostring(value)
                else
                    detailsString = detailsString .. field .. ": " .. tostring(value) .. "\n"
                end
            end
        end

        cardDataParagraph:SetDesc(detailsString)
    end

    selectCardDropdown:OnChanged(function(value)
        if hubInit then
            updateCardDataParagraph(value)
        end
    end)

    guiInit = true
end

function AvHub:Start()
    self:Function()
    self:GUI()

    antiAfk()

    tickCount = tick()
    
    hubInit = true
    self.manageHubInfoParagraph()

    guiWindow[randomKey]:SelectTab(1)

    if _G.autoLoad then
        task.wait(1)

        guiWindow[randomKey]:SelectTab(3)
        SaveManager:LoadAutoloadConfig()
    end
end

AvHub:Start()