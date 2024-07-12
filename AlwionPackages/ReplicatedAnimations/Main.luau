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

-- Roblox Imports
local _TS = game:GetService("TweenService")
local _RNS = game:GetService("RunService")
local _HTTP = game:GetService("HttpService")

local Tweens = {}
local Event = nil

local Tween = {}

local INTENTS = {
    New = 1,
    Sync = 2,
    Play = 3,
    Pause = 4,
    Cancel = 5,
    Destroy = 6
}

local function infoToTable(info: TweenInfo): table
	local table: table = {}

	table[1] = info.Time or 1 
	table[2] = info.EasingStyle or Enum.EasingStyle.Quad
	table[3] = info.EasingDirection or Enum.EasingDirection.Out
	table[4] = info.RepeatCount or 0
	table[5] = info.Reverses or false
	table[6] = info.DelayTime or 0

	return table
end

local function CreateLocalTween(id, object, info, goal)
    local tween = _TS:Create(object, TweenInfo.new(unpack(info)), goal)
    Tweens[id] = tween
    task.wait(info[1])
    
    for name, value in pairs(goal) do 
        object[name] = value
    end
end

if _RNS:IsClient() then
    Event = script:WaitForChild("RemoteEvent")

    Event.OnClientEvent:Connect(function(intent: number, ...)
        local args: table = {...}

        if intent == INTENTS.New then
            CreateLocalTween(...)

        elseif intent == INTENTS.Sync then
            for id, tween in pairs(args[1]) do
                CreateLocalTween(id, tween[1], tween[2], tween[3])
            end

        elseif intent == INTENTS.Play then
            local tween = Tweens[args[1]]

            if tween then
                tween:Play()
            end

        elseif intent == INTENTS.Pause then
            local tween = Tweens[args[1]]
            if tween then
                tween:Pause()
            end

        elseif intent == INTENTS.Cancel then
            local tween = Tweens[args[1]]
            if tween then
                tween:Cancel()
            end

        elseif intent == INTENTS.Destroy then
            if Tweens[args[1]] then
                Tweens[args[1]] = nil
            end
        end
    end)
end

if _RNS:IsServer() then 
    Event = Instance.new("RemoteEvent")
    Event.Parent = script

    Event.OnServerEvent:Connect(function(player: Player, intent: String)
        if intent == INTENTS.Sync then
            Tween.Event:FireClient(player, Tweens)
        end
    end)

    Tween.__index = Tween
    
    function Tween:Create(object: Instance, info: TweenInfo, goal: Table)
        local self = setmetatable({}, Tween)

        self._id = _HTTP:GenerateGUID()
        self._tween = _TS:Create(object, info, goal)

        Tweens[self._id] = {object, infoToTable(info), goal}
        Event:FireAllClients(INTENTS.New, self._id, object, infoToTable(info), goal)

        return self
    end
    
    function Tween:Play()
        self._tween:Play()
        Event:FireAllClients(INTENTS.Play, self._id)
    end

    function Tween:Pause()
        self._tween:Pause()
        Event:FireAllClients(INTENTS.Pause, self._id)
    end

    function Tween:Cancel()
        self._tween:Cancel()
        Event:FireAllClients(INTENTS.Cancel, self._id)
    end

    function Tween:Destroy()
        Event:FireAllClients(INTENTS.Destroy, self._id)
        Tweens[self._id] = nil
    end
end

return Tween