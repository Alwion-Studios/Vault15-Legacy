--!nonstrict

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
--ROBLOX Service Calls
local _MPS = game:GetService("MarketplaceService")
local _PS = game:GetService("Players")
local _RS = game:GetService("ReplicatedStorage")

--Imports
local packages = _RS.Packages
local Remotes = _RS.Remotes

-- Variables
local redemptionCountdownTime = 5

-- Items Folder
local itms = _RS.Items

local module = {
    Gamepasses = {
      [755960403] = {
        ["Reward"] = "10mmPistol"
      }
    };
    PendingRedemptions = {}
}
module.__index = module

function module.GetGamepasses(player: Player)
  if not player then return false end
  local toReturn = {}

  for id, gamepassTbl in pairs(module.Gamepasses) do
    if module.PendingRedemptions[player.UserId] and module.PendingRedemptions[player.UserId][id] and (os.time() - module.PendingRedemptions[player.UserId][id]["redemptionTime"] < redemptionCountdownTime) then
      module.PendingRedemptions[player.UserId] = nil
      continue
    end

    local s, res = pcall(_MPS.UserOwnsGamePassAsync, _MPS, player.UserId, id)
    
    if not s or not res then
      continue
    end

    toReturn[id] = gamepassTbl
  end

  return toReturn
end

function module.RedeemGamepass(player: Player, id: number)
  if not player or not id then return false end
  if module.PendingRedemptions[player.UserId] and module.PendingRedemptions[player.UserId][id] and (os.time() - module.PendingRedemptions[player.UserId][id]["redemptionTime"] < redemptionCountdownTime) then
    module.PendingRedemptions[player.UserId][id] = nil
    return false
  end

  local s, res = pcall(_MPS.UserOwnsGamePassAsync, _MPS, player.UserId, id)
    
  if not s or not res then
    return false
  end

  local item = module.Gamepasses[id]["Reward"]
  local itemToGive: Instance = itms:WaitForChild(item):Clone()
  itemToGive.Parent = player.Backpack

  module.PendingRedemptions[player.UserId] = {
    [id] = {
      ["redemptionTime"] = os.time()
    }
  }

  return true
end

function module:Initialise()
  Remotes.RedeemGamepass.OnServerInvoke = self.RedeemGamepass
  Remotes.GetUserGamepasses.OnServerInvoke = self.GetGamepasses
end

return module