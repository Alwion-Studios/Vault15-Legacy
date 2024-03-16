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
local debug_module = require(script.Parent.Modules["Debug.Module"])
local player_module = require(script.Parent.Modules["Players.Module"])
local codes_module = require(script.Parent.Modules["Codes.Module"])
local ads_module = require(script.Parent.Modules["aDS.Module"])
local donations_module = require(script.Parent.Modules["Donations.Module"])
local doors_module = require(script.Parent.Modules["Doors.Module"])
local aDS = require(ServerStorage:WaitForChild("aDS"):WaitForChild("Core"))

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Initialise all Modules
debug_module:Initialise()
player_module:Initialise()
codes_module:Initialise()
ads_module:Initialise()
donations_module:Initialise()
doors_module:Initialise()

-- Handle aDS Schema Initialisation
aDS.Initialise(script.Parent.Schemas)

-- Handle Players currently in-game
for _, player in PS:GetChildren() do
  player_module.HandleJoin(player)
end

-- Handle Player Joins
PS.PlayerAdded:Connect(player_module.HandleJoin)