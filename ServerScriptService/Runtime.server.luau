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

-- ROBLOX API
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Imports
local player_module = require(script.Parent.Modules["Players.Module"])
local codes_module = require(script.Parent.Modules["Codes.Module"])
local aDS = require(ServerStorage:WaitForChild("aDS"):WaitForChild("Core"))

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Initialise all Modules
player_module.Initialise()
codes_module.Initialise()

-- Handle aDS Schema Initialisation
aDS.Initialise(script.Parent.Schemas)

-- Handle Player Joins
PS.PlayerAdded:Connect(player_module.HandleJoin)