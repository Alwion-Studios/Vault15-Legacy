--[[
     █████  ██      ██     ██ ██  ██████  ███    ██ 
    ██   ██ ██      ██     ██ ██ ██    ██ ████   ██ 
    ███████ ██      ██  █  ██ ██ ██    ██ ██ ██  ██ 
    ██   ██ ██      ██ ███ ██ ██ ██    ██ ██  ██ ██ 
    ██   ██ ███████  ███ ███  ██  ██████  ██   ████ 

                    ALWION STUDIOS  
                  ALL RIGHTS RESERVED
                        ©️ 2024
]]

--ROBLOX Service Calls
local CAS = game:GetService("ContextActionService")
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- Module Imports
local remotes = RS:WaitForChild("Remotes")

-- Player
local player = PS.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hum = character:WaitForChild("Humanoid")

local movement_engine = {}

function movement_engine.Handle(stance, inputState:Enum.UserInputState, inputObject: InputObject)
    if stance == "sprint" and inputState == Enum.UserInputState.Begin then
        remotes.StartSprinting:FireServer()
    elseif stance == "sprint" and inputState == Enum.UserInputState.End then
        remotes.StopSprinting:FireServer()
    end
end

function movement_engine:Initialise()
    CAS:BindAction("sprint", self.Handle, true, Enum.KeyCode.LeftShift)
end

return movement_engine