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
local zoneObj = require(_SS.Objects["ProtectedZone.Object"])

--Imports
local packages = _RS.Packages
local Remotes = _RS.Remotes

local module = {
    zones = {}
}
module.__index = module

function module:Initialise()
    for _, instance in pairs(_CS:GetTagged("ProtectedZone")) do
        print(`[ZS] Initialising {instance.Name}`)
        self.zones[instance.Name] = zoneObj.New(instance)
    end
end

return module