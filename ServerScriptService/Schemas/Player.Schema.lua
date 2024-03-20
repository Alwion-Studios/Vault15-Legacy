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

local UserInfo = aDS.Create("UserData", {
  Caps = 15,
  Bounty = 0,
  Bullet = 0,
  PlasmaCell = 0,
  FusionCell = 0,
  CodesRedeemed = {},
  LastCollect = 0,
  LastStreak = 0,
}, {})
return UserInfo