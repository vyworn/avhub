-- Check If Loaded
if not game:IsLoaded() then
	game.Loaded:Wait()
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
local Fluent = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/main/Fluent/Beta-FluentLibrary.lua")))()
local InterfaceManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/main/Fluent/Beta-InterfaceManager.lua")))()
local SaveManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/main/Fluent/Beta-SaveManager.lua")))()

-- Helper Functions
local function generateRandomKey(length)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	local key = ""
	for i = 1, length do
		local randIndex = math.random(1, #chars)
		key = key .. string.sub(chars, randIndex, randIndex)
		task.wait(0.1)
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
        
        task.wait(0.1)
    end
    
    if target then
        local hrp = target:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp
        end
    end
    return nil
end

local function waitForProximityPrompt(hrp, timeout)
    local startTime = tick()
    local proximityPrompt = hrp:FindFirstChild("ProximityPrompt")
    
    while not proximityPrompt and (tick() - startTime) < (timeout or 10) do
        proximityPrompt = hrp:FindFirstChild("ProximityPrompt")
        
        task.wait(0.1)
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
		task.wait(0.1)
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

local repeatableBossNames =
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

local repeatableBossPositions =
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
    "RELEASE!",
    "THANKS4PLAYING!",
    "1KLIKES!",
    "2KLIKES!",
    "SUB2VALK!",
    "4KLIKES!",
    "5KLIKES!",
    "6KLIKES!",
    "500KVISITS!",
    "SORRYFORSHUTDOWN!",
    "SUB2TOADBOI!",
    "SUB2RIJORO!",
    "SUB2WIRY!",
    "SUB2CONSUME!",
    "SUB2D1SGUISED!",
    "SUB2ItsHappyYT1!",
    "SUB2Joltzy!",
    "1MVISITS!",
    "FOLLOWEXVAR1",
    "10KLIKES!",
    "15KLIKES!",
    "20KLIKES!",
    "UPDATE2!",
    "5MVISITS!",
    "SORRYFORALLTHESHUTDOWNS!",
    "DAVIDSTHEBEST!",
    "25KLIKES!",
    "30KLIKES!",
    "10MVISITS!",
    "UPDATE3!",
    "WEFIXITZ!",
}

-- Farming Variables
local autoPotionsActive, autoSwordActive = false, false

local potionCount
local activePotions

local canGoBack, grabbedSword = false, false
local swordCooldown, swordObbyCD
local obbySwordPrompt, swordBlock, swordProximityPrompt

local dailyChest, dailyChestProximityPrompt

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
local battleLabel, closeLb
local hideBattle
local BATTLETOWERUI
local rankedRemote = remotes:FindFirstChild("RankedMenuEvents")

-- Paragraph Variables
local hubInfoParagraph, farmParagraph, battleParagraph  
local tickCount, uptimeInSeconds, hours, minutes, seconds
local uptimeText = "N/A hours N/A minutes N/A seconds"
local timeLeft
local damageDealt, previousRunDamage = 0, 0
local battleLabelText, raidText
local highestFloor, previousRunFloor, currentRunFloor = 0, 0, 0
local floorMatch
local formattedRaidDamageTracker, formattedDamageDealt, formattedThreshold
local formattedHighestFloor, formattedPreviousRunFloor, formattedCurrentRunFloor
local battleInProgress = false

-- Coroutine Variables
local potionsCoroutine, swordCoroutine
local raidCoroutine, infiniteCoroutine, rankedCoroutine, managePriorityCoroutine
local hideBattleCoroutine, closeResultCoroutine
local hubInfoParagraphCoroutine, farmParagraphCoroutine, battleParagraphCoroutine

