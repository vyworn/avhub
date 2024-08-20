local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local answerButton = playerGui.NPCDialogue.DialogueFrame.ResponseFrame.DialogueOption

local function autoInfinite()
    -- Use the navigation system to select the roll button
    GuiService.SelectedObject = answerButton
    
    -- Wait a short time for the selection to take effect
    wait(0.1)
    
    -- Simulate a button click
    UserInputService:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    UserInputService:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    
    -- Wait for the roll cooldown (adjust as needed)
    task.wait(1)
    
    -- Repeat the process
    autoInfinite()
end

autoInfinite()