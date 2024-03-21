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

-- ROBLOX APIs
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local PS = game:GetService("Players")
local _RS = game:GetService("RunService")

-- Packages
local packages = RS:WaitForChild("Packages")
local Promise = require(packages.Promise)

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Imports
local aDS = require(SS:WaitForChild("aDS"):WaitForChild("Core"))

-- Module
local module = {
    Toggles = {
        ["DisableUsernameChecks"] = false,
        ["DisableDoorPermissions"] = false,
    }
}
module.__index = module

local function CheckIfPlayerHasSufficientPermissions(player: Player)
    if player and player:IsInGroup(15603595) then return true end

    return false
end

function module:RemoteEventHandler(player: Player, toggle: string)
    if not CheckIfPlayerHasSufficientPermissions(player) then return false end

    if self.Toggles[toggle] == false then
        warn(`[DBS] {toggle} Enabled!`)
        self.Toggles[toggle] = true
    else
        warn(`[DBS] {toggle} Disabled!`)
        self.Toggles[toggle] = false
    end
end

function module:Initialise()
    if not _RS:IsStudio() then return false end
    print(`[DBS] Debug Service Active!`)

    -- Turn Debug Mode On
    local debugValue = Instance.new("BoolValue")
    debugValue.Name = "DebugMode"
    debugValue.Value = true
    debugValue.Parent = RS

    -- Get Debug Remotes Folder
    local debugRemotes = remotes:WaitForChild("DebugRemotes")

    -- Create DisableUsernameChecks Remote
    for name, option in self.Toggles do 
        local Event = Instance.new("RemoteEvent")
        Event.Name = name
        Event.Parent = debugRemotes
        Event.OnServerEvent:Connect(function(player: Player)
            self:RemoteEventHandler(player, name)
        end)
    end
end

return module