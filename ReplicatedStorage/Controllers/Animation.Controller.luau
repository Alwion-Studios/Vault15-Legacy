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
local _CS = game:GetService("CollectionService")
local _RNS = game:GetService("RunService")
local _PLR = game:GetService("Players")

--Tween Function
local Tween = require(_RS:WaitForChild("Functions"):WaitForChild("Tween"))

local RigAnimationController = {}

-- Get the Rig's Nearest Player
local function getClosestPlayerHrp(hrp, dist)
    local closestHrp = nil
    for i, v in pairs(game.Players:GetChildren()) do
        
        local tmpChar = v.Character or v.CharacterAdded:Wait()
        local tmpHrp = tmpChar:FindFirstChild("HumanoidRootPart")
        local tmpDist = (tmpHrp.Position - hrp.Position).Magnitude      
        if tmpHrp and tmpDist < dist then
            closestHrp = tmpHrp
            dist = tmpDist
        end
    end
    return closestHrp, dist
end

function RigAnimationController:ConfigureRig(rig: Instance)
    if not rig then return false end
    print(rig)
    
    -- Configure and Play the Rig's Idle Animation
    local animation = rig:FindFirstChild("Idle")
    if not animation then return false end

    local track = rig:WaitForChild("Humanoid").Animator:LoadAnimation(animation)
    if not track then return false end

    animation = nil
    track.Looped = true
    track:Play()
end

function RigAnimationController:ConfigureHeadTracking()
    local vecFlat = Vector3.new(1,0,1)

    -- Configure Head Tracking
    _RNS.RenderStepped:Connect(function(deltaTime)
        for _, rig in pairs(_CS:GetTagged("AnimatedRig")) do 
            local neck = rig.Head:WaitForChild("Neck")
            local xOffSet = neck.C0.X
            local yOffSet = neck.C0.Y
            local zOffSet = neck.C0.Z

            local closestHrp, dist = getClosestPlayerHrp(rig.HumanoidRootPart, 50)
            if closestHrp then
                local dir = (closestHrp.Position - rig.HumanoidRootPart.Position).Unit
                local vecA = Vector2.new(rig.HumanoidRootPart.CFrame.LookVector.X, rig.HumanoidRootPart.CFrame.LookVector.Z)
                local vecB = Vector2.new(dir.X, dir.Z)
                local dotValue = vecA:Dot(vecB)
                local crossValue = vecA:Cross(vecB)
                local ht = rig.HumanoidRootPart.Position.Y - closestHrp.Position.Y
                local upAngle = math.atan(ht/dist)
                
                local angle = math.atan2(crossValue, dotValue)
                if angle > math.pi/3 then
                    angle = math.pi/3
                elseif angle < -math.pi/3 then
                    angle = -math.pi/3
                end
                neck.C0 = CFrame.new(xOffSet, yOffSet, zOffSet)*CFrame.Angles(0, -angle, 0) * 
                    CFrame.Angles(-upAngle, 0, 0)
            end
        end
    end)
end

function RigAnimationController:Initialise()
    for _, rig in pairs(_CS:GetTagged("AnimatedRig")) do
        self:ConfigureRig(rig)
    end
    self:ConfigureHeadTracking()
end

return RigAnimationController