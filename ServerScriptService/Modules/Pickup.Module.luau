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

-- Object
local pickupObj = require(_SS.Objects["Pickup.Object"])

--Imports
local packages = _RS.Packages
local Remotes = _RS.Remotes

local module = {
    pickups = {}
}
module.__index = module

function module:Initialise()
    for _, instance in pairs(_CS:GetTagged("Pickup")) do 
        print(`[PS] Initialising {instance.Name}`)
        table.insert(self.pickups, pickupObj.New(instance, {["Category"]=instance.Name or nil, ["Value"]=instance:WaitForChild("Amount").Value or nil}))
    end
end

return module