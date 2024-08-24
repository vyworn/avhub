--[[
	Loaded Check
--]]
if not game:IsLoaded() then
	game.Loaded:Wait();
end;
local waitplayer = game.Players.LocalPlayer;
local character = waitplayer.Character or waitplayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--[[
	Roblox Services & Variables
--]]
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local virtualinput = game:GetService("VirtualInputManager")
local virtualuser = game:GetService("VirtualUser")
local guiservice = game:GetService("GuiService")
local userinputservice = game:GetService("UserInputService")
local replicatedstorage = game:GetService("ReplicatedStorage")
local remotes = replicatedstorage:WaitForChild("Remotes")
local teleportservice = game:GetService("TeleportService")
local textchatservice = game:GetService("TextChatService")
local textchannel = textchatservice.TextChannels:WaitForChild("RBXGeneral")
local httpservice = game:GetService("HttpService")
local proximitypromptservice = game:GetService("ProximityPromptService")

local player = players.LocalPlayer
local playerid = player.UserId
local character = player.Character
local username = player.Name
local displayname = player.DisplayName
local playerage = player.AccountAge

local placeid = game.PlaceId
local creatorid = game.CreatorId
local creatortype = game.CreatorType
local jobid = game.JobId
local api = "https://games.roblox.com/v1/games/"

local stats = player:WaitForChild("Stats")
local playergui = player:WaitForChild("PlayerGui")
local gamenpcs = workspace:WaitForChild("NPCs")
local gamebosses = workspace:WaitForChild("Bosses")

--[[
	Libraries
--]]
local Fluent = (loadstring(game:HttpGet("https://raw.githubusercontent.com/vyworn/avhub/main/fluent-library.lua")))();
local InterfaceManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")))();
local SaveManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")))();

