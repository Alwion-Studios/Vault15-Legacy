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
local BS = game:GetService("BadgeService")

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Imports
local aDS_Handler = require(script.Parent["aDS.Module"])
local debug_module = require(script.Parent["Debug.Module"])

-- Blacklist
local blacklist = {
  [89676078] = {
      ["Reason"] = "Blacklisted. Contact appeals."
  },
  [1178239976] = {
      ["Reason"] = "Blacklisted. Contact appeals."
  },
  [14413902] = {
      ["Reason"] = "Blacklisted. Contact appeals."
  }
}

-- Module
local players = {}
players.__index = players

function players.HandleJoin(player: Player)
  -- Award BETA Badge
  pcall(function()
    return BS:AwardBadge(player.UserId, 1701232606423157)
  end)

  -- Handle the Blacklist
  if blacklist[player.UserId] then
    player:Kick(blacklist[player.UserId].Reason)
    return false
  end

  -- Configure a Datastore
  aDS_Handler:OnJoin(player)

  -- Disable CanCollide, CanQuery and CanTouch for all accessories
  local character = player.Character or player.CharacterAdded:Wait()
  
  for _, part: Accessory in pairs(character:GetChildren()) do 
    if not part:IsA("Accessory") then continue end
    part = part:WaitForChild("Handle")
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
  end
end

function players:Initialise()
  -- Handle Remotes
  remotes.TeamSwitch.OnServerInvoke = function(player, teamName)
    if not TS[teamName] then return false end
    local team = TS[teamName]
    
    if not debug_module.Toggles.DisableTeamGroupCheck and team:GetAttribute("GroupId") and not player:IsInGroup(team:GetAttribute("GroupId")) then
      warn(`{player.Name} is not in group {team:GetAttribute("GroupId")}!`)
      return false
    end
    
    if not debug_module.Toggles.DisableTeamRankCheck and team:GetAttribute("GroupId") and team:GetAttribute("RankId") and (player:GetRankInGroup(team:GetAttribute("GroupId")) < team:GetAttribute("RankId"))  then
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