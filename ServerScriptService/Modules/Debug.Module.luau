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
local module = {}
module.__index = module

function module:Initialise()
    return Promise.new(function(resolve, reject, onCancel)
        if not _RS:IsStudio() then return reject(false) end
        print(`[DBS] Debug Service Active!`)

        -- Turn Debug Mode On
        local debugValue = Instance.new("BoolValue")
        debugValue.Name = "DebugMode"
        debugValue.Value = true
        debugValue.Parent = RS

        -- Create a folder for Debug Remotes
        local debugFlr = Instance.new("Folder")
        debugFlr.Name = "Debug"
        debugFlr.Parent = remotes

        -- Initialise DEBUG Remotes
        local disableUsernameChecks = Instance.new("RemoteEvent")
        disableUsernameChecks.Name = "DisableUsernameChecks"
        disableUsernameChecks.Parent = debugFlr

        disableUsernameChecks.OnClientEvent:Connect(function(plr)
            if not RS:FindFirstChild("DisableUsernameChecks") then
                local usernameChecks = Instance.new("BoolValue")
                usernameChecks.Name = "DisableUsernameChecks"
                usernameChecks.Value = true
                usernameChecks.Parent = RS
            end

            if RS:FindFirstChild("DisableUsernameChecks").Value == false then
                warn(`[DBS] Username Checks Disabled!`)
                RS:FindFirstChild("DisableUsernameChecks").Value = true
            else
                warn(`[DBS] Username Checks Enabled!`)
                RS:FindFirstChild("DisableUsernameChecks").Value = false
            end
        end)

        resolve(true)
    end)
end

return module