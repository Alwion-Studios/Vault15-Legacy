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

local UserInfo = aDS.Create("User", {
  Caps = 0,
  Bounty = 0,
  CodesRedeemed = {},
  LastCollect = 0,
  LastStreak = 0,
}, {})
return UserInfo