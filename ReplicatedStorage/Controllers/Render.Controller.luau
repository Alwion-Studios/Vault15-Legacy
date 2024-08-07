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
local CS = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")
local Remotes = RS.Remotes

--Tween Function
local Tween = require(RS:WaitForChild("Functions"):WaitForChild("Tween"))

local DoorsController = {
    IsOperating = false;
}

function ChangeDoorPosition(instance, position) 
    if not instance then return false end 

    local UP = instance:WaitForChild("Up")
    local UPRoot = UP.PrimaryPart

    local DOWN = instance:WaitForChild("Down")
    local DOWNRoot = DOWN.PrimaryPart

    UPRoot.CFrame = position["Up"]
    DOWNRoot.CFrame = position["Down"]
end

function HandleDoorAnimation(instance, animation, isClosing)
    if not instance then return false end 

    if instance:GetAttribute("Category") == "VaultInteriorDoor" then
        local UP = instance:WaitForChild("Up")
        local UPRoot = UP.PrimaryPart
        local DOWN = instance:WaitForChild("Down")
        local DOWNRoot = DOWN.PrimaryPart

        if not UPRoot or not DOWNRoot then return false end

        if isClosing then 
            Tween(UPRoot, 1, "Sine", "In", 0, false, {CFrame = animation["Up"]})
            Tween(DOWNRoot, 1, "Sine", "In", 0, false, {CFrame = animation["Down"]})
        else 
            Tween(UPRoot, 1, "Sine", "Out", 0, false, {CFrame = animation["Up"]})
            Tween(DOWNRoot, 1, "Sine", "Out", 0, false, {CFrame = animation["Down"]})
        end
    elseif instance:GetAttribute("Category") == "VaultBorderDoor" then
        local Part = instance.PrimaryPart
        Tween(Part, .65, "Linear", "Out", 0, false, {CFrame = animation["Left"]})
    elseif instance:GetAttribute("Category") == "VaultBorderDoor2" then
        local Part = instance.PrimaryPart
        Tween(Part, 1.25, "Linear", "Out", 0, false, {CFrame = animation["Down"]})
    end
end

function HandleSignAnimation(instance, colour)
    if not instance then return false end 

    local MainColour = instance:WaitForChild("Main")
    if not MainColour then return false end

    Tween(MainColour, .25, "Linear", "In", 0, false, {Color = colour})
end

function ChangeSignColour(instance, colour)
    if not instance then return false end 

    local MainColour = instance:WaitForChild("Main")
    if not MainColour then return false end
    MainColour.Color = colour
end

function DoorsController:Initialise()
    function onRefresh(instance)
        local res = Remotes.RequestDoorDetails:InvokeServer(instance.Name)
        if not res then return false end

        if res["IsOpen"] then 
            ChangeDoorPosition(instance, res["Positions"]["Open"]) 
        end

        --Sign Handler
        if instance:FindFirstChild("Sign") and res["Sign"] then 
            ChangeSignColour(res["Sign"]["Instance"], res["Sign"]["Colour"])
        end
    end

    --Handle Streaming
    CS:GetInstanceAddedSignal("Door"):Connect(onRefresh)

    --Handle Remotes
    Remotes.DoorTrigger.OnClientEvent:Connect(HandleDoorAnimation)
    Remotes.SignTrigger.OnClientEvent:Connect(HandleSignAnimation)

    --Handle Initialisation
    for _, instance in pairs(CS:GetTagged("Door")) do
        onRefresh(instance)
    end
end

return DoorsController