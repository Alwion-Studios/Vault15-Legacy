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
--Roblox API Calls
local _RS = game:GetService("ReplicatedStorage")
local _RNS = game:GetService("RunService")

-- Modules
local lighting_controller = require(_RS.Controllers["Lighting.Controller"])

-- Remotes
local remotes = _RS.Remotes

local module = {

}

function module:ReturnCurrentTime()
    
end

function module:Initialise()
    local localTime

    coroutine.wrap(function()
        localTime = remotes.TimeSyncFunction:InvokeServer() - os.clock() + (game.Players.LocalPlayer:GetNetworkPing() / 2)

        _RNS.Heartbeat:Connect(function()
            local currentTime = (os.clock() + localTime) * 0.025 % 24
            game.Lighting.ClockTime = currentTime
        end)
    end)()

    return true
end

return module