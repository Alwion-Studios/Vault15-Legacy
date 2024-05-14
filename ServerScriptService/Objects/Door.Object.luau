--!strict

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
local SignObj = require(script.Parent["Sign.Object"])
local Remotes = RS:WaitForChild("Remotes")
local ReplicatedAnimations = require(RS.Packages.ReplicatedAnimations)

--Stores
local stores = _SS:WaitForChild("DoorStorage")

local Door = {
    Category = nil;
    Instance = nil;
    PromptInstance = nil;
    Sound = nil;
    TimeToComplete = 1;
    TimeToWait = 3;
    IsLocked = false;
    RankId = false;
    GroupId = false;
    IsOpen = false;
    Debounce = false;
    Positions = nil;
}
Door.__index = Door

local IsLockedStatusStrings = {
    [true]="Locked",
    [false]="Unlocked"
}

local defaultProximityStrings = {
    [true]="Locked",
    [false]="Open"
}

local oppositeBooleans = {
    [false]=true,
    [true]=false
}

function Door:Open()
    if not self.Positions["Open"] then -- If the door's animations do not exist, calculate them
        if self.Category == "VaultInteriorDoor" then
            local Store = require(stores:WaitForChild(`{self.Category}.Store`))
            local Down = self.Instance:WaitForChild("Down")
            local Up = self.Instance:WaitForChild("Up")
    
            local DownCalculation = (CFrame.new(Down.PrimaryPart.Position.X, Down.PrimaryPart.Position.Y-Store["Positions"]["Down"], Down.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(Down.PrimaryPart.Orientation.X), math.rad(Down.PrimaryPart.Orientation.Y), math.rad(Down.PrimaryPart.Orientation.Z)))
    
            local UpCalculation = (CFrame.new(Up.PrimaryPart.Position.X, Up.PrimaryPart.Position.Y+Store["Positions"]["Up"], Up.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(Up.PrimaryPart.Orientation.X), math.rad(Up.PrimaryPart.Orientation.Y), math.rad(Up.PrimaryPart.Orientation.Z)))
    
            self.Positions["Open"] = {
                ["Down"] = DownCalculation;
                ["Up"] = UpCalculation;
            };
        elseif self.Category == "VaultBorderDoor" then
            local Store = require(stores:WaitForChild(`{self.Category}.Store`))

            local LeftCalculation = (CFrame.new(self.Instance.PrimaryPart.Position.X+Store["Positions"]["Left"], self.Instance.PrimaryPart.Position.Y, self.Instance.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(self.Instance.PrimaryPart.Orientation.X), math.rad(self.Instance.PrimaryPart.Orientation.Y), math.rad(self.Instance.PrimaryPart.Orientation.Z)))

            self.Positions["Open"] = {
                ["Left"] = LeftCalculation;
            };
        elseif self.Category == "VaultBorderDoor2" then
            local Store = require(stores:WaitForChild(`{self.Category}.Store`))

            local DownCalculation = (CFrame.new(self.Instance.PrimaryPart.Position.X, self.Instance.PrimaryPart.Position.Y-Store["Positions"]["Down"], self.Instance.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(self.Instance.PrimaryPart.Orientation.X), math.rad(self.Instance.PrimaryPart.Orientation.Y), math.rad(self.Instance.PrimaryPart.Orientation.Z)))

            self.Positions["Open"] = {
                ["Down"] = DownCalculation;
            };
        end
        --DoorService.Doors[self.Instance.Name] = self
    end

    -- Turn off cancollide
    for _, instance: Instance in pairs(self.Instance:GetDescendants()) do 
        if not instance:IsA("Part") or not instance:IsA("Union") or not instance:IsA("UnionOperation") then continue end
        if instance.Parent.Name == "Sign" then continue end

        instance.CanCollide = false
        instance.CanTouch = false
        instance.CanQuery = false
    end

    coroutine.wrap(function()
        if self.Category == "VaultInteriorDoor" then
            local anim1 = ReplicatedAnimations:Create(self.Instance.Up.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {CFrame = self.Positions["Open"]["Up"]})
            local anim2 = ReplicatedAnimations:Create(self.Instance.Down.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {CFrame = self.Positions["Open"]["Down"]})
            anim1:Play()
            anim2:Play()
            task.wait(1)
            anim1:Destroy()
            anim2:Destroy()
        elseif self.Category == "VaultBorderDoor" then
            local anim1 = ReplicatedAnimations:Create(self.Instance.PrimaryPart, TweenInfo.new(.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {CFrame = self.Positions["Open"]["Left"]})
            anim1:Play()
            task.wait(.65)
            anim1:Destroy()
        elseif self.Category == "VaultBorderDoor2" then
            local anim1 = ReplicatedAnimations:Create(self.Instance.PrimaryPart, TweenInfo.new(1.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0), {CFrame = self.Positions["Open"]["Down"]})
            anim1:Play()
            task.wait(1.25)
            anim1:Destroy()
        end
    end)()

    self.IsOpen = true
    --Remotes.DoorTrigger:FireAllClients(self.Instance, self.Positions["Open"])
    return true
end

function Door:Close()
    if not self.Positions["Closed"] then -- If the door's animations do not exist, calculate them
        if self.Category == "VaultInteriorDoor" then
            local Down = self.Instance:WaitForChild("Down")
            local Up = self.Instance:WaitForChild("Up")
    
            local DownCalculation = (CFrame.new(Down.PrimaryPart.Position.X, Down.PrimaryPart.Position.Y, Down.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(Down.PrimaryPart.Orientation.X), math.rad(Down.PrimaryPart.Orientation.Y), math.rad(Down.PrimaryPart.Orientation.Z)))
    
            local UpCalculation = (CFrame.new(Up.PrimaryPart.Position.X, Up.PrimaryPart.Position.Y, Up.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(Up.PrimaryPart.Orientation.X), math.rad(Up.PrimaryPart.Orientation.Y), math.rad(Up.PrimaryPart.Orientation.Z)))
    
            self.Positions["Closed"] = {
                ["Down"] = DownCalculation;
                ["Up"] = UpCalculation;
            };
        elseif self.Category == "VaultBorderDoor" then
            local LeftCalculation = (CFrame.new(self.Instance.PrimaryPart.Position.X, self.Instance.PrimaryPart.Position.Y, self.Instance.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(self.Instance.PrimaryPart.Orientation.X), math.rad(self.Instance.PrimaryPart.Orientation.Y), math.rad(self.Instance.PrimaryPart.Orientation.Z)))

            self.Positions["Closed"] = {
                ["Left"] = LeftCalculation;
            };
        elseif self.Category == "VaultBorderDoor2" then
            local UpCalculation = (CFrame.new(self.Instance.PrimaryPart.Position.X, self.Instance.PrimaryPart.Position.Y, self.Instance.PrimaryPart.Position.Z) 
            * CFrame.Angles(math.rad(self.Instance.PrimaryPart.Orientation.X), math.rad(self.Instance.PrimaryPart.Orientation.Y), math.rad(self.Instance.PrimaryPart.Orientation.Z)))

            self.Positions["Closed"] = {
                ["Down"] = UpCalculation;
            };
        end
        --DoorService.Doors[self.Instance.Name] = self
    end

    -- Turn on cancollide
    for _, instance: Instance in pairs(self.Instance:GetDescendants()) do 
        if not instance:IsA("Part") or not instance:IsA("Union") or not instance:IsA("UnionOperation") then continue end
        if instance.Parent.Name == "Sign" then continue end

        instance.CanCollide = false
        instance.CanTouch = false
        instance.CanQuery = false
    end

    coroutine.wrap(function()
        if self.Category == "VaultInteriorDoor" then
            local anim1 = ReplicatedAnimations:Create(self.Instance.Up.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, false, 0), {CFrame = self.Positions["Closed"]["Up"]})
            local anim2 = ReplicatedAnimations:Create(self.Instance.Down.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, false, 0), {CFrame = self.Positions["Closed"]["Down"]})
            anim1:Play()
            anim2:Play()
            print(anim1, anim2, self.Positions["Closed"])
            task.wait(1)
            anim1:Destroy()
            anim2:Destroy()
        elseif self.Category == "VaultBorderDoor" then
            local anim1 = ReplicatedAnimations:Create(self.Instance.PrimaryPart, TweenInfo.new(.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, false, 0), {CFrame = self.Positions["Closed"]["Left"]})
            anim1:Play()
            print(anim1, self.Positions["Closed"])
            task.wait(.65)
            anim1:Destroy()
        elseif self.Category == "VaultBorderDoor2" then
            local anim1 = ReplicatedAnimations:Create(self.Instance.PrimaryPart, TweenInfo.new(1.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, false, 0), {CFrame = self.Positions["Closed"]["Down"]})
            anim1:Play()
            print(anim1, self.Positions["Closed"])
            task.wait(1.25)
            anim1:Destroy()
        end
    end)()

    self.IsOpen = false
    --Remotes.DoorTrigger:FireAllClients(self.Instance, self.Positions["Closed"], true)
    return true
