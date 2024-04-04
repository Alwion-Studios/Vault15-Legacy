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

rpcSdk.SetRichPresence({
  details = "Exploring the Wasteland",
})

-- Vault Zone
local vZoneInstance: Instance = workspace:WaitForChild("VaultZone")
local vZone = zone.fromRegion(vZoneInstance.CFrame, vZoneInstance.Size)

vZone.localPlayerExited:Connect(function()
  rpcSdk.SetRichPresence({
    details = "Exploring the Wasteland"
  })
end)

vZone.localPlayerEntered:Connect(function()
  rpcSdk.SetRichPresence({
    details = "Exploring Vault 15"
  })
end)

-- Spawn Zone
local sZoneInstance: Instance = workspace:WaitForChild("SpawnZone")
local sZone = zone.fromRegion(sZoneInstance.CFrame, sZoneInstance.Size)

sZone.localPlayerEntered:Connect(function()
  rpcSdk.SetRichPresence({
    details = "At Spawn"
  })
end)

sZone.localPlayerExited:Connect(function()
  rpcSdk.SetRichPresence({
    details = "Exploring the Wasteland"
  })
end)