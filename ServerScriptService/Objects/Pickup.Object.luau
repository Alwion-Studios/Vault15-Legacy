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
--ROBLOX Service Calls
local _SSS = game:GetService("ServerScriptService")
local _SS = game:GetService("ServerStorage")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")

--Imports
local Remotes = RS:WaitForChild("Remotes")
local aDS = require(_SS:WaitForChild("aDS"):WaitForChild("Core"))

local Pickup = {
    Category = nil;
    Value = nil;
    Instance = nil;
    PromptInstance = nil;
    Debounce = false;
    PendingTrigger = nil;
}
Pickup.__index = Pickup

function Pickup:ShowPickup()
    self.Instance:WaitForChild("Main").Transparency = 0
    self.PromptInstance.Enabled = true
    self.Debounce = false

    if self.waitCoroutine then
        coroutine.yield(self.waitCoroutine)
        coroutine.close(self.waitCoroutine)
    end
end

function Pickup:HidePickup()
    self.Instance:WaitForChild("Main").Transparency = 1
    self.PromptInstance.Enabled = false
end

function Pickup:HandleTrigger(player: Player)
    if self.Debounce then return false end

    --Tells the System to enable the "IsOpening" debounce, disabling pickup for others
    self.Debounce = true
    self:HidePickup()

    -- Get the Player's Session
    local _, session = aDS:GetSession(player.UserId, "UserData"):await()
    local status, _ = session:SetKey({}, self.Category, (session["Structure"][self.Category] + self.Value)):await()

    if status then print(`[PS] {player.Name} has picked up {self.Category} with a value of {self.Value}!`) end

    self.waitCoroutine = coroutine.create(function()
        task.wait(30)
        self:ShowPickup()
    end)
    coroutine.resume(self.waitCoroutine)
end

function Pickup.New(instance, opt)
    if not instance or not opt then return false end

    local self = setmetatable({}, Pickup)

    self.Value = opt.Value
    self.Category = opt.Category
    self.Instance = instance

    self.PromptInstance = RS:WaitForChild("Storage"):WaitForChild("PickupPrompt"):Clone()
    self.PromptInstance.Parent = self.Instance:WaitForChild("Main")
    self.PromptInstance.ActionText = `Pickup`
    self.PromptInstance.ObjectText = `({self.Value}) {self.Category}`

    self.PromptInstance.Triggered:Connect(function(player)
        self.PendingTrigger = pcall(self:HandleTrigger(player), self)
    end)

    return self
end

return Pickup