end

function Door:HandleTrigger(player: Player)
    if self.Debounce or self.IsLocked then return false end

    if self.GroupId and not player:IsInGroup(self.GroupId) then warn(`[DS] {player.Name} is not in group {self.GroupId}!`) return false end
    if self.GroupId and self.RankId and (player:GetRankInGroup(self.GroupId) < self.RankId) then warn(`[DS] {player.Name} does not have rank {self.RankId} in group {self.GroupId}!`) return false end

    --Tells the System to enable the "IsOpening" debounce, disable the door's prompt and trigger the door open animation
    self.Debounce = true
    self.PromptInstance.Enabled = false
    self:Open()

    task.wait(self.TimeToWait)
    
    --Tells the System to disable the "IsOpening" debounce, enable the door's prompt and trigger the door close animation
    self:Close()
    task.wait(self.TimeToComplete)
    self.PromptInstance.Enabled = true
    self.Debounce = false
end 

function Door:LockDoor(isLocked) 
    --if not isLocked or isLocked == self.IsLocked then return false end

    self.IsLocked = isLocked or oppositeBooleans[self.IsLocked]

    if self.IsLocked then self.PromptInstance.ActionText = "Locked" else self.PromptInstance.ActionText = "Open" end
    if self.IsOpen then
        self:Close()
        self.IsOpen = false
    end

    self.PendingTrigger = nil
    self.PromptInstance.ActionText = defaultProximityStrings[self.IsLocked]
    self.Sign:ChangeStatus(IsLockedStatusStrings[self.IsLocked])
