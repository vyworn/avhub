if not game:IsLoaded() then
	game.Loaded:Wait();
end;
local workspace = game:GetService("Workspace");
local virtualuser = game:GetService("VirtualUser");
local player = game.Players.LocalPlayer;
local function antiAfk()
	player.Idled:connect(function()
		virtualuser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
		task.wait(0.5);
		virtualuser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
	end);
	print("Anti-AFK enabled");
end;
antiAfk();
task.wait(math.random());
local games = {
	[18138547215] = "https://raw.githubusercontent.com/vyworn/rng/main/acb.lua"
};
if not games[game.PlaceId] then
	warn("Game not supported");
	games = nil;
	return;
else
	task.wait(math.random());
	if games[game.PlaceId] then
		repeat
			(loadstring(game:HttpGet(games[game.PlaceId])))();
			task.wait(math.random());
		until _G.ahKey and _G[_G.ahKey] ~= nil;
	end;
end;
