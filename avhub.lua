-- Wait until the game is fully loaded
if not game:IsLoaded() then
	game.Loaded:Wait()
end

task.wait(math.random())

local games = {
	[33660620] = 'https://raw.githubusercontent.com/vyworn/rng/main/acb.lua', -- ACB
}

if games[game.CreatorId] then
	task.wait(math.random())
	local function initializeAvhub()
		if not _G.avhub then
			loadstring(game:HttpGet(games[game.CreatorId]))()
		end
	end
	
	if game.CreatorId == 33660620 then
		repeat
			initializeAvhub()
			task.wait(10)
		until _G.avhub ~= nil
	else
		initializeAvhub()
	end
end
