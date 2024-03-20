--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

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