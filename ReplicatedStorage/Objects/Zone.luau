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
local _RNS = game:GetService("RunService")
local _SSS = game:GetService("ServerScriptService")
local _SS = game:GetService("ServerStorage")
local _RS = game:GetService("ReplicatedStorage")

--Imports
local packages = _RS.Packages

-- Controllers
local daynight_controller = require(_RS.Controllers["DayNight.Controller"])

-- Imports
local rpcSdk = require(packages["bloxstrap-rpc-sdk"])
local zonePlus = require(_RS.Zone)
local lighting_controller = require(script.Parent.Parent.Controllers["Lighting.Controller"])

local Zone = {}
Zone.__index = Zone

function Zone:PlayerEntered()
    print(`[ZNS-CLIENT] You have entered a zone!`)
    if self.RPC then
        rpcSdk.SetRichPresence(self.RPC)
    end

    if self.Lighting then
        if self.DayNightCycle then 
            coroutine.close(self.DayNightCycle)
        end

        lighting_controller:SetMode(self.Lighting.Value.Name)
    end
end

function Zone:PlayerLeft()
    print(`[ZNS-CLIENT] You have left a zone!`)

    if self.RPC then
        rpcSdk.SetRichPresence({details = "Exploring the Wasteland..."})
    end

    if self.Lighting and not self.Parent then
        -- Handle Lighting Configurations
        self.DayNightCycle = coroutine.wrap(function()
            _RNS.Heartbeat:Connect(function()
                if game.Lighting.ClockTime > 6.5 and game.Lighting.ClockTime < 18 then
                    lighting_controller:SetMode("WastelandDay", true)
                else
                    lighting_controller:SetMode("WastelandNight", true)
                end
            end)
        end)()
    end

    if self.ParentZone then
        lighting_controller:SetMode(self.ParentZone:FindFirstChild("Lighting").Value.Name)
    end
end

function Zone.New(instance: Instance)
    if not instance then return false end

    local self = setmetatable({}, Zone)

    self.Instance = instance
    self.Zone = zonePlus.fromRegion(self.Instance.CFrame, self.Instance.Size)
    
    -- Events
    self.Zone.localPlayerEntered:Connect(function()
        self:PlayerEntered()
    end)

    self.Zone.localPlayerExited:Connect(function()
        self:PlayerLeft()
    end)

    -- RPC Details
    if self.Instance:FindFirstChild("RPC") then
        self.RPC = require(self.Instance:FindFirstChild("RPC"))
    end

    -- Parent Details
    if self.Instance:FindFirstChild("Parent") then
        self.ParentZone = self.Instance:FindFirstChild("Parent").Value or nil
    end

    -- Lighting Folder
    if self.Instance:FindFirstChild("Lighting") then
        self.Lighting = self.Instance:FindFirstChild("Lighting") or nil
    end

    return self
end

return Zone