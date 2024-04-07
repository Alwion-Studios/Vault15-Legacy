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
local _RS = game:GetService("ReplicatedStorage")
local _CS = game:GetService("CollectionService")

--Imports
local packages = _RS.Packages

-- Remotes
local remotes = _RS:WaitForChild("Remotes")
local shopGuiOpen = remotes:WaitForChild("ShopGUI")

local Shop = {}
Shop.__index = Shop

local function onTrigger(ShopInst, ShopConfig)
    shopGuiOpen:Fire(ShopInst, ShopConfig)
end

function Shop:onRefresh()
    local proxPrompt = Instance.new("ProximityPrompt")
    proxPrompt.ObjectText = "Shop"
    proxPrompt.ActionText = "Browse Inventory"
    proxPrompt.Parent = self.Instance
    proxPrompt.HoldDuration = 0.5
    proxPrompt.RequiresLineOfSight = false
    proxPrompt.TriggerEnded:Connect(function()
        onTrigger(self.Instance, self.ShopConfig)
    end)
end

function Shop.New(instance: Instance)
    if not instance then return false end

    local self = setmetatable({}, Shop)

    self.Instance = instance
    self.ShopConfig = require(self.Instance:WaitForChild("Inventory"))

    self.StoreName = self.ShopConfig.StoreName

    self:onRefresh()
    _CS:GetInstanceAddedSignal("Shop"):Connect(function()
        self:onRefresh()
    end)

    return self
end

return Shop