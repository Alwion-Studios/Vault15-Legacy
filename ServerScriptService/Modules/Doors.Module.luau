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

--Imports
local packages = _RS.Packages
local Remotes = _RS.Remotes

--Door Object
local door = require(_SS:WaitForChild("Objects"):WaitForChild("Door.Object"))

local module = {
    Doors = {};
}
module.__index = module

function module.GetDoor(_, name)
    return module.Doors[name]
end

function module:Initialise()
    if self.Doors and #self.Doors > 0 then return false end

    for _, instance in pairs(_CS:GetTagged("Door")) do
        --If a door with the name already exists, do not add it to the table of doors
        if self.Doors[instance.Name] then print(`[DS] {instance.Name} already exists`) continue end

        --If a door doesn't exist
        print(`[DS] Initialising {instance.Name}`)
        self.Doors[instance.Name] = door.New(instance:GetAttribute("Category"), instance, {["isLocked"]=instance:GetAttribute("isLocked") or false, ["groupId"]=instance:GetAttribute("groupId") or false, ["rankId"]=instance:GetAttribute("rankId") or false})
    end

    Remotes.RequestDoorDetails.OnServerInvoke = self.GetDoor
end

return module