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
local packages = _RS.Packages

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
        lighting_controller:SetMode(self.Lighting.Value.Name)
    end
end

function Zone:PlayerLeft()
    print(`[ZNS-CLIENT] You have left a zone!`)

    if self.RPC then
        rpcSdk.SetRichPresence({details = "Exploring the Wasteland..."})
    end

    if self.Lighting then
        lighting_controller:SetMode("Wasteland")
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

    -- Lighting Folder
    if self.Instance:FindFirstChild("Lighting") then
        self.Lighting = self.Instance:FindFirstChild("Lighting") or nil
    end

    return self
end

return Zone