end

function Door.New(category, instance, opt)
    if not instance or not category or not opt then return false end

    local self = setmetatable({}, Door)

    self.Category = category
    self.Instance = instance
    self.PromptInstance = nil
    self.IsLocked = opt["isLocked"]
    self.RankId = opt["rankId"]
    self.GroupId = opt["groupId"]
    self.Positions = {}

    -- TEMPORARY, TO BE IMPROVED DURING POLISH
    if self.Instance:FindFirstChild("Sign") then 
        print(`[DO] Deploying accompanying sign for {self.Instance.Name}`)
        self.Sign = SignObj.New(self.Instance:FindFirstChild("Sign"), {})
        self.Sign:ChangeStatus(IsLockedStatusStrings[self.IsLocked])
    end

    if opt["isLocked"] then self.IsLocked = opt["isLocked"] end

    -- TEMPORARY, TO BE IMPROVED DURING POLISH
    local ClickPart = self.Instance:WaitForChild("ProxPart", 5) :: ObjectValue?
    
    if ClickPart and ClickPart.Value then
       print(`[DO] {self.Instance.Name} has a Proximity Part that a Prompt can be attached to!`)

        local doorPrompt = RS:WaitForChild("Storage"):WaitForChild("DoorPrompt"):Clone()
        doorPrompt.Parent = ClickPart.Value
        self.PromptInstance = doorPrompt
    else
        print(`[DO] {self.Instance.Name} does not have a ClickPart to attach a ProximityPrompt to!`)
        return false
    end

    --Proximity Prompt Handling
    self.PromptInstance.ActionText = defaultProximityStrings[self.IsLocked]
    self.PromptInstance.Triggered:Connect(function(player)
        self.PendingTrigger = pcall(self:HandleTrigger(player), self)
    end)

    return self
end

return Door
