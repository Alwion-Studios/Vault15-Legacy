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
local RS = game:GetService("ReplicatedStorage")

-- Packages
local packages = RS.Packages
local rpcSdk = require(packages["bloxstrap-rpc-sdk"])
local zone = require(RS.Zone)

-- Vault Zone
local vZoneInstance: Instance = workspace:WaitForChild("VaultZone")
local vZone = zone.fromRegion(vZoneInstance.CFrame, vZoneInstance.Size)

local RPC = rpcSdk.SetRichPresence({
  details = "Exploring the Wasteland...",
})
