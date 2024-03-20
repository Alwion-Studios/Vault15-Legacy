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
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("Teams")

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Imports
local aDS_Handler = require(script.Parent["aDS.Module"])

-- Blacklist
local blacklist = {
  [89676078] = {
    ["Reason"] = "Blacklisted due to our policy on indecent communications. Please contact appeals if you believe this was done unfairly."
  },
  [1178239976] = {
    ["Reason"] = "Blacklisted due to our policy on indecent communications. Please contact appeals if you believe this was done unfairly."
  }
}

-- Module
local players = {}
players.__index = players

function players.HandleJoin(player: Player)
  -- Handle the Blacklist
  if blacklist[player.UserId] then
    player:Kick(blacklist[player.UserId].Reason)
    return false
  end

  -- Configure a Datastore
  aDS_Handler:OnJoin(player)
end

function players:Initialise()
  -- Handle Remotes
  remotes.TeamSwitch.OnServerInvoke = function(player, teamName)
    if not TS[teamName] then return false end
    local team = TS[teamName]
    
    if team:GetAttribute("GroupId") and not player:IsInGroup(team:GetAttribute("GroupId")) then
      warn(`{player.Name} is not in group {team:GetAttribute("GroupId")}!`)
      return false
    end
    
    if team:GetAttribute("GroupId") and team:GetAttribute("RankId") and (player:GetRankInGroup(team:GetAttribute("GroupId")) < team:GetAttribute("RankId"))  then
      warn(`{player.Name} does not have the required rank to join this team!`)
      return false
    end

    print(`{player.Name} has joined {teamName}`)
    player.Team = team
    player:LoadCharacter()
    
    return true
  end
end

return players