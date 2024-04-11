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
local shopObject = require(script.Parent.Parent.Objects["Shop.Object"])

local module = {
    zones = {}
}

function module:Initialise()
    task.spawn(function()
        for _, shop in _CS:GetTagged("Shop") do
            print(`[SHP-CLIENT] Setting up {shop.Name}`)
            shopObject.New(shop)
        end
    end)
end

return module