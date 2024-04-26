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
    local victimChar = victim or victim.CharacterAdded:Wait()
    local range = gunConfig.Range or 30

    if (playerChar.HumanoidRootPart.Position - victimChar.HumanoidRootPart.Position).magnitude > range then return false end
    return true
end

function module.ProcessHit(player: Player, rayCastResult: RaycastResult, position: Vector3, gun: Instance)
    if not player or not (player.Character) or not gun or gun.Parent ~= player.Character or not gun:FindFirstChild("GunSettings") then return false end

    Remotes.ShotFired:FireAllClients(player, require(gun.GunSettings).Barrel.Position, position)

    if not rayCastResult then return false end

    local victim = rayCastResult.Instance.Parent
    local victimPart = rayCastResult.Instance

    if not victim and not victimPart then return false end
    if not module.ValidateLocation(player, victim, victimPart, require(gun.GunSettings)) then return false end
    
    local Settings = require(gun.GunSettings)

    print(true)
end

function module:Initialise()
    Remotes.ShotImpactEvent.OnServerEvent:Connect(self.ProcessHit)
end

return module