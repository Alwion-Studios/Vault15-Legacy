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

-- ROBLOX APIs
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local PS = game:GetService("Players")

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Imports
local aDS = require(SS:WaitForChild("aDS"):WaitForChild("Core"))

-- Module
local module = {}

function module.AttemptDonation(player: Player, targetUsername: string, capsToDonate)
  if player.Name == targetUsername then 
    warn(`[DS] {player.Name} is attempting to donate to themself`)
    return false 
  end

  if not capsToDonate then
    warn(`[DS] capsToDonate was not defined!`)
    return false
  end

  if not targetUsername or not PS:FindFirstChild(targetUsername) then
    warn(`[DS] {targetUsername} could not be found!`)
    return false
  end

  -- Get the Player's Session
  local _, session = aDS:GetSession(player.UserId, "User"):await()

  -- Get the Target's Session
  local _, targetSession = aDS:GetSession(PS[targetUsername].UserId, "User"):await()

  if not session or not targetSession then
    warn(`[DS] Could not get a session for one (or more) of the defined players`)
    return false
  end

  -- See if the Player has the right amount of caps for this transaction
  if session["Structure"]["Caps"] < capsToDonate then
    warn(`[DS] {player.Name} does not have the right amount of caps for this transaction!`)
    return false
  end

  local status, _ = session:SetKey({}, "Caps", (session["Structure"]["Caps"]-capsToDonate)):await()
  local targetStatus, _ = targetSession:SetKey({}, "Caps", (targetSession["Structure"]["Caps"]+capsToDonate)):await()

  if status and targetStatus then 
    print(`[DS] {player.Name} gave {targetUsername} {capsToDonate} caps!`)
    return true
  else
    warn(`[DS] Something went wrong with this transaction! Attempting to Reverse`)
    session:SetKey({}, "Caps", (session["Structure"]["Caps"]+capsToDonate)):await()
    targetSession:SetKey({}, "Caps", (targetSession["Structure"]["Caps"]-capsToDonate)):await()
    return false
  end
end

function module:Initialise()
    remotes.DonationAttemptEvent.OnServerInvoke = self.AttemptDonation
end

return module