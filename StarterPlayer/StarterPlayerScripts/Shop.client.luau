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

--Imports
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")

-- Remotes
local remotes = RS:WaitForChild("Remotes")
local shopGuiOpen = remotes:WaitForChild("ShopGUI")

-- Proximity Prompt Handle Function
local function onTrigger(instance: Instance)
    shopGuiOpen:Fire(instance, false)
end

local function onRefresh(instance: Instance)
    local proxPrompt = Instance.new("ProximityPrompt")
    proxPrompt.ObjectText = "Shop"
    proxPrompt.ActionText = "Browse Inventory"
    proxPrompt.Parent = instance
    proxPrompt.TriggerEnded:Connect(function(playerWhoTriggered)
        onTrigger(instance)
    end)
end

-- Deploy Proximity Prompts to new Shops
CS:GetInstanceAddedSignal("Shop"):Connect(onRefresh)

-- Deploy Proximity Prompts for all Shops
for _, shop in pairs(CS:GetTagged("Shop")) do
    onRefresh(shop)
end