function AvHub:Function()
    self.startFunction = function(coroutineVar, func)
        if not coroutineVar or coroutine.status(coroutineVar) == "dead" then
            coroutineVar = coroutine.create(func)
            coroutine.resume(coroutineVar)
        elseif coroutine.status(coroutineVar) == "suspended" then
            coroutine.resume(coroutineVar)
        end
        return coroutineVar
    end
    
    self.stopFunction = function(coroutineVar)
        if coroutineVar and coroutine.status(coroutineVar) ~= "dead" then
            coroutine.yield(coroutineVar)
        end
        return nil
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
			local message = "/code " .. codes[i]
			self.sendMessage(message)

			task.wait(2.5)
		end
	end

	self.reverseCodes = function()
		local reversedCodesString = ""

		for i = #codes, 1, -1 do
			reversedCodesString = reversedCodesString .. codes[i]

			if i > 1 then
				reversedCodesString = reversedCodesString .. "\n"
			end

            task.wait(0.1)
		end

		return reversedCodesString
	end

	self.reverseCodesCopy = function()
		local copyReversedCodesStr = ""
        
		for i = #codes, 1, -1 do
			copyReversedCodesStr = copyReversedCodesStr .. "/code " .. codes[i]

			if i > 1 then
				copyReversedCodesStr = copyReversedCodesStr .. "\n"
			end

            task.wait(0.1)
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

    self.getSword = function()
        obbySwordPrompt = workspace:FindFirstChild("ObbySwordPrompt")
        swordBlock = obbySwordPrompt and obbySwordPrompt:FindFirstChild("SwordBlock")
    
        if swordBlock then
            swordProximityPrompt = swordBlock:FindFirstChild("ProximityPrompt")
    
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
    
    self.autoGetSword = function()
        while isAutoSwordActive() do
            swordCooldown = stats:FindFirstChild("SwordObbyCD").Value
            swordObbyCD = swordCooldown
			if swordObbyCD == 0 then
				grabbedSword = false
                
                self.getPreviousPosition(previousPositions["Previous Position Sword"])
				task.wait(0.2)
                self.characterTeleport(areaPositions["Sword"])
                task.wait(0.5)
                self.getSword()

				if canGoBack then
                    task.wait(1)

                    if swordObbyCD > 0 then
					    self.getPreviousPosition(previousPositions["Previous Position Sword"])
                    end

                    grabbedSword = true
					canGoBack = false
				end
			elseif swordObbyCD > 0 then
				grabbedSword = true
			end

			task.wait(0.2)
		end
    end

    self.getPotions = function()
        potionCount = 0
        local players = game:GetService("Players")
        local player = players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local workspace = game:GetService("Workspace")
        local activePotions = workspace:FindFirstChild("ActivePotions")
    
        local function onPotionGrabbed()
            potionCount = potionCount + 1
        end
    
        activePotions.ChildRemoved:Connect(onPotionGrabbed)
    
        while isAutoPotionsActive() do
            for _, potion in ipairs(activePotions:GetChildren()) do
                local base = potion:FindFirstChild("Base")
                if base then
                    firetouchinterest(humanoidRootPart, base, 0)
                    task.wait(0.1)
                    firetouchinterest(humanoidRootPart, base, 1)
                end
                task.wait(0.1)
            end
            task.wait(0.25)
        end
    
        return potionCount
    end
    
    self.claimDailyChest = function()
        self.getPreviousPosition(previousPositions["Previous Position Chest"])
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
                    task.wait(0.5)
                end
            end
        end
        
        task.wait(0.75)
        
        self.characterTeleport(previousPositions["Previous Position Chest"])
    end

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

    local function foundDialogue()
		npcDialogue = playergui:FindFirstChild("NPCDialogue")
		if npcDialogue then
			return true
		else
			return false
		end
	end

    local function handleDialogue()
        npcDialogue = playergui:FindFirstChild("NPCDialogue")
        if npcDialogue then
            dialogueFrame = npcDialogue:FindFirstChild("DialogueFrame")
            responseFrame = dialogueFrame and dialogueFrame:FindFirstChild("ResponseFrame")
            dialogueOption = responseFrame and responseFrame:FindFirstChild("DialogueOption")

            if dialogueOption then
                guiservice.SelectedObject = dialogueOption
                virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.1)
                virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                task.wait(0.1)
            end
        end
        return false
    end

    local function isRaidComplete()
        rsra = replicatedstorage:WaitForChild("RaidActive")
        currentRaidValue = rsra:WaitForChild("CurrentRaid").Value
        raidDamageTracker = stats:FindFirstChild("RaidDamageTracker").Value

        if raidDamageTracker >= damageThreshold then
            currentRaidValue = ""
            return true
        end
		return raidDamageTracker >= damageThreshold
    end

    local function isRaidActive()
        currentRaidActiveValue = replicatedstorage:WaitForChild("RaidActive").Value
        currentRaidValue = replicatedstorage:WaitForChild("RaidActive"):WaitForChild("CurrentRaid").Value

        if currentRaidActiveValue then
            return true
        else
            return false
        end

        if currentRaidValue == "" then
            return false
        elseif currentRaidValue == "Adaptive Titan" then
            return true
        end        

        return false
    end

    local function canRaidCheck()
        if isAutoRaidActive() and isRaidActive() and not isRaidComplete() then
            return true
        else
            return false
        end
    end

    local function canInfiniteCheck()
        if isAutoInfiniteActive() and not canRaidCheck() then
            return true
        else    
            return false
        end
    end

    local function toggleProgressBar()
        local rb = playergui:FindFirstChild("RaidBar")
        local pb = rb:FindFirstChild("RaidBar")
        if pb then
            if canRaidCheck() then
                pb.Visible = true
            elseif not canRaidCheck() or canInfiniteCheck() then
                pb.Visible = false
            end
        end
    end

    local function isInVicinity(targetName, margin)
        local targetPosition = battlePositions[targetName]

        if not targetPosition then
            return false
        end

        local playerPosition = humanoidrootpart.Position
        local distance = (playerPosition - targetPosition).Magnitude


        return distance <= margin
    end

    local function canTeleport(targetName)
        if isInVicinity(targetName, 20) then
            return
        end

        if targetName == "Adaptive Titan" then
            if not canRaidCheck() then
                return
            end
        elseif targetName == "Heaven Infinite" then
            if not canInfiniteCheck() then
                return
            end
        end

        if not isAutoSwordActive() then
            self.characterTeleport(battlePositions[targetName])
        elseif isAutoSwordActive() then
            if hasGrabbedSword() then
                self.characterTeleport(battlePositions[targetName])
            else
                repeat
                    task.wait(0.1)
                until hasGrabbedSword()
                self.characterTeleport(battlePositions[targetName])
            end
        end
    end
    
    local function isInInfiniteBattle()
        battleLabel = playergui:WaitForChild("HideBattle"):FindFirstChild("BATTLE")

        if battleLabel then
			local startTime = tick()
			local timerThreshold = 2

			while (tick() - startTime) < timerThreshold do
				if not battleLabel.Parent then
					return false
				end

				local labelText = battleLabel.Text

				if labelText:match("CURRENTLY IN BATTLE FLOOR %d+") then
					return true
				end

				task.wait(0.1)
			end
		end

        return false
    end

    local function isInRaidBattle()
        battleLabel = playergui:WaitForChild("HideBattle"):FindFirstChild("BATTLE")

        if battleLabel then
            local labelText = battleLabel.Text
            
            if labelText == "CURRENTLY IN BATTLE" then
				return true
			end 
        end

        return false
    end

    local function giveUpInfinite(child)
        if not canRaidCheck() then 
            return 
        end
        if canRaidCheck() then
            if child.Name == "BATTLETOWERUI" then
                local giveUpButton = child.Background:FindFirstChild("GiveUp")
                if giveUpButton then
                    guiservice.SelectedObject = giveUpButton
                    virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.1)
                    virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end
            end
        end
	end

    local function cancelInfiniteBattle()
		if not canRaidCheck() then 
            return 
        end
        local towerConnection
		towerConnection = playergui.ChildAdded:Connect(function(child)
            giveUpInfinite(child)

            towerConnection:Disconnect()
        end)
	end

    self.autoRaid = function()
        while canRaidCheck() do
            if not canRaidCheck() then
                break
            end

            guiservice.SelectedObject = nil

            canTeleport("Adaptive Titan")
            toggleProgressBar()

            titanHRP = waitForTarget("Adaptive Titan", gamebosses, 10)
            if titanHRP then
                while not waitForProximityPrompt(titanHRP, 10) do
                    if not canRaidCheck() then break end
                    task.wait(0.1)
                end
            end

            repeat
                if not canRaidCheck() then break end

                if isInRaidBattle() then break end

                if foundDialogue() then
                    handleDialogue()
                else
                    break
                end

                task.wait(0.1)
            until isInRaidBattle()

            guiservice.SelectedObject = nil
            closeLb = playergui.LeaderBoard.LeaderHolder.CloseUI

            if guiservice.SelectedObject == closeLb then 
                guiservice.SelectedObject = nil
            end

            task.wait(1)
        end
    end

    self.autoInfinite = function()
        while isAutoInfiniteActive() do
            if canInfiniteCheck() then
                if not canInfiniteCheck() then
                    break
                end
                
                guiservice.SelectedObject = nil

                canTeleport("Heaven Infinite")
                toggleProgressBar()

                repeat
                    if not canInfiniteCheck() then break end
                    task.wait(0.1) 
                until not isInInfiniteBattle()
                
                davidHRP = waitForTarget("David", gamenpcs, 10)
                if davidHRP then
                    while not waitForProximityPrompt(davidHRP, 10) do
                        if not canInfiniteCheck() then break end
                        task.wait(0.1)
                    end
                end

                repeat
                    if not canInfiniteCheck() then break end
                    
                    if isInInfiniteBattle() then break end

                    if foundDialogue() then
                        handleDialogue()
                    else 
                        break 
                    end

                    task.wait(0.1)
                until isInInfiniteBattle()

                guiservice.SelectedObject = nil
                closeLb = playergui.LeaderBoard.LeaderHolder.CloseUI

                if guiservice.SelectedObject == closeLb then 
                    guiservice.SelectedObject = nil
                end

            task.wait(0.5)
            end
        end
    end

    self.autoRanked = function()
        rankedRemote = remotes:FindFirstChild("RankedMenuEvents")

        while isAutoRankedActive() do
            if not isAutoRankedActive() then
                break
            end

            BATTLETOWERUI = playergui:FindFirstChild("BATTLETOWERUI")
            if not BATTLETOWERUI then
                local success, result = pcall(function()
					return rankedRemote:FireServer("Queue")
				end)

				task.wait(0.1)
            else
                task.wait(1)
            end

            task.wait(0.1)
        end
    end

    self.autoCloseResult = function()
        while isAutoCloseResultActive() do
            inBattle = stats:FindFirstChild("InBattle")

			repeat
				task.wait(0.25)
			until not isInInfiniteBattle()

			for _, instantroll in ipairs(playergui:GetChildren()) do
				if instantroll.Name == "InstantRoll" then
					instantroll:Destroy()
				end
			end

			task.wait(0.25)
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

    -- Paragraph Functions    
    self.updateFarmParagraph = function()
        while isAutoSwordActive() or isAutoPotionsActive() do
            swordCooldown = stats.SwordObbyCD.Value
            timeLeft = swordCooldown

            farmParagraph:SetDesc("Total Potions: " .. potionCount 
            .. "\n" .. "Sword Cooldown: " .. timeLeft 
            )

            task.wait(0.2)
        end
    end

    local function checkFloors()
        battleLabel = playergui:WaitForChild("HideBattle"):FindFirstChild("BATTLE")

        if battleLabel then
            battleLabelText = battleLabel.Text
            if battleLabelText:match("CURRENTLY IN BATTLE") then
                floorMatch = string.match(battleLabelText, "CURRENTLY IN BATTLE FLOOR (%d+)")
                if floorMatch then
                    currentRunFloor = tonumber(floorMatch)
                    if currentRunFloor > previousRunFloor then
                        previousRunFloor = currentRunFloor
                    end
                end
            end
        end
    end

    self.updateBattleParagraph = function()
        while isAutoRaidActive() or isAutoInfiniteActive() do
            if previousRunDamage ~= raidDamageTracker then
                raidDamageTracker = stats.RaidDamageTracker.Value
                damageDealt = (tonumber(raidDamageTracker) - tonumber(previousRunDamage))

                if damageDealt == raidDamageTracker then
                    damageDealt = 0
                else
                    damageDealt = (tonumber(raidDamageTracker) - tonumber(previousRunDamage))
                end

                previousRunDamage = raidDamageTracker
            end

            formattedRaidDamageTracker = formatNumberWithCommas(raidDamageTracker)
            formattedThreshold = formatNumberWithCommas(damageThreshold)
            formattedDamageDealt = formatNumberWithCommas(damageDealt)

            highestFloor = stats:FindFirstChild("HeavensArenaInfiniteFloor").Value

            checkFloors()

           if isInInfiniteBattle() or isInRaidBattle() then
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
                raidText = raidText .. " (raid completed)"
            elseif isRaidActive() and not isRaidComplete() then
                raidText = raidText .. " (raid in progress)"
            elseif not isRaidActive() and isRaidComplete() then
                raidText = raidText .. " (waiting for next raid)"
            end

            formattedHighestFloor = formatNumberWithCommas(highestFloor)
            formattedPreviousRunFloor = formatNumberWithCommas(previousRunFloor)
            formattedCurrentRunFloor = formatNumberWithCommas(currentRunFloor)

            battleParagraph:SetDesc("Raid Status: " .. raidText
                .. "\nTotal Damage: " .. (formattedRaidDamageTracker .. " / " .. formattedThreshold)
                .. "\nLast Run Damage: " .. formattedDamageDealt
                .. "\nHighest Floor: " .. formattedHighestFloor
                .. "\nPrevious Run: " .. formattedPreviousRunFloor
                .. "\nCurrent Run: " .. formattedCurrentRunFloor
            )

            task.wait(0.2)
        end
    end

    self.updateHubInfoParagraph = function ()
        while hubInit do
            uptimeInSeconds = tick() - tickCount
			hours = math.floor(uptimeInSeconds / 3600)
			minutes = math.floor((uptimeInSeconds % 3600) / 60)
			seconds = uptimeInSeconds % 60
			uptimeText = string.format("%02d hours %02d minutes %02d seconds", hours, minutes, seconds)

            antiAfkStatus = antiAfk()
            local antiAFKstring
            if antiAfkStatus then
                antiAFKstring = "On"
            else
                antiAFKstring = "Off"
            end

            hubInfoParagraph:SetDesc(tostring(uptimeText)
            .. "\n" .. "Anti-AFK: " .. antiAFKstring
            )

            task.wait(0.2)
        end
    end

    self.manageFarmParagraph = function()
        if isAutoSwordActive() or isAutoPotionsActive() then
            if not farmParagraphCoroutine or coroutine.status(farmParagraphCoroutine) == "dead" then
                farmParagraphCoroutine = self.startFunction(farmParagraphCoroutine, self.updateFarmParagraph)
            end
        elseif not isAutoSwordActive() and not isAutoPotionsActive() then
            if farmParagraphCoroutine then
                farmParagraphCoroutine = self.stopFunction(farmParagraphCoroutine)
            else
                return
            end
        else
            return
        end
    end

    self.manageBattleParagraph = function()
        if isAutoRaidActive() or isAutoInfiniteActive() then
            if not battleParagraphCoroutine or coroutine.status(battleParagraphCoroutine) == "dead" then
                battleParagraphCoroutine = self.startFunction(battleParagraphCoroutine, self.updateBattleParagraph)
            end
        elseif not isAutoRaidActive() and not isAutoInfiniteActive() then
            if battleParagraphCoroutine then
                battleParagraphCoroutine = self.stopFunction(battleParagraphCoroutine)
            else
                return
            end
        else
            return
        end
    end

    self.manageHubInfoParagraph = function()
        if hubInit then
            if not hubInfoParagraphCoroutine or coroutine.status(hubInfoParagraphCoroutine) == "dead" then
                hubInfoParagraphCoroutine = self.startFunction(hubInfoParagraphCoroutine, self.updateHubInfoParagraph)
            end
        else
            if hubInfoParagraphCoroutine then
                hubInfoParagraphCoroutine = self.stopFunction(hubInfoParagraphCoroutine)
            else
                return
            end
        end
    end

    -- Coroutine Functions
    self.managePriority = function()
        local priority
        while isAutoRaidActive() or isAutoInfiniteActive() do
            if canRaidCheck() then
                priority = 1
            elseif canInfiniteCheck() then
                priority = 2
            else
                priority = nil
            end
    
            if priority == 1 then
                if not raidCoroutine or coroutine.status(raidCoroutine) == "dead" then
                    raidCoroutine = self.startFunction(raidCoroutine, self.autoRaid)
                end
    
                if infiniteCoroutine and coroutine.status(infiniteCoroutine) ~= "dead" then
                    infiniteCoroutine = self.stopFunction(infiniteCoroutine)
                end
    
                cancelInfiniteBattle()
    
            elseif priority == 2 then
                if not infiniteCoroutine or coroutine.status(infiniteCoroutine) == "dead" then
                    infiniteCoroutine = self.startFunction(infiniteCoroutine, self.autoInfinite)
                end
    
                if raidCoroutine and coroutine.status(raidCoroutine) ~= "dead" then
                    raidCoroutine = self.stopFunction(raidCoroutine)
                end
            end
    
            task.wait(1)
        end
    end
    
    self.startPotionsCoroutine = function()
        potionsCoroutine = self.startFunction(potionsCoroutine, self.getPotions)
    end
    
    self.stopPotionsCoroutine = function()
        potionsCoroutine = self.stopFunction(potionsCoroutine)
    end

    self.startSwordCoroutine = function()
        swordCoroutine = self.startFunction(swordCoroutine, self.autoGetSword)
    end
    
    self.stopSwordCoroutine = function()
        swordCoroutine = self.stopFunction(swordCoroutine)
    end

    self.startManagePriority = function()
        managePriorityCoroutine = self.startFunction(managePriorityCoroutine, self.managePriority)
    end
    
    self.stopManagePriority = function()
        managePriorityCoroutine = self.stopFunction(managePriorityCoroutine)
    end

    self.startRankedCoroutine = function()
        rankedCoroutine = self.startFunction(rankedCoroutine, self.autoRanked)
    end

    self.stopRankedCoroutine = function()
        rankedCoroutine = self.stopFunction(rankedCoroutine)
    end

    self.startCloseResultCoroutine = function()
        closeResultCoroutine = self.startFunction(closeResultCoroutine, self.autoCloseResult)
    end
    
    self.stopCloseResultCoroutine = function()
        closeResultCoroutine = self.stopFunction(closeResultCoroutine)
    end
    
    self.startHideBattleCoroutine = function()
        hideBattleCoroutine = self.startFunction(hideBattleCoroutine, self.autoHideBattle)
    end
    
    self.stopHideBattleCoroutine = function()
        hideBattleCoroutine = self.stopFunction(hideBattleCoroutine)
    end

    functionsInit = true
