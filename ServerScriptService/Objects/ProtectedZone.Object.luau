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

--Imports
local Remotes = _RS:WaitForChild("Remotes")
local zonePlus = require(_RS.Zone)

local ProtectedZone = {}
ProtectedZone.__index = ProtectedZone

function ProtectedZone.PlayerEntered(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    print(`[ZNS] {player.Name} has entered a zone!`)
    local forceField = Instance.new("ForceField")
    forceField.Visible = true
    forceField.Parent = character
end

function ProtectedZone.PlayerLeft(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    if character:FindFirstChild("ForceField") then
        print(`[ZNS] {player.Name} has left a zone!`)
        character:FindFirstChild("ForceField"):Destroy()
    end
end

function ProtectedZone.New(instance: Instance)
    if not instance then return false end

    local self = setmetatable({}, ProtectedZone)

    self.Instance = instance
    self.Zone = zonePlus.fromRegion(self.Instance.CFrame, self.Instance.Size)
    
    -- Events
    self.Zone.playerEntered:Connect(self.PlayerEntered)
    self.Zone.playerExited:Connect(self.PlayerLeft)

    return self
end

return ProtectedZone