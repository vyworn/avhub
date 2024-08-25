self.showDeveloper = function()
    -- Developer Tools
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