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
local _RS = game:GetService("ReplicatedStorage")
local _RNS = game:GetService("RunService")

-- Remotes
local remotes = _RS.Remotes

local module = {

}

function module:Initialise()
    local localTime

    coroutine.wrap(function()
        localTime = remotes.TimeSyncFunction:InvokeServer() - os.clock() + (game.Players.LocalPlayer:GetNetworkPing() / 2)

        _RNS.Heartbeat:Connect(function()
            game.Lighting.ClockTime = (os.clock() + localTime) * 0.025 % 24      
        end)
    end)()

    return true
end

return module