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
local aDS_Handler = require(script.Parent["aDS.Module"])

-- Blacklist
local blacklist = {
  [89676078] = {
    ["Reason"] = "Blacklisted due to indecent communications. Please contact appeals if you believe this was done unfairly."
  },
  [1178239976] = {
    ["Reason"] = "Blacklisted due to indecent communications. Please contact appeals if you believe this was done unfairly."
  }
}

-- Module
local players = {}

function players.HandleJoin(player: Player)
  -- Handle the Blacklist
  if blacklist[player.UserId] then
    player:Kick(blacklist[player.UserId].Reason)
    return false
  end

  -- Configure a Datastore
  aDS_Handler.OnJoin(player)
end

return players