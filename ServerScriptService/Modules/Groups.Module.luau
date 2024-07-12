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
local _SS = game:GetService("ServerScriptService")
local _CS = game:GetService("CollectionService")
local _RS = game:GetService("ReplicatedStorage")
local _GS = game:GetService("GroupService")

-- Remotes
local remotes = _RS.Remotes

-- Groups Object
local groupObj = require(_SS.Objects["Group.Object"])
local debug_module = require(_SS.Modules["Debug.Module"])

local module = {
    Groups = {};
}
module.__index = module

function module.CreateGroup(groupOwner: Player, groupId: number)
  if not groupOwner or not groupId then warn(`[GS] Group Owner or ID not provided!`) return false end
  if module.Groups[groupId] then warn(`[GS] Group Already Exists!`) return false end
  if (not debug_module.Toggles.DisableGroupRankCheck and not debug_module.Toggles.DisableGroupMembershipCheck) and not ((groupOwner:IsInGroup(groupId)) and (groupOwner:GetRankInGroup(groupId) < 250)) then warn(`[GS] Player is not in group or does not have the sufficient rank needed to create this group!`) return false end

  module.Groups[groupId] = groupObj.New(groupOwner, groupId)
  print(`[GS] Group {groupId} Created`)

  remotes.RefreshClientGroups:FireAllClients(module.Groups)
end

function module.DeleteGroup(player: Player, groupId: number)
  if not player or not groupId then warn(`[GS] Player or ID not provided!`) return false end
  if not module.Groups[groupId] then warn(`[GS] Group Does Not Exist!`) return false end
  local res = module.Groups[groupId]:Delete(player)

  if res then
    module.Groups[groupId] = nil
    remotes.RefreshClientGroups:FireAllClients(module.Groups)
  end

  return res
end

function module.RequestToJoinGroup(player: Player, groupId: number)
  if not player or not groupId then warn(`[GS] Player or ID not provided!`) return false end
  if not module.Groups[groupId] then warn(`[GS] Group Does Not Exist!`) return false end
  return module.Groups[groupId]:AddPlayerToGroup(player)
end

function module.RequestToLeaveGroup(player: Player, groupId: number)
  if not player or not groupId then warn(`[GS] Player or ID not provided!`) return false end
  if not module.Groups[groupId] then warn(`[GS] Group Does Not Exist!`) return false end
  return module.Groups[groupId]:RemovePlayerFromGroup(player)
end

function module:Initialise()
  remotes.RequestGroupCreation.OnServerInvoke = self.CreateGroup
  remotes.RequestGroupDeletion.OnServerInvoke = self.DeleteGroup
  remotes.RequestToJoinGroup.OnServerInvoke = self.RequestToJoinGroup
  remotes.RequestToLeaveGroup.OnServerInvoke = self.RequestToLeaveGroup
end

return module