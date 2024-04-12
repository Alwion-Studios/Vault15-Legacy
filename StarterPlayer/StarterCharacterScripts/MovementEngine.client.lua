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

-- Camera
local camera = workspace.CurrentCamera
local cameraX = workspace.CurrentCamera.CFrame.X
local cameraY = workspace.CurrentCamera.CFrame.Y

-- Configurable Variables
local maximumLean = 1.25
local minimumLean = -1.25
local changeLeanBy = 1.25

-- System Variables
local currentLean = 0

local movement_engine = {}

function Handle(stance, inputState:Enum.UserInputState, inputObject: InputObject)
    if stance == "sprint" and inputState == Enum.UserInputState.Begin then
        remotes.StartSprinting:FireServer()
    elseif stance == "sprint" and inputState == Enum.UserInputState.End then
        remotes.StopSprinting:FireServer()
    end
end

function movement_engine:Setup()
    CAS:BindAction("sprint", Handle, true, Enum.KeyCode.LeftShift)
end

wait(1)
movement_engine:Setup()