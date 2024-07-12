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
local _SSS = game:GetService("ServerStorage")

--Imports
local packages = _RS.Packages
local Remotes = _RS.Remotes

-- Imports
local aDS = require(_SSS:WaitForChild("aDS"):WaitForChild("Core"))

local module = {}
module.__index = module

function module.ValidateLocation(player: Player, victim: Player, victimPart: Part, gunConfig: table)
    local playerChar = player.Character or player.CharacterAdded:Wait()
    local victimChar = victim
    local range = gunConfig.Range or 30

    if (playerChar.HumanoidRootPart.Position - victimChar.HumanoidRootPart.Position).magnitude > range then return false end
    return true
end

function module.ProcessHit(player: Player, victim: Model, victimPart: Part, position: Vector3, gun: Instance)
    if not player or not (player.Character) or not gun or gun.Parent ~= player.Character or not gun:FindFirstChild("GunSettings") then print(false) return false end

    Remotes.ShotFiredEvent:FireAllClients(player, gun, require(gun.GunSettings).Barrel.Position, position)

    print(victim)
    if not victim or not victimPart or not victim:FindFirstChild("HumanoidRootPart") then return false end
    if not module.ValidateLocation(player, victim, victimPart, require(gun.GunSettings)) then return false end
    
    local hum: Humanoid = victim:WaitForChild("Humanoid")
    local Settings = require(gun.GunSettings)

    if (victimPart.Name == "LeftUpperArm" or victimPart.Name == "LeftLowerArm" or victimPart.Name == "LeftHand") or (victimPart.Name == "RightUpperArm" or victimPart.Name == "RightLowerArm" or victimPart.Name == "RightHand") or (victimPart.Name == "RightArm" or victimPart.Name == "LeftArm") then 
        hum:TakeDamage(Settings.BulletDamage * Settings["Modifiers"]["Arms"])
    elseif (victimPart.Name == "LeftUpperLeg" or victimPart.Name == "LeftLowerLeg" or victimPart.Name == "LeftFoot") or (victimPart.Name == "RightUpperLeg" or victimPart.Name == "RightLowerLeg" or victimPart.Name == "RightFoot") or (victimPart.Name == "RightLeg" or victimPart.Name == "LeftLeg") then
        hum:TakeDamage(Settings.BulletDamage * Settings["Modifiers"]["Legs"])
    elseif victimPart.Name == "HumanoidRootPart" or (victimPart.Name == "UpperTorso" or victimPart.Name == "LowerTorso") or victimPart.Name == "Torso" then
        hum:TakeDamage(Settings.BulletDamage * Settings["Modifiers"]["Torso"])
    elseif victimPart.Name == "Head" then
        hum:TakeDamage(Settings.BulletDamage * Settings["Modifiers"]["Head"])
    end
end

function module:Initialise()
    Remotes.ShotFiredEvent.OnServerEvent:Connect(self.ProcessHit)
end

return module