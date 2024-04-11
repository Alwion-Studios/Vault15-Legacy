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
  [89676078] = true,
  [1178239976] = true,
  [14413902] = true,
  [2785616570] = true,
  [3340003283] = true,
  [2681446762] = true,
  [4115099163] = true,
  [5724328655] = true
}

-- Module
local players = {}
players.__index = players

function players.HandleJoin(player: Player)
  -- Make sure they're in the alwion studios group

  --[[if player:GetRankInGroup(15603595) < 2 or false then
    player:Kick("DEV-LOCK: You're not a developer or QA!")
  end]]

  -- Award BETA Badge
  pcall(function()
    return BS:AwardBadge(player.UserId, 1701232606423157)
  end)

  -- Handle the Blacklist
  if blacklist[player.UserId] then
    player:Kick("Blacklisted. Contact appeals.")
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

    for _, part: Accessory in pairs(player.Character:GetChildren()) do
      if not part:IsA("Accessory") then continue end
      part = part:WaitForChild("Handle")
      part.CanCollide = false
      part.CanTouch = false
      part.CanQuery = false
    end
    
    return true
  end
end

return players