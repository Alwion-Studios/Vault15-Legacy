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
local notifyRemote = remotes.NotifyUser

-- Imports
local aDS = require(SS:WaitForChild("aDS"):WaitForChild("Core"))

-- Codes
local Codes = {
    freecaps = {
        ["Caps"] = 50
    },

    morecaps = {
        ["Caps"] = 150
    },

    lotsofcaps = {
        ["Caps"] = 250
    },

    alwion = {
        ["Caps"] = 100,
        ["Bullet"] = 10
    },

    getscammed = {
        ["Caps"] = 0
    }
}

-- Module
local module = {}
module.__index = module

function module.AttemptCode(player: Player, code: string)
    if not player or not code then return false end
    if not Codes[code] then notifyRemote:FireClient(player, `Code Redemption`, `This is not a valid code!`) return warn(`[CS] {player.Name} ({player.UserId}) attempted to use an incorrect code.`) end

    -- Get the user's session
    local _, session = aDS:GetSession(player.UserId, "UserData"):await()
    local _, codesTbl = session:GetKey("CodesRedeemed"):await()

    if not session then 
        warn(`[CS] Could not get {player.Name}'s session!`)
        return false
    end

    if codesTbl[code] then 
        warn(`[CS] {player.Name} ({player.UserId}) attempted to reuse code {code}`)
        notifyRemote:FireClient(player, `Code Redemption`, `You've already redeemed {code}!`)
        return false
    end

    codesTbl[code] = true

    session:SetKey({}, "CodesRedeemed", codesTbl)

    for name, reward in Codes[code] do
        local status, _ = session:SetKey({}, name, (session["Structure"][name] + reward)):await()
        if status then print(`[CS] Granted {player.Name} {reward} {name}`) end
    end

    print(`[CS] Successfully gave {player.Name} their reward(s)!`)
    notifyRemote:FireClient(player, `Code Redemption`, `You've Redeemed {code}!`)
    session:Save()
    return true
end

function module:Initialise()
    remotes.CodeAttemptEvent.OnServerInvoke = self.AttemptCode
end

return module