end

function AvHub:GUI()
    -- Window & Tabs
	guiWindow[randomKey] = Fluent:CreateWindow({
		Title = "UK1",
		SubTitle = "Anime Card Battles",
		TabWidth = 90,
		Size = UDim2.fromOffset(450, 375),
		Acrylic = true,
		Theme = "Avalanche",
		MinimizeKey = Enum.KeyCode.LeftControl
	})
	local Tabs = {
		Main = guiWindow[randomKey]:AddTab({
			Title = "Main",
			Icon = "home"
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
		Codes = guiWindow[randomKey]:AddTab({
			Title = "Codes",
			Icon = "file-text"
		}),
		Misc = guiWindow[randomKey]:AddTab({
			Title = "Misc",
			Icon = "circle-ellipsis"
		}),
        Configs = guiWindow[randomKey]:AddTab({
			Title = "Configs",
			Icon = "save"
		}),
        Interface = guiWindow[randomKey]:AddTab({
			Title = "Interface",
			Icon = "paintbrush"
		}),
	}

    -- GUI Variables
    local informationSection, latestSection, plannedSection
    local informationParagraph, latestParagraph, plannedParagraph

    local farmSection, battleSection, miscSection

    local interactionsDropdown, battlesDropdown, areasDropdown, repeatableBossDropdown, normalBossDropdown

    local codesSection, codeInfoText
    local codeInfoParagraph, codesParagraph

    -- GUI Information
	local Options = Fluent.Options
	local version = "1.4.9"
	local devs = "Av"

    -- Main Tab
    informationSection = Tabs.Main:AddSection("Information")
	informationParagraph = Tabs.Main:AddParagraph({
		Title = "\b",
		Content = "* Version" 
		.. "\n->\t" .. "v_" .. version
		.. "\n\n" .. "* Made By" 
		.. "\n->\t" .. devs

		.. "\n"
	})

	latestSection = Tabs.Main:AddSection("Latest")
	latestParagraph = Tabs.Main:AddParagraph({
		Title = "\b",
		Content = "* Changes"
        .. "\n->\t" .. "Added Card Lookup (in Misc)"
		.. "\n->\t" .. "Added Auto Raids"
		.. "\n->\t" .. "Added Avalanche Theme"
        .. "\n->\t" .. "Reworked Script"
        .. "\n->\t" .. "Reworked GUI"

        .. "\n"
	})

	plannedSection = Tabs.Main:AddSection("Planned")
	plannedParagraph = Tabs.Main:AddParagraph({
		Title = "\b",
		Content = "* Coming Soon"
		.. "\n->\t" .. "Webhooks"
		.. "\n\n" .. "* Future"
		.. "\n->\t" .. "Auto Repeatable Bosses"

        .. "\n"
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

    -- Stats Tab
    farmParagraph = Tabs.Stats:AddParagraph({
        Title = "Farm",
        Content = "Total Potions: " .. "N/A"
        .. "\n" .. "Sword Cooldown: " .. "N/A"
    })
    battleParagraph = Tabs.Stats:AddParagraph({
        Title = "Stats",
        Content = "Raid Status: " .. "N/A"
        .. "\n" .. "Total Damage: " .. "N/A" .. " / " .. "N/A"
        .. "\n" .. "Last Run Damage: " .. "N/A"
        .. "\n" .. "Highest Floor: " .. "N/A"
        .. "\n" .. "Previous Run: " .. "N/A"
        .. "\n" .. "Current Run: " .. "N/A"
    })
    hubInfoParagraph = Tabs.Stats:AddParagraph({
        Title = "Uptime",
        Content = "N/A hours N/A minutes N/A seconds"
        .. "\n" .. "Anti-AFK: " .. "N/A"
    })

    -- Teleports Tab
    interactionsDropdown = Tabs.Teleports:AddDropdown("Interactions", {
        Title = "Interactions",
        Description = "Teleports to Interactions",
        Values = interactionNames,
        Multi = false,
        Default = nil
    })

    battlesDropdown = Tabs.Teleports:AddDropdown("Battles", {
        Title = "Battles",
        Description = "Teleports to Battles",
        Values = battleNames,
        Multi = false,
        Default = nil
    })

    areasDropdown = Tabs.Teleports:AddDropdown("Areas", {
        Title = "Areas",
        Description = "Teleports to Areas",
        Values = areaNames,
        Multi = false,
        Default = nil
    })

    repeatableBossDropdown = Tabs.Teleports:AddDropdown("Repeatable Bosses", {
        Title = "Repeatable Bosses",
        Description = "Teleports to Repeatable Bosses",
        Values = repeatableBossNames,
        Multi = false,
        Default = nil
    })

    normalBossDropdown  = Tabs.Teleports:AddDropdown("Normal Bosses", {
        Title = "Normal Bosses",
        Description = "Teleports to Normal Bosses",
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
		local startIndex = codeCount

		while startIndex > 0 do
			local endIndex = math.max(startIndex - MAX_CODES_PER_PARAGRAPH + 1, 1)
			local codesChunk = ""
			for i = startIndex, endIndex, -1 do
				codesChunk = codesChunk .. codes[i]
				if i > endIndex then
					codesChunk = codesChunk .. "\n"
				end
			end
			Tabs.Codes:AddParagraph({
				Title = "Page " .. tostring(math.ceil((codeCount - startIndex + 1) / MAX_CODES_PER_PARAGRAPH) .. "\n"),
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
            Icon = "wrench"
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
        if self.autoPotionsToggle.Value then
            if not potionsCoroutine then
                self.startPotionsCoroutine()
            end

            self.manageFarmParagraph()
        elseif not self.autoPotionsToggle.Value then
            if potionsCoroutine then
                self.stopPotionsCoroutine()
            end

            self.manageFarmParagraph()
        end
    end)

    self.autoSwordToggle:OnChanged(function()
        if self.autoSwordToggle.Value then
            if not swordCoroutine then
                self.startSwordCoroutine()
            end

            self.manageFarmParagraph()
        elseif not self.autoSwordToggle.Value then
            if swordCoroutine then
                self.stopSwordCoroutine()
            end

            self.manageFarmParagraph()
        end
    end)

    self.autoRaidToggle:OnChanged(function()
        if self.autoRaidToggle.Value then
            if not managePriorityCoroutine then
                self.startManagePriority()
            end

            self.manageBattleParagraph()
        elseif not self.autoRaidToggle.Value then
            if managePriorityCoroutine then
                self.stopManagePriority()
            end

            self.manageBattleParagraph()
        end
    end)

    self.autoInfiniteToggle:OnChanged(function()
        if self.autoInfiniteToggle.Value then
            if not managePriorityCoroutine then
                self.startManagePriority()
            end

            self.manageBattleParagraph()
        elseif not self.autoInfiniteToggle.Value then
            if managePriorityCoroutine then
                self.stopManagePriority()
            end

            self.manageBattleParagraph()
        end
    end)

    self.autoRankedToggle:OnChanged(function()
        if self.autoRankedToggle.Value then
            if not rankedCoroutine then
                self.startRankedCoroutine()
            end
        elseif not self.autoRankedToggle.Value then
            if rankedCoroutine then
                self.stopRankedCoroutine()
            end
        end
    end)

    self.autoCloseResultToggle:OnChanged(function()
        if self.autoCloseResultToggle.Value then
            if not closeResultCoroutine then
                self.startCloseResultCoroutine()
            end
        elseif not self.autoCloseResultToggle.Value then
            if closeResultCoroutine then
                self.stopCloseResultCoroutine()
            end
        end
    end)

    self.autoHideBattleToggle:OnChanged(function()
        if self.autoHideBattleToggle.Value then
            if not hideBattleCoroutine then
                self.startHideBattleCoroutine()
            end
        elseif not self.autoHideBattleToggle.Value then
            if hideBattleCoroutine then
                self.stopHideBattleCoroutine()
            end
        end
    end)

    interactionsDropdown:OnChanged(function(value)
        local destination = interactionPositions[value]
        if destination then
            self.characterTeleport(destination)
            interactionsDropdown:SetValue(nil)
        end
    end)
    battlesDropdown:OnChanged(function(value)
        local destination = battlePositions[value]
        if destination then
            self.characterTeleport(destination)
            battlesDropdown:SetValue(nil)
        end
    end)
    areasDropdown:OnChanged(function(value)
        local destination = areaPositions[value]
        if destination then
            self.characterTeleport(destination)
            areasDropdown:SetValue(nil)
        end
    end)
    repeatableBossDropdown:OnChanged(function(value)
        local destination = repeatableBossPositions[value]
        if destination then
            self.characterTeleport(destination)
            repeatableBossDropdown:SetValue(nil)
        end
    end)
    normalBossDropdown:OnChanged(function(value)
        local destination = normalBossPositions[value]
        if destination then
            self.characterTeleport(destination)
            normalBossDropdown:SetValue(nil)
        end
    end)

    -- Configs Tab
    SaveManager:SetLibrary(Fluent)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder("UK1/acb")
	SaveManager:BuildConfigSection(Tabs.Configs)

    -- Interface Tab
	InterfaceManager:SetLibrary(Fluent)
	InterfaceManager:SetFolder("UK1")
	InterfaceManager:BuildInterfaceSection(Tabs.Interface)

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
        cardCoroutine = self.startFunction(cardCoroutine, getCardData)
    end
    
    startGetCardData()
    
    selectCardDropdown = Tabs.Misc:AddDropdown("Select Card", { 
        Title = "Select Card",
        Values = cardNames,
        Multi = false,
        Default = nil,
    })

    cardDataParagraph = Tabs.Misc:AddParagraph({
        Title = "Card Info",
        Content = ""
    })

    local fieldOrder = {
        "Name", "Origin", "Series", "CardPack", "Gender", "Alignment", "Chance", "Passive", "Description"
    }

    local function updateCardDataParagraph(selectedCard)
        local cardDetails = cardTables[selectedCard]
        if not cardDetails then
            cardDataParagraph:SetDesc("Select a card")
            return
        end

        local detailsString = ""

        -- Add fields in the predefined order
        for _, field in ipairs(fieldOrder) do
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
        updateCardDataParagraph(value)
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

    if _G.isAutoExec then
        guiWindow[randomKey]:SelectTab(3)
        
        local menu = playergui:WaitForChild("Menu")
        local deck = menu:WaitForChild("CardLibrary")

        firesignal(deck["MouseButton1Click"])
    end

    if _G.autoLoad then
        task.wait(1)

        guiWindow[randomKey]:SelectTab(3)
        SaveManager:LoadAutoloadConfig()
    end
end

AvHub:Start()