--[[
	Helper Functions
--]]
local function generateRandomKey(length)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	local key = "";
	for i = 1, length do
		local randIndex = math.random(1, #chars);
		key = key .. string.sub(chars, randIndex, randIndex);
		task.wait(0.1);
	end;
	return key;
end;
local function antiAfk()
	player.Idled:Connect(function()
		virtualuser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		task.wait(0.1);
		virtualuser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end);
	print("Anti Afk enabled");
end;
local function rejoinGame()
	task.wait(1);
	teleportservice:Teleport(placeid, player);
end;
local devid = {
	["av"] = 164011583,
	["psuw"] = 417954849,
	["hari"] = 85087803,
};
local function isDeveloper(userid)
	for _, id in pairs(devid) do
		if id == userid then
			return true
		end
		task.wait(0.1);
	end
	return nil
end
local isdeveloper = isDeveloper(playerid);

--[[
	Library Variables
--]]
local informationParagraph, latestParagraph, plannedParagraph, farmStatsParagraph, battleStatsParagraph, codesParagraph
local updatingParagraph = false;
local randomKey = generateRandomKey(9);
_G[randomKey] = {};
_G.ahKey = randomKey;
local guiWindow = {};
local AvHub = _G[randomKey];

--[[
	Tables
--]]
local codes = {
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
};

--[[
	Teleport Tables
--]]
local otherLocations = {
	"Sword",
	"Old Position Sword",
	"Old Position"
};
local otherCoordinates = {
	["Sword"] = Vector3.new(-7714.85205078125, 211.64096069335938, -9588.51953125),
	["Old Position Sword"] = Vector3.new(0, 0, 0),
	["Old Position Chest"] = Vector3.new(0, 0, 0)
};
local npcTeleports = {
	"Heaven Infinite",
	"Heaven Tower",
	"Charm Merchant",
	"Potion Shop",
	"Card Fusion",
	"Daily Chest",
	"Card Index",
	"Strange Trader",
	"Card Packs",
	"Luck Fountain"
};
local mobTeleports = {
	"Earth's Mightiest",
	"Prince",
	"Knucklehead Ninja",
	"Rogue Ninja",
	"Limitless",
	"Substitute Reaper",
	"Rubber Boy",
	"Bald Hero",
	"Infernal Pugilist",
};
local bossTeleports = {
	"Galactic Tyrant",
	"Shinobi God",
	"King Of Curses",
	"Cifer",
	"Wicked Weaver",
	"Cosmic Menace",
	"Immortal Demon",
}
local areaTeleports = {
	"Heavens Arena",
	"Roll Leaderboard",
	"Card Leaderboard",
	"Spawn",
};
local raidTeleports = {
	"Adaptive Titan",
	"Raid Shop",
};
local npcTeleportsCoordinates = {
	["Heaven Infinite"] = Vector3.new(454.615417, 260.529327,5928.994629),
	["Heaven Tower"] = Vector3.new(451.595367, 247.374268, 5980.721191),
	["Charm Merchant"] = Vector3.new(-7764.36572265625, 179.71200561523438, -9194.859375),
	["Potion Shop"] = Vector3.new(-7744.11376953125, 180.14158630371094, -9369.5908203125),
	["Raid Shop"] = Vector3.new(-7930.668457, 179.798950,-9347.118164),
	["Card Fusion"] = Vector3.new(13131.391602, 84.905922, 11281.490234),
	["Card Index"] = Vector3.new(-7846.603515625, 180.50991821289062, -9371.1884765625),
	["Daily Chest"] = Vector3.new(-7785.53173828125, 180.8318634033203, -9339.9423828125),
	["Strange Trader"] = Vector3.new(523.097717, 247.374268, 6017.144531),
	["Card Packs"] = Vector3.new(-7708.05810546875, 180.46566772460938, -9310.736328125),
	["Luck Fountain"] = Vector3.new(-7811.5751953125, 180.41331481933594, -9278.078125)
};
local mobsTeleportsCoordinates = {
	["Earth's Mightiest"] = Vector3.new(10939.111328, 340.554169, -5141.633789),
	["Prince"] = Vector3.new(10987.201172, 344.049896, -5241.321777),
	["Knucklehead Ninja"] = Vector3.new(4219.748535, 31.724997, 7506.525391),
	["Rogue Ninja"] = Vector3.new(4306.954102, 31.724993, 7506.855469),
	["Limitless"] = Vector3.new(-12.537902, 272.422241, 5996.07666),
	["Substitute Reaper"] = Vector3.new(-7901.751465, 734.372009, 6714.296875),
	["Rubber Boy"] = Vector3.new(13150.526367, 84.124977, 11365.570312),
	["Bald Hero"] = Vector3.new(-11790.704102, 152.171967, -8566.525391),
	["Infernal Pugilist"] = Vector3.new(-13618.935547, 249.765564,8330.528320),
};
local bossTeleportsCoordinates = {
	["Galactic Tyrant"] = Vector3.new(10927.65918, 352.19986, -5072.885254),
	["Shinobi God"] = Vector3.new(4258.674805, 31.874994, 7444.705078),
	["King Of Curses"] = Vector3.new(-25.217384, 256.795135, 5882.467773),
	["Cifer"] = Vector3.new(-7899.03418, 734.354736, 6741.601562),
	["Wicked Weaver"] = Vector3.new(13107.546875, 84.274979, 11333.648438),
	["Cosmic Menace"] = Vector3.new(-11721.826172, 156.702225, -8551.984375),
	["Immortal Demon"] = Vector3.new(-13607.038086, 249.765564,8309.548828),
}
local areaTeleportCoordinates = {
	["Heavens Arena"] = Vector3.new(461.994751, 247.374268, 5954.683105),
	["Roll Leaderboard"] = Vector3.new(-7920.541015625, 186.38790893554688, -9144.70703125),
	["Card Leaderboard"] = Vector3.new(-7920.541015625, 186.38800048828125, -9170.8369140625),
	["Spawn"] = Vector3.new(-7921.300781, 177.836029,-9143.949219),
};
local raidTeleportCoordinates = {
	["Adaptive Titan"] = Vector3.new(-11600.375000, 250.031403,-11486.458984),
	["Raid Shop"] = Vector3.new(-7930.668457, 179.798950,-9347.118164),
};

--[[
	Variables
--]]
local swordCooldown = stats:FindFirstChild("SwordObbyCD").Value;
local inBattle = stats:FindFirstChild("InBattle").Value;
local potionCount = 0;
local autoPotionsActive = false;
local autoSwordActive = false;
local autoRaidActive = false;
local autoInfiniteActive = false;
local canGoBack = false;
local grabbedSword = false;
local tickCount, uptimeInSeconds, hours, minutes, seconds
local uptimeText = "00 hours\n00 minutes\n00 seconds";
local autoPotionsTask, autoSwordTask, updateFarmParagraphTask, updateBattleParagraphTask, 
autoRankedTask, autoRaidTask, autoInfiniteTask, 
closeResultScreenTask, autoHideBattleTask, managePriorityTask, manageUpdateBattleParagraphTask 

--[[
	Hub Functions
--]]
function AvHub:Functions()
	--[[
		Character & Position Functions
	--]]
	self.setPrimaryPart = function()
		player = game.Players.LocalPlayer;
		character = player.Character;
		if character:FindFirstChild("HumanoidRootPart") then
			character.PrimaryPart = character.HumanoidRootPart;
		end;
	end;
	self.getOldPositionSword = function()
		if character and humanoidRootPart then
			local position = humanoidRootPart.Position;
			otherCoordinates["Old Position Sword"] = Vector3.new(position.X, (position.Y + 5), position.Z);
		end;
	end;
	self.getOldPositionChest = function()
		if character and humanoidRootPart then
			local position = humanoidRootPart.Position;
			otherCoordinates["Old Position Chest"] = Vector3.new(position.X, (position.Y + 5), position.Z);
		end;
	end;
	self.characterTeleport = function(destination)
		if character and character.PrimaryPart then
			character:SetPrimaryPartCFrame(CFrame.new(destination));
			task.wait(0.1);
		else
			character = player.Character;
			self.setPrimaryPart();
		end;
	end;
	self.setPrimaryPart();
	player.CharacterAdded:Connect(function(newCharacter)
		player = game.Players.LocalPlayer;
		character = newCharacter;
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10);
		if humanoidRootPart then
			character.PrimaryPart = humanoidRootPart;
		end;
	end);

	--[[
		Code Functions
	--]]
	self.sendMessage = function(message)
		if textchannel then
			local success, result = pcall(function()
				return textchannel:SendAsync(message);
			end);
		else
			warn("TextChannel not found.");
		end;
	end;
	self.useCodes = function()
		for i = #codes, 1, -1 do
			local message = "/code " .. codes[i];
			self.sendMessage(message);
			task.wait(2);
		end;
	end;
	self.reverseCodes = function()
		local reversedCodesString = "";
		for i = #codes, 1, -1 do
			reversedCodesString = reversedCodesString .. codes[i];
			if i > 1 then
				reversedCodesString = reversedCodesString .. "\n";
			end;
		end;
		return reversedCodesString;
	end;
	self.reverseCodesCopy = function()
		local reversedCodesStringCopy = "";
		for i = #codes, 1, -1 do
			reversedCodesStringCopy = reversedCodesStringCopy .. "/code " .. codes[i];
			if i > 1 then
				reversedCodesStringCopy = reversedCodesStringCopy .. "\n";
			end;
		end;
		return reversedCodesStringCopy;
	end;

	--[[
		Auto Functions
	--]]
	self.grabPotions = function()
		local activePotions = workspace:FindFirstChild("ActivePotions")
		local potionCount = 0

		local function onPotionGrabbed(child)
			potionCount = potionCount + 1
			print("Potion grabbed, total count:", potionCount)
		end

		activePotions.ChildRemoved:Connect(onPotionGrabbed)
		
		for _, potion in ipairs(activePotions:GetChildren()) do
			local base = potion:FindFirstChild("Base")
			if base and base:FindFirstChild("TouchInterest") then
				firetouchinterest(base, humanoidRootPart, 0)
				task.wait(0.1)
				firetouchinterest(base, humanoidRootPart, 1)
			end
		end
	end	
	self.claimSword = function()
		self.getOldPositionSword();
		local swordProximityPrompt = workspace.ObbySwordPrompt.SwordBlock.ProximityPrompt
		if swordProximityPrompt then
			self.characterTeleport(otherCoordinates["Sword"]);
			task.wait(0.25);
			fireproximityprompt(swordProximityPrompt);
			task.wait(0.5);
			canGoBack = true;
			grabbedSword = true;
		end;
	end;
	local function hasGrabbedSword() 
		return grabbedSword
	end
	local function isRaidActive()
		local currentRaid = replicatedstorage.RaidActive.CurrentRaid.Value
		if currentRaid then 
			if currentRaid:match("Adaptive Titan") then
				return true
			elseif currentRaid:match("") then
				if playergui.RaidBar.RaidBar.Visible == true
					playergui.RaidBar.RaidBar.Visible = false
				end
				return false
			end
		end
	end
	local function isInInfiniteBattle()
		local battleLabel = playergui:WaitForChild("HideBattle"):FindFirstChild("BATTLE")
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
		local battleLabel = playergui:WaitForChild("HideBattle"):FindFirstChild("BATTLE")
		if battleLabel then 
			local labelText = battleLabel.Text
			if labelText:match("CURRENTLY IN BATTLE") then
				return true
			end
		end
		return false
	end
	local function isRaidComplete()
		local damageTracker = stats:FindFirstChild("RaidDamageTracker").Value
		local damageThreshold = 1000000
		return damageTracker > damageThreshold
	end
	local function isAutoInfiniteActive()
		return self.autoInfiniteToggle.Value
	end
	local function isAutoRaidActive()
		return self.autoRaidToggle.Value
	end
	local function isInInfiniteVicinity()
		local targetPosition = npcTeleportsCoordinates["Heaven Infinite"]
		local playerPosition = humanoidRootPart.Position
		local margin = 5
		local distance = (playerPosition - targetPosition).Magnitude
		if distance <= margin then
			return true
		else
			return false
		end
	end
	local function isInRaidVicinity()
		local targetPosition = raidTeleportCoordinates["Adaptive Titan"]
		local playerPosition = humanoidRootPart.Position
		local margin = 5
		local distance = (playerPosition - targetPosition).Magnitude
		if distance <= margin then
			return true
		else
			return false
		end
	end
	local function foundDialogue()
		local npcDialogue = playergui:FindFirstChild("NPCDialogue")
		if npcDialogue then
			return true
		else
			return false
		end
	end
	self.canTeleportToInfinite = function()
		if isInInfiniteVicinity() then return end
		if (not isRaidActive() or isRaidComplete()) then
			if self.autoSwordToggle.Value then
				if hasGrabbedSword() then
					self.characterTeleport(npcTeleportsCoordinates["Heaven Infinite"])
				else
					repeat 
						hasGrabbedSword()
						task.wait(0.2)
					until hasGrabbedSword()
					self.characterTeleport(npcTeleportsCoordinates["Heaven Infinite"])
				end
			else
				self.characterTeleport(npcTeleportsCoordinates["Heaven Infinite"])
			end
		end
	end
	self.canTeleportToRaid = function()
		if isInRaidVicinity() then return end
		if (isRaidActive() and not isRaidComplete()) then
			if self.autoSwordToggle.Value then
				if hasGrabbedSword() then
					self.characterTeleport(raidTeleportCoordinates["Adaptive Titan"])
				else
					repeat 
						hasGrabbedSword()
						task.wait(0.2)
					until hasGrabbedSword()
					self.characterTeleport(raidTeleportCoordinates["Adaptive Titan"])
				end
			else
				self.characterTeleport(raidTeleportCoordinates["Adaptive Titan"])
			end
		end
	end
	self.cancelInfiniteBattle = function()
		local BATTLETOWERUI = playergui:FindFirstChild("BATTLETOWERUI")
		if BATTLETOWERUI then
			local giveUpButton = BATTLETOWERUI:FindFirstChild("Background"):FindFirstChild("GiveUp")
			if giveUpButton then
				guiservice.SelectedObject = giveUpButton
				virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
			end
		end
	end
	self.autoRaid = function()
		local titanBoss, titanHRP, titanProximityPrompt 
		local npcDialogue, dialogueFrame, responseFrame, dialogueOption
		while self.autoRaidToggle.Value and isRaidActive() and not isRaidComplete() do
			if not isAutoRaidActive() then break end
			self.canTeleportToRaid()
			playergui.RaidBar.RaidBar.Visible = true
			
			repeat
				if not isAutoRaidActive() then break end
				guiservice.SelectedObject = nil
				titanBoss = gamebosses:FindFirstChild("Adaptive Titan")
				titanHRP = titanBoss:WaitForChild("HumanoidRootPart")
				task.wait(0.1)
			until titanHRP
			
			repeat 
				if not isAutoRaidActive() then break end
				titanProximityPrompt = titanHRP:WaitForChild("ProximityPrompt")
				fireproximityprompt(titanProximityPrompt)
				task.wait(0.1)
			until foundDialogue()
			
			npcDialogue = playergui:WaitForChild("NPCDialogue")
			dialogueFrame = npcDialogue:WaitForChild("DialogueFrame")
			responseFrame = dialogueFrame:WaitForChild("ResponseFrame")
			dialogueOption = responseFrame:WaitForChild("DialogueOption")
			
			repeat 
				if not isAutoRaidActive() then break end
				if isInRaidBattle() then break end
				if foundDialogue() then
					guiservice.SelectedObject = dialogueOption
				else break end
				virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				task.wait(0.1)	
			until isInRaidBattle() or not dialogueOption
			guiservice.SelectedObject = nil
			local closeLb = playergui.LeaderBoard.LeaderHolder.CloseUI
			if guiservice.SelectedObject == closeLb then 
				guiservice.SelectedObject = nil
			end
			task.wait(1)
		end
		if isRaidComplete() or not isRaidActive() then
			playergui.RaidBar.RaidBar.Visible = false
			return
		end
	end
	self.autoInfinite = function()
		local davidNPC, davidHRP, davidProximityPrompt, dialogueOption
		local npcDialogue, dialogueFrame, responseFrame
		while self.autoInfiniteToggle.Value and (not isRaidActive() or isRaidComplete()) do
			if not isAutoInfiniteActive() then break end
			self.canTeleportToInfinite()
			if isInInfiniteBattle() then
				repeat 
					if not isAutoInfiniteActive() then break end
					isInInfiniteBattle()
					task.wait(0.1) 
				until not isInInfiniteBattle()
			end

			repeat 
				if not isAutoInfiniteActive() then break end
				davidNPC = gamenpcs:FindFirstChild("David")
				davidHRP = davidNPC:WaitForChild("HumanoidRootPart")
				task.wait(0.1)
			until davidHRP

			repeat
				if not isAutoInfiniteActive() then break end
				davidProximityPrompt = davidHRP:FindFirstChild("ProximityPrompt")
				fireproximityprompt(davidProximityPrompt)
				task.wait(0.1)
			until foundDialogue()
			
			npcDialogue = playergui:WaitForChild("NPCDialogue")
			dialogueFrame = npcDialogue:WaitForChild("DialogueFrame")
			responseFrame = dialogueFrame:WaitForChild("ResponseFrame")
			dialogueOption = responseFrame:WaitForChild("DialogueOption")
			
			repeat 
				if not isAutoInfiniteActive() then break end
				if isInInfiniteBattle() then break end
				if foundDialogue() then
					guiservice.SelectedObject = dialogueOption
				else break end
				virtualinput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				virtualinput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
			until isInInfiniteBattle()
			guiservice.SelectedObject = nil
			local closeLb = playergui.LeaderBoard.LeaderHolder.CloseUI
			if guiservice.SelectedObject == closeLb then 
				guiservice.SelectedObject = nil
			end
			task.wait(1)
		end
	end
	self.managePriority = function()
		while self.autoRaidToggle.Value or self.autoInfiniteToggle.Value do
			if self.autoRaidToggle.Value and isRaidActive() and not isRaidComplete() then
				if isInInfiniteBattle() then
					repeat 
						self.cancelInfiniteBattle()
						task.wait(0.2)
					until not isInInfiniteBattle()
				end
				
				if autoInfiniteTask then
					task.cancel(autoInfiniteTask)
					autoInfiniteTask = nil
				end
				
				if not autoRaidTask then
					autoRaidTask = task.spawn(self.autoRaid)
				end
			elseif self.autoInfiniteToggle.Value and (not isRaidActive() or isRaidComplete()) then
				if autoRaidTask then
					task.cancel(autoRaidTask)
					autoRaidTask = nil
				end
				
				if not autoInfiniteTask then
					autoInfiniteTask = task.spawn(self.autoInfinite)
				end
			end
			task.wait(1)
		end
	end

	self.startManagePriority = function()
		if not managePriorityTask then
			managePriorityTask = task.spawn(self.managePriority)
		else
			return
		end
	end

	self.autoRanked = function()
		local rankedRemote = remotes:FindFirstChild("RankedMenuEvents")
		if not rankedRemote then
			rankedRemote = remotes:WaitForChild("RankedMenuEvents")
		end
		while self.autoRankedToggle.Value do
			local BATTLETOWERUI = playergui:FindFirstChild("BATTLETOWERUI")
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
	self.closeResultScreen = function()
		local davidNPC, davidHRP
		local function getDavidHRP()
			davidNPC = gamenpcs:WaitForChild("David")
			return davidNPC:FindFirstChild("HumanoidRootPart")
		end
		davidHRP = getDavidHRP()
		while self.closeResultScreenToggle.Value do
			inBattle = stats:FindFirstChild("InBattle")
			repeat
				task.wait(0.25)
			until not inBattle.Value
			for _, instantroll in ipairs(playergui:GetChildren()) do
				if instantroll.Name == "InstantRoll" then
					instantroll:Destroy()
				end
			end
			task.wait(0.25)
			if not davidHRP then
				davidHRP = getDavidHRP()
			end
		end
	end	
	self.autoHideBattle = function()
		local hideBattle = stats:FindFirstChild("HideBattle")
		while self.autoHideBattleToggle.Value do
			hideBattle.Value = true
			task.wait(1)
		end
	end;
	
	--[[
		Auto Loop Functions
	--]]
	self.autoPotionsLoop = function()
		self.grabPotions();
		while self.autoPotionsToggle.Value do
			task.wait(0.25);
		end;
	end;
	self.autoSwordLoop = function()
		while self.autoSwordToggle.Value do
			local swordObbyCD = swordCooldown;
			if swordObbyCD == 0 then
				grabbedSword = false;
				self.claimSword();
				if canGoBack then
					self.characterTeleport(otherCoordinates["Old Position Sword"]);
					canGoBack = false;
				end;
			elseif swordObbyCD > 0 and grabbedSword == false then
				grabbedSword = true;
			end;
			task.wait(0.25);
		end;
	end;

	--[[
		Other Functions
	--]]
	self.claimDailyChest = function()
		self.getOldPositionChest();
		task.wait(0.1)
		self.characterTeleport(npcTeleportsCoordinates["Daily Chest"]);
		task.wait(0.4)
		local dailyChest = workspace.DailyChestPrompt
		if dailyChest then
			local dailyChestProximityPrompt = dailyChest.ProximityPrompt
			fireproximityprompt(dailyChestProximityPrompt);
		end
		task.wait(0.5);
		self.characterTeleport(otherCoordinates["Old Position Chest"]);
	end;
	
	--[[
		Paragraph Functions
	--]]
	self.updateFarmStatsParagraph = function()
		while self.autoPotionsToggle.Value or self.autoSwordToggle.Value do
			swordCooldown = (stats:FindFirstChild("SwordObbyCD")).Value;
			local totalPotions = potionCount;
			local timeLeft = swordCooldown;

			uptimeInSeconds = tick() - tickCount
			hours = math.floor(uptimeInSeconds / 3600)
			minutes = math.floor((uptimeInSeconds % 3600) / 60)
			seconds = uptimeInSeconds % 60
			uptimeText = string.format("%02d hours\n%02d minutes\n%02d seconds", hours, minutes, seconds)

			farmStatsParagraph:SetDesc("Total Potions: " .. totalPotions 
				.. "\nSword Timer: " .. timeLeft 
				.. "\n" .. uptimeText);
			task.wait(0.2);
		end;
	end;
	self.manageUpdateFarmParagraphTask = function()
		if autoPotionsActive or autoSwordActive then
			if not updateFarmParagraphTask then
				updateFarmParagraphTask = task.spawn(self.updateFarmStatsParagraph)
			end
		else
			if updateFarmParagraphTask then
				task.cancel(updateFarmParagraphTask)
				updateFarmParagraphTask = nil
			end
		end
	end
	-- Function to format numbers with commas
	local function formatNumberWithCommas(number)
		return tostring(number):reverse():gsub("(%d%d%d)", "%1,"):gsub(",%-$", ""):reverse()
	end

	-- Updated self.updateBattleStatsParagraph function
	self.updateBattleStatsParagraph = function()
		while self.autoRankedToggle.Value or self.autoInfiniteToggle.Value do
			local hideBattle = self.autoHideBattleToggle.Value
			local closeResultScreen = self.closeResultScreenToggle.Value
			local highestFloor = stats:FindFirstChild("HeavensArenaInfiniteFloor").Value
			local raidDamageTracker = formatNumberWithCommas(stats:FindFirstChild("RaidDamageTracker").Value)
			local raidText
			
			if isRaidActive() then
				raidText = "Open"
			else
				raidText = "Closed"
			end
			if isRaidComplete() then
				raidText = raidText .. " (completed)"
			else
				raidText = raidText .. " (in progress)"
			end

			battleStatsParagraph:SetDesc("Raid: " .. raidText ..
				"\nRaid Damage Tracker: " .. raidDamageTracker ..
				"\nHighest Floor: " .. highestFloor ..
				"\nClose Result Screen: " .. tostring(closeResultScreen) ..
				"\nHide Battle: " .. tostring(hideBattle)
			)

			task.wait(0.2)
		end
	end

	self.manageUpdateBattleParagraphTask = function()
		if isAutoRaidActive() or isAutoInfiniteActive() then
			if not updateBattleParagraphTask then
				updateBattleParagraphTask = task.spawn(self.updateBattleStatsParagraph)
			else 
				return
			end
		elseif not isAutoRaidActive() and not isAutoInfiniteActive() then
			if updateBattleParagraphTask then
				task.cancel(updateBattleParagraphTask)
				updateBattleParagraphTask = nil
			end
		end
	end;
	self.startManageUpdateBattleParagraph = function()
		if not manageUpdateBattleParagraphTask then
			manageUpdateBattleParagraphTask = task.spawn(self.manageUpdateBattleParagraphTask)
		else 
			return
		end
	end
