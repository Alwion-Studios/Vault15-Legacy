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
local _CS = game:GetService("CollectionService")

-- Object
local zoneObj = require(script.Parent.Parent.Objects.Zone)

local module = {
    zones = {}
}

function module:Initialise()
    task.spawn(function()
        for _, zone in _CS:GetTagged("Zone") do
            print(`[ZNS-CLIENT] Adding {zone.Name}`)
            self.zones[zone.Name] = zoneObj.New(zone)
        end
    end)
end

return module