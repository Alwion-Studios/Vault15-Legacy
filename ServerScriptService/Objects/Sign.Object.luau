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
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")

--Imports
local Remotes = RS:WaitForChild("Remotes")

--Information
local Colours = {
    ["Unlocked"]=Color3.fromRGB(80, 165, 80),
    ["Locked"]=Color3.fromRGB(165, 99, 99)
}

local Sign = {
    IsLocked = false;
    Debounce = false;
    Status = "";
}
Sign.__index = Sign

function Sign:ChangeStatus(status) 
    self.Status = status
    self.Colour = Colours[status]
    Remotes.SignTrigger:FireAllClients(self.Instance, Colours[status])
    
    return true
end 

function Sign.New(instance, opt)
    if not instance or not opt then return false end
    if not instance:WaitForChild("Main") then return false end

    local self = setmetatable({}, Sign)

    self.Instance = instance

    return self
end

return Sign