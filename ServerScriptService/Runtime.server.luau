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
local _CS = game:GetService("CollectionService")

-- Imports
local player_module = require(script.Parent.Modules["Players.Module"])
local aDS = require(ServerStorage:WaitForChild("aDS"):WaitForChild("Core"))

for _, module in ipairs(script.Parent.Modules:GetChildren()) do
  print(`[RUNTIME] Initialising {module.Name}`)
  require(module):Initialise()
end

-- Handle aDS Schema Initialisation
aDS.Initialise(script.Parent.Schemas)

-- Handle Players currently in-game
for _, player in PS:GetChildren() do
  player_module.HandleJoin(player)
end

-- Handle Player Joins
PS.PlayerAdded:Connect(player_module.HandleJoin)