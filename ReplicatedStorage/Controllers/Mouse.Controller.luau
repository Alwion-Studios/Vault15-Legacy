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

-- Remotes
local remotes = _RS.Remotes

local module = {
    mouse = game.Players.LocalPlayer:GetMouse();
    ConnectedFunctions = {};
    TotalFunctions = 0;
}

function module:Connect()
    local id = self.TotalFunctions+1
    self.ConnectedFunctions[id] = self.mouse.Button1Down:Connect(function() 
        if not self.mouse.Target then return end
        remotes.MouseClickEvent:Fire(id, self.mouse.Target)
    end)
    return id
end

function module:Disconnect(id: number)
    if not self.ConnectedFunctions[id] then return false end
    self.ConnectedFunctions[id]:Disconnect()
    return true
end

return module