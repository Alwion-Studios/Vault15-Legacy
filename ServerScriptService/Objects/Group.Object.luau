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
local _SSS = game:GetService("ServerScriptService")
local _SS = game:GetService("ServerStorage")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local _PS = game:GetService("Players")

--Imports
local Remotes = RS:WaitForChild("Remotes")

-- Modules
local debug_module = require(_SSS.Modules["Debug.Module"])

local Group = {}
Group.__index = Group

function Group:InitialiseCleanup()
    for playerId, player in ipairs(self.Members) do
        if _PS:GetPlayerByUserId(playerId) then continue end
        self:RemovePlayerFromGroup(player)
    end
end

function Group:RemovePlayerFromGroup(Player: Player)
    if not self.Members[Player.UserId] then return false end
    self.Members[Player.UserId] = nil
    Player:SetAttribute("Group", nil)
end

function Group:AddPlayerToGroup(Player: Player)
    if self.Members[Player.UserId] then return false end
    if Player:GetAttribute("Group") ~= nil then return false end

    self.Members[Player.UserId] = Player
    Player:SetAttribute("Group", self.GroupId)
end

function Group:RequestJoin(Player: Player)
    if not debug_module.Toggles.DisableGroupMembershipCheck and not (Player:IsInGroup(self.GroupId)) then return false end
    self:AddPlayerToGroup(Player)
end

function Group:Delete(player: Player)
    if not player then return false end
    if player.UserId ~= self.Owner.UserId then warn(`[GS] User is not the owner of this group!`) return false end

    self:RemovePlayerFromGroup(player)

    for _, member in pairs(self.Members) do 
        self:RemovePlayerFromGroup(member)
    end

    self = nil

    return true
end

function Group.New(groupOwner: Player, groupId: number)
    if not groupOwner or not groupId then return false end

    local self = setmetatable({}, Group)

    self.Owner = groupOwner
    self.GroupId = groupId
    self.Members = {}

    self:AddPlayerToGroup(groupOwner)

    return self
end

return Group