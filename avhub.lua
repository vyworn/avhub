if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(math.random())

local games = {
    [18138547215] = 'https://raw.githubusercontent.com/vyworn/rng/main/acb.lua', -- ACB
}

if not games[game.PlaceId] then
    warn('Game not supported')
    games = nil
    return
else
    task.wait(math.random())
    if games[game.PlaceId] then
        repeat
            loadstring(game:HttpGet(games[game.PlaceId]))()
            task.wait(math.random())
        until _G.ahKey and _G[_G.ahKey] ~= nil
    end
end