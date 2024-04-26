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

    if self.Instance.Name == "Bullet" then 
        for _, partToHide in pairs(self.Instance:WaitForChild("Parts"):GetChildren()) do
            partToHide.Transparency = 0
        end
    end

    if self.Light then 
        self.Light.Enabled = true
    end

    if self.Particles then 
        self.Particles.Enabled = true
    end

    if self.waitCoroutine then
        coroutine.yield(self.waitCoroutine)
        coroutine.close(self.waitCoroutine)
    end
end

function Pickup:HidePickup()
    self.Instance:WaitForChild("Main").Transparency = 1

    if self.Instance.Name == "Bullet" then 
        for _, partToHide in pairs(self.Instance:WaitForChild("Parts"):GetChildren()) do 
            partToHide.Transparency = 1
        end
    end

    self.PromptInstance.Enabled = false
end

function Pickup:HandleTrigger(player: Player)
    if not self.Instance or self.Instance.Parent ~= self.Parent or self.Debounce then return false end

    --Tells the System to enable the "IsOpening" debounce, disabling pickup for others
    self.Debounce = true

    -- Get the Player's Session
    local _, session = aDS:GetSession(player.UserId, "Profile"):await()

    if not session then
        return false
    end

    self:HidePickup()
    local status, _ = session:SetKey({}, self.Category, (session["Structure"][self.Category] + self.Value)):await()

    if status then print(`[PS] {player.Name} has picked up {self.Category} with a value of {self.Value}!`) end
    
    if self.Light then 
        self.Light.Enabled = false
    end

    if self.Particles then 
        self.Particles.Enabled = false
    end

    self.waitCoroutine = coroutine.create(function()
        task.wait(self.TimeToWait)
        self:ShowPickup()
    end)
    coroutine.resume(self.waitCoroutine)
end

function Pickup.New(instance: Instance, opt: table)
    if not instance or not opt then return false end

    local self = setmetatable({}, Pickup)

    if opt.Category == "Nuka-Cola Quantum Cap" then 
        self.Light = instance:WaitForChild("Main").PointLight
        self.Particles = instance:WaitForChild("Main").ParticleEmitter
    end

    if opt.Category == "Nuka-Cola Quantum Cap" or opt.Category == "Nuka-Cola Grape Cap" or opt.Category == "Nuka-Cola Cap" then 
        opt.Category = "Caps"
    end

    self.TimeToWait = 60
    if instance:FindFirstChild("TimeTillRespawn") then 
        self.TimeToWait = instance:WaitForChild("TimeTillRespawn").Value
    end

    self.Value = opt.Value
    self.Category = opt.Category
    self.Instance = instance
    self.Parent = instance.Parent

    self.PromptInstance = RS:WaitForChild("Storage"):WaitForChild("PickupPrompt"):Clone()
    self.PromptInstance.Parent = self.Instance
    self.PromptInstance.ActionText = `Pickup`

    if self.Value > 1 then 
        self.PromptInstance.ObjectText = `{self.Value} {instance.Name}s`
    else
        self.PromptInstance.ObjectText = `{instance.Name}`
    end

    self.PromptInstance.Triggered:Connect(function(player)
        self.PendingTrigger = pcall(self:HandleTrigger(player), self)
    end)

    return self
end

return Pickup