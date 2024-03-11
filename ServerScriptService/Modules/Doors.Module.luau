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

local DoorService = {
    Doors = {};
}

function DoorService.GetDoor(_, name)
    return DoorService.Doors[name]
end

function DoorService:Initialise()
    if not self.Doors or #self.Doors <= 0 then
        for _, instance in pairs(_CS:GetTagged("Door")) do
            instance = instance.Parent
            --If a door with the name already exists, do not add it to the table of doors
            if self.Doors[instance.Name] then print(`[DS] {instance.Parent.Name} already exists`) continue end

            --If a door doesn't exist
            print(`[DS] Initialising {instance.Parent.Name}`)
            self.Doors[instance.Name] = door.New(instance:GetAttribute("Category"), instance, {["isLocked"]=instance:GetAttribute("isLocked") or false})
        end
    end

    Remotes.RequestDoorDetails.OnServerInvoke = self.GetDoor
end

return DoorService