if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(math.random())

local games = {
    [18138547215] = 'https://raw.githubusercontent.com/vyworn/rng/main/acb.lua', -- ACB
}

if games[game.PlaceId] then
    task.wait(math.random())
    if games[game.PlaceId] then
        repeat
            loadstring(game:HttpGet(games[game.PlaceId]))()
            task.wait(5)
        until _G.ahKey and _G[_G.ahKey] ~= nil
    end
else
    games = nil
    return
end