end;

function AvHub:Gui()
	--[[
		Gui Init
	--]]
	guiWindow[randomKey] = Fluent:CreateWindow({
		Title = "UK1",
		SubTitle = "Anime Card Battles",
		TabWidth = 90,
		Size = UDim2.fromOffset(500, 350),
		Acrylic = true,
		Theme = "Sakura",
		MinimizeKey = Enum.KeyCode.LeftControl
	});
	local Tabs = {
		Main = guiWindow[randomKey]:AddTab({
			Title = "Main",
			Icon = "home"
		}),
		Farm = guiWindow[randomKey]:AddTab({
			Title = "Farm",
			Icon = "repeat"
		}),
		Battle = guiWindow[randomKey]:AddTab({
			Title = "Battle",
			Icon = "sword"
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
		Interface = guiWindow[randomKey]:AddTab({
			Title = "Interface",
			Icon = "paintbrush"
		}),
		Configs = guiWindow[randomKey]:AddTab({
			Title = "Configs",
			Icon = "save"
		}),
	};
	
	local Options = Fluent.Options;
	local version = "v_1.2.9";
	local devs = "Av";

	--[[
		Main Tab
	--]]
	informationParagraph = Tabs.Main:AddParagraph({
		Title = "Information\n",
		Content = "*Version" 
		.. "\n->\t" .. version
		.. "\n" .. "*Made By" 
		.. "\n->\t" .. devs
	});
	latestParagraph = Tabs.Main:AddParagraph({
		Title = "Latest\n",
		Content = "*Added"
		-- .. "\n->\t" .. "~"
		.. "\n->\t" .. "Auto Raids"
		-- .. "\n*Removed"
		-- .. "\n->\t" .. "~"
		-- .. "\n*Changed"
		-- .. "\n->\t" .. "~"
		-- .. "\n*Notes"
		-- .. "\n->\t" .. "~"
	});
	plannedParagraph = Tabs.Main:AddParagraph({
		Title = "Planned\n",
		Content = "*Coming Soon"
		.. "\n->\t" .. "Webhooks"
		.. "\n->\t" .. "More Stats"
		.. "\n->\t" .. "More Themes"
		.. "\n->\t" .. "Auto Use Potions"
		.. "\n*Future"
		.. "\n->\t" .. "Auto Repeatable Bosses"
	});

	--[[
		Auto Tab
	--]]
	farmStatsParagraph = Tabs.Farm:AddParagraph({
		Title = "Stats\n",
		Content = "Total Potions: " .. potionCount 
		.. "\n" .. "Sword Timer: " .. swordCooldown 
		.. "\n" .. uptimeText
	});
	self.autoPotionsToggle = Tabs.Farm:AddToggle("AutoPotions", {
		Title = "Auto Potions",
		Description = "Auto Grabs Potions",
		Default = false
	});
	self.autoSwordToggle = Tabs.Farm:AddToggle("AutoSword", {
		Title = "Auto Sword",
		Description = "Auto Claims Sword",
		Default = false
	});
	self.claimChestButton = Tabs.Farm:AddButton({
		Title = "Claim Daily Chest",
		Description = "Claims Daily Chest",
		Callback = function()
			task.spawn(self.claimDailyChest);
		end
	});

	self.autoPotionsToggle:OnChanged(function()
		autoPotionsActive = self.autoPotionsToggle.Value
		if autoPotionsActive then
			if not autoPotionsTask then
				autoPotionsTask = task.spawn(self.autoPotionsLoop)
			end
		else 
			if autoPotionsTask then
				task.cancel(autoPotionsTask)
				autoPotionsTask = nil
			end
		end
		self.manageUpdateFarmParagraphTask()
	end)
	self.autoSwordToggle:OnChanged(function()
		autoSwordActive = self.autoSwordToggle.Value
		if autoSwordActive then
			if not autoSwordTask then
				autoSwordTask = task.spawn(self.autoSwordLoop)
			end
		else 
			if autoSwordTask then
				task.cancel(autoSwordTask)
				autoSwordTask = nil
			end
		end
		self.manageUpdateFarmParagraphTask()
	end)

	--[[
		Battle Tab
	--]]
	battleStatsParagraph = Tabs.Battle:AddParagraph({
		Title = "Stats\n",
		Content = "Raids: " .. "nil"
				.. "\n" .. "Raid Damage Tracker: " .. "nil"
				.. "\n" .. "Highest Floor: " .. "nil"
				.. "\n" .. "Close Result Screen: " .. "nil"
				.. "\n" .. "Hide Battle: " .. "nil"
	});
	self.autoRaidToggle = Tabs.Battle:AddToggle("AutoRaid", {
		Title = "Auto Raid",
		Description = "Auto Starts Raid",
		Default = false
	});
	self.autoInfiniteToggle = Tabs.Battle:AddToggle("AutoInfinite", {
		Title = "Auto Infinite",
		Description = "Auto Starts Infinite",
		Default = false
	});
	self.autoRankedToggle = Tabs.Battle:AddToggle("AutoRanked", {
		Title = "Auto Ranked",
		Description = "Auto Starts Ranked",
		Default = false
	});
	local section = Tabs.Battle:AddSection("Additional Options")
	self.closeResultScreenToggle = Tabs.Battle:AddToggle("CloseResultScreen", {
		Title = "Auto Close Result",
		Description = "Auto Closes Result Screen",
		Default = false
	});
	self.autoHideBattleToggle = Tabs.Battle:AddToggle("AutoHideBattle", {
		Title = "Auto Hide Battle",
		Description = "Auto Hides Battle",
		Default = false
	});

	self.autoRaidToggle:OnChanged(function()
		if self.autoRaidToggle.Value then
			self.startManagePriority()
			self.startManageUpdateBattleParagraph()
		elseif not self.autoInfiniteToggle.Value then
			if managePriorityTask and not self.autoInfiniteToggle.Value then
				task.cancel(autoRaidTask)
				task.cancel(managePriorityTask)
				autoRaidTask = nil
				managePriorityTask = nil
			else
				if managePriorityTask then
					task.cancel(managePriorityTask)
					managePriorityTask = nil
				end
			end
		end
	end)
	self.autoInfiniteToggle:OnChanged(function()
		task.wait(1)
		if self.autoInfiniteToggle.Value then
			self.startManagePriority()
			self.startManageUpdateBattleParagraph()
		elseif not self.autoRaidToggle.Value then
			if managePriorityTask and not self.autoRaidToggle.Value then
				task.cancel(autoInfiniteTask)
				task.cancel(managePriorityTask)
				autoInfiniteTask = nil
				managePriorityTask = nil
			else
				if managePriorityTask then
					task.cancel(managePriorityTask)
					managePriorityTask = nil
				end
			end
		end
	end)

	self.autoRankedToggle:OnChanged(function()
		if self.autoRankedToggle.Value then
			autoRankedTask = task.spawn(self.autoRanked);
		else
			if autoRankedTask then
				task.cancel(autoRankedTask)
				autoRankedTask = nil
			end
		end;
	end);
	self.closeResultScreenToggle:OnChanged(function()
		if self.closeResultScreenToggle.Value then
			closeResultScreenTask = task.spawn(self.closeResultScreen);
		else
			if closeResultScreenTask then
				task.cancel(closeResultScreenTask)
				closeResultScreenTask = nil
			end
		end;
	end);
	self.autoHideBattleToggle:OnChanged(function()
		if self.autoHideBattleToggle.Value then
			autoHideBattleTask = task.spawn(self.autoHideBattle);
		else
			if autoHideBattleTask then
				task.cancel(autoHideBattleTask)
				autoHideBattleTask = nil
			end
		end;
	end);

	--[[
		Teleports Tab
	--]]
	local mobsSection = Tabs.Teleports:AddSection("Mobs")
	local raidTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Raids",
		Description = "Teleports to Raids",
		Values = raidTeleports,
		Multi = false,
		Default = nil
	});
	local mobTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Repeatable Bosses",
		Description = "Teleports to Repeatable Bosses",
		Values = mobTeleports,
		Multi = false,
		Default = nil
	});
	local bossTeleportsDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Bosses",
		Description = "Teleports to Bosses",
		Values = bossTeleports,
		Multi = false,
		Default = nil
	});
	local npcsAndAreaSection = Tabs.Teleports:AddSection("NPCS & Areas")
	local npcTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Npcs",
		Description = "Teleports to Npcs",
		Values = npcTeleports,
		Multi = false,
		Default = nil
	});
	local areaTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Areas",
		Description = "Teleports to Areas",
		Values = areaTeleports,
		Multi = false,
		Default = nil
	});

	npcTeleportDropdown:OnChanged(function(Value)
		local destination = npcTeleportsCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			npcTeleportDropdown:SetValue(nil);
		end;
	end);
	mobTeleportDropdown:OnChanged(function(Value)
		local destination = mobsTeleportsCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			mobTeleportDropdown:SetValue(nil);
		end;
	end);
	bossTeleportsDropdown:OnChanged(function(Value)
		local destination = bossTeleportsCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			bossTeleportsDropdown:SetValue(nil);
		end;
	end);
	areaTeleportDropdown:OnChanged(function(Value)
		local destination = areaTeleportCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			areaTeleportDropdown:SetValue(nil);
		end;
	end);
	raidTeleportDropdown:OnChanged(function(Value)
		local destination = raidTeleportCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			raidTeleportDropdown:SetValue(nil);
		end;
	end);

	--[[
		Codes Tab
	--]]
	self.claimCodesButton = Tabs.Codes:AddButton({
		Title = "Claim All Codes",
		Description = "Claims all codes",
		Callback = function()
			self.useCodes();
		end
	});
	self.copyCodesButton = Tabs.Codes:AddButton({
		Title = "Copy All Codes",
		Description = "Copies all codes",
		Callback = function()
			setclipboard(self.reverseCodesCopy());
		end
	});
	local codesSection = Tabs.Codes:AddSection("List Of Codes")
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
				Title = "Page " .. tostring(math.ceil((codeCount - startIndex + 1) / MAX_CODES_PER_PARAGRAPH)),
				Content = codesChunk
			})
			startIndex = endIndex - 1
		end
	end
	self.displayCodesInParagraphs()

	--[[
		Misc Tab
	--]]
	self.miscRejoinGameButton = Tabs.Misc:AddButton({
		Title = "Rejoin game",
		Description = "Rejoins the game",
		Callback = function()
			rejoinGame();
		end
	});
	self.miscJoinRandomServerButton = Tabs.Misc:AddButton({
		Title = "Join Random Server",
		Description = "Joins a random public server",
		Callback = function()
			self.joinPublicServer();
		end
	});
	if isdeveloper then
		self.showDeveloper = function()
			--[[
				Developer Functions
			--]]
			self.teleportToPosition = function(x, y, z)
				if character and character.PrimaryPart then
					local pos = Vector3.new(x, y, z);
					character:SetPrimaryPartCFrame(CFrame.new(pos));
				else
					character = player.Character;
					self.setPrimaryPart();
				end;
			end;
			local loggedPositionX, loggedPositionY, loggedPositionZ;
			self.getPosition = function()
				if character and humanoidRootPart then
					local position = humanoidRootPart.Position;
					loggedPositionX, loggedPositionY, loggedPositionZ = position.X, position.Y, position.Z;
					local dataString = string.format("%.6f, %.6f,%.6f", position.X, position.Y, position.Z);
					setclipboard(dataString);
					return loggedPositionX, loggedPositionY, loggedPositionZ;
				else
					if not character then
						warn("Character not found for player:", player.Name);
					end;
					if not humanoidRootPart then
						warn("HumanoidRootPart not found for player:", player.Name);
					end;
					return nil, nil, nil;
				end;
			end;
			self.teleportToLoggedPosition = function()
				if loggedPositionX and loggedPositionY and loggedPositionZ then
					self.teleportToPosition(loggedPositionX, loggedPositionY, loggedPositionZ);
				else
					warn("Logged position is not set.");
				end;
			end;
			self.joinPublicServer = function()
				task.wait(1);
				local serversurl = api .. placeid .. "/servers/Public?sortOrder=Asc&limit=10";
				local function listServers(cursor)
					local raw = game:HttpGet(serversurl .. (cursor and "&cursor=" .. cursor or ""));
					return httpservice:JSONDecode(raw);
				end;
				local servers = listServers();
				local server = servers.data[math.random(1, #servers.data)];
				teleportservice:TeleportToPlaceInstance(placeid, server.id, player);
			end;
			
			--[[
				Developer Tab
			--]]
			Tabs.Tools = guiWindow[randomKey]:AddTab({
				Title = "Tools",
				Icon = "wrench"
			});
			self.toolsRemoteSpyButton = Tabs.Tools:AddButton({
				Title = "Remote Spy",
				Callback = function()
					local remoteSpyLink = "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua";
					(loadstring(game:HttpGet(remoteSpyLink)))();
				end
			});
			self.toolsDexButton = Tabs.Tools:AddButton({
				Title = "Dex",
				Callback = function()
					local dexLink = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua";
					(loadstring(game:HttpGet(dexLink)))();
				end
			});
			self.toolsInfiniteYieldButton = Tabs.Tools:AddButton({
				Title = "Infinite Yield",
				Callback = function()
					local infiniteYieldLink = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source";
					(loadstring(game:HttpGet(infiniteYieldLink)))();
				end
			});
			self.toolsJoinPublicServerButton = Tabs.Tools:AddButton({
				Title = "Join Public Server",
				Callback = function()
					task.spawn(self.joinPublicServer);
				end
			});
			self.toolsRejoinGameButton = Tabs.Tools:AddButton({
				Title = "Rejoin Game",
				Callback = function()
					rejoinGame();
				end
			});
			self.toolsGetPositionButton = Tabs.Tools:AddButton({
				Title = "Get Position",
				Callback = function()
					task.spawn(self.getPosition);
				end
			});
			self.toolsTeleportToPositionButton = Tabs.Tools:AddButton({
				Title = "Teleport to Logged Position",
				Callback = function()
					task.spawn(self.teleportToLoggedPosition);
				end
			});
			self.toolsCopyPlayerIdButton = Tabs.Tools:AddButton({
				Title = "Copy Player Id",
				Callback = function()
					setclipboard(tostring(playerid));
				end
			});
			self.toolsCopyPlaceIdButton = Tabs.Tools:AddButton({
				Title = "Copy Place Id",
				Callback = function()
					setclipboard(tostring(placeid));
				end
			});
			self.toolsCopyJobIdButton = Tabs.Tools:AddButton({
				Title = "Copy Job Id",
				Callback = function()
					setclipboard(tostring(jobid));
				end
			});
			self.toolsCopyCreatorIdButton = Tabs.Tools:AddButton({
				Title = "Copy Creator Id",
				Callback = function()
					setclipboard(tostring(creatorid));
				end
			});
			local infodata = "User: " .. username .. " (" .. displayname .. ")" .. "\nPlayer Id: " .. playerid .. "\nAccount Age: " .. playerage .. "\nPlace Id: " .. placeid .. "\nJob Id: " .. jobid .. "\nCreator Id: " .. creatorid .. " (" .. tostring(creatortype) .. ")"
			Tabs.Tools:AddParagraph({
				Title = "Info",
				Content = infodata
			});
		end
		self.showDeveloperButton = Tabs.Misc:AddButton({
			Title = "Add Developer Tools",
			Description = "Adds Developer Tools",
			Callback = function()
				self.showDeveloper();
			end
		});
	end

	--[[
		Interface Tab
	--]]
	InterfaceManager:SetLibrary(Fluent);
	InterfaceManager:SetFolder("UK1");
	InterfaceManager:BuildInterfaceSection(Tabs.Interface);

	--[[
		Configs Tab
	--]]
	SaveManager:SetLibrary(Fluent);
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder("UK1/acb");
	SaveManager:BuildConfigSection(Tabs.Configs);

	
end;

--[[
	Main
--]]
AvHub:Functions();
AvHub:Gui();
antiAfk();
tickCount = tick();
guiWindow[randomKey]:SelectTab(1);
if _G.isAutoExec then
	_G.isAutoExec = nil
	guiWindow[randomKey]:SelectTab(2);
	local menu = playergui:WaitForChild("Menu")
	local deck = menu:WaitForChild("CardLibrary")
	firesignal(deck["MouseButton1Click"])
end;
task.wait(2)
SaveManager:LoadAutoloadConfig()