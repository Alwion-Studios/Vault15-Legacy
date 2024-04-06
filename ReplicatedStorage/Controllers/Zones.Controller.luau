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
    for _, zone in ipairs(_CS:GetTagged("Zone")) do
        self.zones[zone.Name] = zoneObj.New(zone)
    end
end

return module