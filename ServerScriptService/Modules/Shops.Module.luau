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
local _SS = game:GetService("ServerStorage")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("Teams")
local BS = game:GetService("BadgeService")

-- Remotes
local remotes = RS:WaitForChild("Remotes")
local notifyRemote = remotes.NotifyUser

-- Imports
local aDS_Handler = require(script.Parent["aDS.Module"])
local aDS = require(_SS:WaitForChild("aDS"):WaitForChild("Core"))

-- Item Template
local itmTemplate = require(RS.ItemData)

-- Items Folder
local itms = RS.Items

-- Module
local module = {}
module.__index = module

function module.PurchaseItem(player: Player, currentCategoryId: string, name: string, instance: Instance)
    if player:WaitForChild("SaveFile"):WaitForChild("Caps").Value < itmTemplate[name].Value then
        notifyRemote:FireClient(player, "Purchase", `You do not have the sufficient caps needed to buy {name}!`)

        warn(`[SS] {player.Name} does not have the sufficient caps needed to buy {name}!`) 
        return false 
    end
   
    local item = itmTemplate[name]
    local inventory = require(instance:WaitForChild("Inventory"))
    local _, session = aDS:GetSession(player.UserId, "Profile"):await()

    if item.Type == "Ammo" then
        local capStatus, _ = session:SetKey({}, "Caps", (session["Structure"]["Caps"] - itmTemplate[name].Value)):await()
        local status, _ = session:SetKey({}, name, (session["Structure"][name] + inventory[currentCategoryId][name]["Quantity"])):await()
        if capStatus and status then
            notifyRemote:FireClient(player, "Purchase", `You've successfully purchased {inventory[currentCategoryId][name]["Quantity"]} {name}(s)!`)
            return print(`[SS] {player.Name} has successfully purchased {inventory[currentCategoryId][name]["Quantity"]} {name}(s) for {itmTemplate[name].Value}`) 
        end
    else
        local capStatus, _ = session:SetKey({}, "Caps", (session["Structure"]["Caps"] - itmTemplate[name].Value)):await()

        local newItm = itms[name]:Clone()
        newItm.Parent = player.Backpack

        if capStatus then
            notifyRemote:FireClient(player, "Purchase", `You've successfully purchased {name}!`)
            return print(`[SS] {player.Name} has successfully purchased {name} for {itmTemplate[name].Value}`) 
        end
    end
end

function module:Initialise()
    remotes.RequestPurchase.OnServerInvoke = self.PurchaseItem
end

return module