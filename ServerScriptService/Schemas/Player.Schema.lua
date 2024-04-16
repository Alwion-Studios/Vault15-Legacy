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
local ServerStorage = game:GetService("ServerStorage")

-- Imports
local aDS = require(ServerStorage:WaitForChild("aDS").Objects:WaitForChild("Schema.Object"))

local UserInfo = aDS.Create("Profile", {
  Caps = 15,
  Bullet = 0,
  PlasmaCell = 0,
  FusionCell = 0,
  CodesRedeemed = {},
  Inventory = {},
  LastCollect = 0,
  LastStreak = 0,
}, {})
return UserInfo