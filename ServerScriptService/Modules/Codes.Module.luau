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

-- Remotes
local remotes = RS:WaitForChild("Remotes")

-- Imports
local aDS = require(SS:WaitForChild("aDS"):WaitForChild("Core"))

-- Codes
local Codes = {
    feecaps = {
        ["Caps"] = 200
    },

    morecaps = {
        ["Caps"] = 150
    },

    lotsofcaps = {
        ["Caps"] = 250
    },

    alwion = {
        ["Caps"] = 100
    }
}

-- Module
local module = {}

function module.AttemptCode(player: Player, code: string)
    if not player or not code then return false end
    if not Codes[code] then return false end

    -- Get the user's session
    local _, session = aDS:GetSession(player.UserId, "UserData")
    local _, codes = session:GetKey("CodesRedeemed")

    table.insert(codes, code)

    session:SetKey({"Stats"}, "CodesRedeemed", codes)

    for name, reward in Codes[code] do 
        session:SetKey({"Stats"}, name, reward):await()
    end
end

function module:Initialise()
    remotes.CodeAttemptEvent.OnServerInvoke:Connect(self.AttemptCode)
end

return module