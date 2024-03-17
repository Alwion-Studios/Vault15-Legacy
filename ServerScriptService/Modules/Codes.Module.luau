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
module.__index = module

function module.AttemptCode(player: Player, code: string)
    if not player or not code then return false end
    if not Codes[code] then return warn(`[CS] {player.Name} ({player.UserId}) attempted to use an incorrect code.`) end

    -- Get the user's session
    local _, session = aDS:GetSession(player.UserId, "UserData"):await()
    local _, codesTbl = session:GetKey("CodesRedeemed"):await()

    if not session then 
        warn(`[CS] Could not get {player.Name}'s session!`)
        return false
    end

    if codesTbl[code] then 
        warn(`[CS] {player.Name} ({player.UserId}) attempted to reuse code {code}`)
        return false
    end

    codesTbl[code] = true

    session:SetKey({}, "CodesRedeemed", codesTbl)

    for name, reward in Codes[code] do
        local status, _ = session:SetKey({}, name, reward):await()
        if status then print(`[CS] Granted {player.Name} {reward} {name}`) end
    end

    print(`[CS] Successfully gave {player.Name} their reward(s)!`)
    session:Save()
    return true
end

function module:Initialise()
    remotes.CodeAttemptEvent.OnServerInvoke = self.AttemptCode
end

return module