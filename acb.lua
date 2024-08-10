if not game:IsLoaded() then
	game.Loaded:Wait();
end;
task.wait(math.random());
local function generateRandomKey(length)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	local key = "";
	for i = 1, length do
		local randIndex = math.random(1, #chars);
		key = key .. string.sub(chars, randIndex, randIndex);
	end;
	return key;
end;
local randomKey = generateRandomKey(11);
_G[randomKey] = {};
_G.ahKey = randomKey;
local guiWindow = {};
local Hub = _G[randomKey];
local Fluent = (loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")))();
local InterfaceManager = (loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")))();
local workspace = game:GetService("Workspace");
local player = game.Players.LocalPlayer;
local placeid = game.PlaceId;
local playerid = player.UserId;
local character = player.Character;
local humanoidRootPart = character:WaitForChild("HumanoidRootPart");
local virtualinput = game:GetService("VirtualInputManager");
local virtualuser = game:GetService("VirtualUser");
local replicatedstorage = game:GetService("ReplicatedStorage");
local remotes = replicatedstorage:WaitForChild("Remotes");
local teleportservice = game:GetService("TeleportService");
local textchatserivce = game:GetService("TextChatService");
local textchannel = textchatserivce.TextChannels:WaitForChild("RBXGeneral");
local api = "https://games.roblox.com/v1/games/";
local http = game:GetService("HttpService");
local teleportservice = game:GetService("TeleportService");
local username = player.Name;
local displayname = player.DisplayName;
local playerage = player.AccountAge;
local creatorid = game.CreatorId;
local creatortype = game.CreatorType;
local jobid = game.JobId;
local proximitypromptservice = game:GetService("ProximityPromptService");
local devid = {
	164011583,
	1607510152
};
local isdeveloper = table.find(devid, playerid) ~= nil;
local statsParagraph;
local updatingParagraph = false;
local potionCount = 0;
local swordCooldown = (player.Stats:WaitForChild("SwordObbyCD")).Value;
local autoPotionsActive = false;
local autoSwordActive = false;
local codes = {
	"RELEASE!",
	"THANKS4PLAYING!",
	"1KLIKES!",
	"2KLIKES!",
	"4KLIKES!",
	"5KLIKES!",
	"6KLIKES!",
	"500KVISITS!",
	"1MVISITS!"
};
local otherLocations = {
	"Sword",
	"Old Position"
};
local otherCoordinates = {
	Sword = Vector3.new(-5922.687012, 102.94072, -8286.416016)
};
local npcTeleports = {
	"Charm Merchant",
	"Potion Shop",
	"Card Fusion",
	"Card Packs",
	"Strange Trader",
	"Heaven's Arena Tower",
	"Heaven's Arena Infinite"
};
local mobTeleports = {
	"Earth's Mightiest",
	"Prince",
	"Knucklehead Ninja",
	"Rogue Ninja",
	"Limitless",
	"Substitute Reaper",
	"Rubber Boy",
	"Bald Hero"
};
local areaTeleports = {
	"Heavens Arena",
	"Sword",
	"Portal 5",
	"Portal 4",
	"Portal 3",
	"Portal 2",
	"Portal 1"
};
local npcTeleportsCoordinates = {
	["Charm Merchant"] = Vector3.new(-5902.000977, 158.624985, -8741.383789),
	["Potion Shop"] = Vector3.new(-45.672028, 256.645111, 5976.190918),
	["Card Fusion"] = Vector3.new(13131.391602, 84.905922, 11281.490234),
	["Card Packs"] = Vector3.new(-6024.296387, 152.574966, -8582.142578),
	["Strange Trader"] = Vector3.new(523.097717, 247.374268, 6017.144531),
	["Heaven's Arena Tower"] = Vector3.new(451.595367, 247.374268, 5980.721191),
	["Heaven's Arena Infinite"] = Vector3.new(459.257782, 247.425293, 5931.338379)
};
local mobsTeleportsCoordinates = {
	["Earth's Mightiest"] = Vector3.new(10939.111328, 340.554169, -5141.633789),
	Prince = Vector3.new(10987.201172, 344.049896, -5241.321777),
	["Knucklehead Ninja"] = Vector3.new(4219.748535, 31.724997, 7506.525391),
	["Rogue Ninja"] = Vector3.new(4306.954102, 31.724993, 7506.855469),
	Limitless = Vector3.new(-12.537902, 272.422241, 5996.07666),
	["Substitute Reaper"] = Vector3.new(-7901.751465, 734.372009, 6714.296875),
	["Rubber Boy"] = Vector3.new(13150.526367, 84.124977, 11365.570312),
	["Bald Hero"] = Vector3.new(-11790.704102, 152.171967, -8566.525391)
};
local areaTeleportCoordinates = {
	["Heavens Arena"] = Vector3.new(461.994751, 247.374268, 5954.683105),
	Sword = Vector3.new(-5922.687012, 102.94072, -8286.416016),
	["Portal 5"] = Vector3.new(13116.553711, 84.124977, 11327.412109),
	["Portal 4"] = Vector3.new(-7902.407227, 734.204712, 6737.871582),
	["Portal 3"] = Vector3.new(-24.246572, 256.645111, 5886.447754),
	["Portal 2"] = Vector3.new(4260.783203, 31.724993, 7455.575684),
	["Portal 1"] = Vector3.new(10932.37793, 351.924957, -5078.314941)
};
function Hub:Functions()
	player.Idled:connect(function()
		virtualuser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
		task.wait(0.5);
		virtualuser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
		task.wait(0.5);
		virtualuser:CaptureController();
		task.wait(0.5);
		virtualuser:ClickButton2(Vector2.new());
	end);
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
			task.wait(1);
		end;
	end;
	self.grabPotions = function()
		local activePotions = workspace:WaitForChild("ActivePotions");
		for _, potion in ipairs(activePotions:GetChildren()) do
			local base = potion:FindFirstChild("Base");
			if base and base:FindFirstChild("TouchInterest") then
				firetouchinterest(base, humanoidRootPart, 1);
				task.wait(0.1);
				firetouchinterest(base, humanoidRootPart, 0);
				potionCount = potionCount + 1;
			end;
		end;
	end;
	self.rollEvent = function()
		local success, response = pcall(function()
			(remotes:WaitForChild("RollEvent")):FireServer();
		end);
	end;
	self.characterTeleport = function(destination)
		if character then
			character:SetPrimaryPartCFrame(CFrame.new(destination));
			task.wait(0.1);
		end;
	end;
	self.getOldPosition = function()
		if character and humanoidRootPart then
			local position = humanoidRootPart.Position;
			otherCoordinates["Old Position"] = Vector3.new(position.X, position.Y, position.Z);
		end;
	end;
	self.grabSword = function()
		local swordBlock = (workspace:WaitForChild("ObbySwordPrompt")):WaitForChild("SwordBlock");
		local swordProximityPrompt = swordBlock:WaitForChild("ProximityPrompt");
		if swordProximityPrompt then
			self.getOldPosition();
			task.wait(1);
			self.characterTeleport(otherCoordinates.Sword);
			swordProximityPrompt:InputHoldBegin();
			task.wait(0.1);
			swordProximityPrompt:InputHoldEnd();
			task.wait(0.1);
			swordProximityPrompt:InputHoldBegin();
			task.wait(0.1);
			swordProximityPrompt:InputHoldEnd();
			task.wait(2);
			self.characterTeleport(otherCoordinates["Old Position"]);
		end;
	end;
	self.autoPotionsLoop = function()
		while self.autoPotionsToggle.Value do
			self.grabPotions();
			task.wait(0.5);
		end;
	end;
	self.autoRollLoop = function()
		while self.autoRollToggle.Value do
			self.rollEvent();
			task.wait(0.01);
		end;
	end;
	self.autoSwordLoop = function()
		while self.autoSwordToggle.Value do
			local swordObbyCD = swordCooldown;
			if swordObbyCD == 0 then
				self.grabSword();
			end;
			task.wait(0.5);
		end;
	end;
	self.updateParagraph = function()
		while self.autoPotionsToggle.Value or self.autoSwordToggle.Value do
			swordCooldown = (player.Stats:WaitForChild("SwordObbyCD")).Value;
			local totalPotions = potionCount;
			local timeLeft = swordCooldown;
			local potionText = "Total Potions: " .. totalPotions;
			local swordText = "Sword Timer: " .. timeLeft;
			statsParagraph:SetDesc(potionText .. "\n" .. swordText);
			task.wait(0.2);
		end;
	end;
	self.updateParagraphStatus = function()
		if autoPotionsActive or autoSwordActive then
			if not updatingParagraph then
				updatingParagraph = true;
				task.spawn(self.updateParagraph);
			end;
		elseif updatingParagraph then
			updatingParagraph = false;
		end;
	end;
	self.rejoinGame = function()
		task.wait(1);
		teleportservice:Teleport(placeid, player);
	end;
end;
function Hub:Gui()
	guiWindow[randomKey] = Fluent:CreateWindow({
		Title = "UK1 Hub",
		SubTitle = "by Av",
		TabWidth = 100,
		Size = UDim2.fromOffset(500, 300),
		Acrylic = true,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
	});
	local Tabs = {
		Auto = guiWindow[randomKey]:AddTab({
			Title = "Auto",
			Icon = "repeat"
		}),
		Teleports = guiWindow[randomKey]:AddTab({
			Title = "Teleports",
			Icon = "navigation"
		}),
		Misc = guiWindow[randomKey]:AddTab({
			Title = "Misc",
			Icon = "circle-ellipsis"
		}),
		Settings = guiWindow[randomKey]:AddTab({
			Title = "Settings",
			Icon = "settings"
		})
	};
	local Options = Fluent.Options;
	self.autoPotionsToggle = Tabs.Auto:AddToggle("AutoPotions", {
		Title = "Auto Potions",
		Default = false
	});
	self.autoRollToggle = Tabs.Auto:AddToggle("AutoRoll", {
		Title = "Auto Roll",
		Default = false
	});
	self.autoSwordToggle = Tabs.Auto:AddToggle("AutoSword", {
		Title = "Auto Sword",
		Default = false
	});
	statsParagraph = Tabs.Auto:AddParagraph({
		Title = "Stats",
		Content = "Total Potions: " .. potionCount .. "\nSword Timer: " .. swordCooldown
	});
	self.autoPotionsToggle:OnChanged(function()
		autoPotionsActive = self.autoPotionsToggle.Value;
		if autoPotionsActive then
			task.spawn(self.autoPotionsLoop);
		end;
		self.updateParagraphStatus();
	end);
	self.autoRollToggle:OnChanged(function()
		if self.autoRollToggle.Value then
			task.spawn(self.autoRollLoop);
		end;
	end);
	self.autoSwordToggle:OnChanged(function()
		autoSwordActive = self.autoSwordToggle.Value;
		if autoSwordActive then
			task.spawn(self.autoSwordLoop);
		end;
		self.updateParagraphStatus();
	end);
	local npcTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Npc Teleports",
		Values = npcTeleports,
		Multi = false,
		Default = nil
	});
	local mobTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Mob Teleports",
		Values = mobTeleports,
		Multi = false,
		Default = nil
	});
	local areaTeleportDropdown = Tabs.Teleports:AddDropdown("Dropdown", {
		Title = "Area Teleports",
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
	areaTeleportDropdown:OnChanged(function(Value)
		local destination = areaTeleportCoordinates[Value];
		if destination then
			self.characterTeleport(destination);
			areaTeleportDropdown:SetValue(nil);
		end;
	end);
	Tabs.Misc:AddButton({
		Title = "Rejoin game",
		Callback = function()
			task.spawn(self.rejoinGame);
		end
	});
	Tabs.Misc:AddButton({
		Title = "Claim All Codes",
		Callback = function()
			task.spawn(self.useCodes);
		end
	});
	local reversedCodesString = "";
	for i = #codes, 1, -1 do
		reversedCodesString = reversedCodesString .. codes[i] .. "\n";
	end;
	codesParagraph = Tabs.Misc:AddParagraph({
		Title = "Codes",
		Content = reversedCodesString
	});
	InterfaceManager:SetLibrary(Fluent);
	InterfaceManager:SetFolder("UK1");
	InterfaceManager:BuildInterfaceSection(Tabs.Settings);
	if isdeveloper then
		Tabs.Tools = guiWindow[randomKey]:AddTab({
			Title = "Tools",
			Icon = "wrench"
		});
		Tabs.Tools:AddButton({
			Title = "Remote Spy",
			Callback = function()
				(loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua")))();
			end
		});
		Tabs.Tools:AddButton({
			Title = "Dex",
			Callback = function()
				(loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")))();
			end
		});
		Tabs.Tools:AddButton({
			Title = "Infinite Yield",
			Callback = function()
				(loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")))();
			end
		});
		Tabs.Tools:AddButton({
			Title = "Join Public Server",
			Callback = function()
				task.spawn(self.joinPublicServer);
			end
		});
		Tabs.Tools:AddButton({
			Title = "Rejoin Game",
			Callback = function()
				task.spawn(self.rejoinGame);
			end
		});
		Tabs.Tools:AddButton({
			Title = "Get Position",
			Callback = function()
				task.spawn(self.getPosition);
			end
		});
		Tabs.Tools:AddButton({
			Title = "Teleport to Logged Position",
			Callback = function()
				task.spawn(self.teleportToLoggedPosition);
			end
		});
		Tabs.Tools:AddButton({
			Title = "Copy Player Id",
			Callback = function()
				setclipboard(tostring(playerid));
			end
		});
		Tabs.Tools:AddButton({
			Title = "Copy Place Id",
			Callback = function()
				setclipboard(tostring(placeid));
			end
		});
		Tabs.Tools:AddButton({
			Title = "Copy Job Id",
			Callback = function()
				setclipboard(tostring(jobid));
			end
		});
		Tabs.Tools:AddButton({
			Title = "Copy Creator Id",
			Callback = function()
				setclipboard(tostring(creatorid));
			end
		});
		Tabs.Tools:AddParagraph({
			Title = "Info",
			Content = "User: " .. username .. " (" .. displayname .. ")" .. "\nPlayer Id: " .. playerid .. "\nAccount Age: " .. playerage .. "\nPlace Id: " .. placeid .. "\nJob Id: " .. jobid .. "\nCreator Id: " .. creatorid .. " (" .. tostring(creatortype) .. ")"
		});
	end;
	guiWindow[randomKey]:SelectTab(1);
end;
function Hub:Tools()
	self.teleportToPosition = function(x, y, z)
		if character then
			local pos = Vector3.new(x, y, z);
			character:SetPrimaryPartCFrame(CFrame.new(pos));
		else
			warn("Character not found.");
		end;
	end;
	self.joinPublicServer = function()
		local serversurl = api .. placeid .. "/servers/Public?sortOrder=Asc&limit=10";
		local function listServers(cursor)
			local raw = game:HttpGet(serversurl .. (cursor and "&cursor=" .. cursor or ""));
			return http:JSONDecode(raw);
		end;
		local servers = listServers();
		local server = servers.data[math.random(1, #servers.data)];
		teleportService:TeleportToPlaceInstance(placeid, server.id, player);
	end;
	self.rejoinGame = function()
		teleportService:Teleport(placeid, player);
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
end;
if isdeveloper then
	Hub:Tools();
end;
Hub:Functions();
Hub:Gui();
