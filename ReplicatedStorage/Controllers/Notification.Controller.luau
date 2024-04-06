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

-- Remotes
local remotes = RS.Remotes
local notifyRemote = remotes.NotifyUser

local StarterGui = game:GetService("StarterGui")

local module = {}

function module:Initialise()
    notifyRemote.OnClientEvent:Connect(function(title, description)
        if not title or not description then return false end

        return StarterGui:SetCore("SendNotification", {
            Title=title,
            Text=description,
        })
    end)
end

return module