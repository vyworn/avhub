if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(math.random())

local games = {
    [33660620] = 'https://raw.githubusercontent.com/vyworn/rng/main/acb.lua', -- ACB
}

if games[game.CreatorId] then
    task.wait(math.random())
    if game.CreatorId == 33660620 then
        repeat
            loadstring(game:HttpGet(games[game.CreatorId]))()
            task.wait(5)
        until _G.ahKey and _G[_G.ahKey] ~= nil
    else
        loadstring(game:HttpGet(games[game.CreatorId]))()
    end
end
