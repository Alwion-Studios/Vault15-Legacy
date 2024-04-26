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
local _PS = game:GetService("Players")
local _RS = game:GetService("ReplicatedStorage")
local _RNS = game:GetService("RunService")
local _CNS = game:GetService("ContextActionService")

-- Player
local Player: Player = _PS.LocalPlayer
local Mouse: Mouse = Player:GetMouse()

-- Remotes
local Remotes = _RS.Remotes

-- Variables
local CurrentTool: Tool = nil
local ActiveConnection: RBXScriptSignal = nil
local Settings: table = nil

-- Raycast Parameters
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

function GetTargetPosition()
	return Mouse.Hit.Position
end

local function GetTool()
    if not Player.Character then return nil end
    local tool = Player.Character:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("GunSettings") then return nil end

    return tool
end

function CreateLine(Pos1, Pos2)
    task.synchronize()

	local Trail = Instance.new("Part")
	Trail.Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
	Trail.Transparency = 0
	Trail.Anchored = true
	Trail.CanCollide = false
	local Length = (Pos2 - Pos1).Magnitude
	Trail.CFrame = CFrame.new(Pos1, Pos2) * CFrame.new(0, 0, Length * -0.5)
	Trail.Size = Vector3.new(0.1, 0.1, Length)
	Trail.Parent = game.Workspace
	wait(0.1)
	Trail:Destroy()
    task.desynchronize()
end

local function CanShoot(Pos) 
    --[[if not CurrentTool or 
       not CurrentTool.Reloading.Value or 
       Player.SaveFile[Settings.BulletItem].Value < 1 or 
       CurrentTool.Clip.Value < 1 or 
       not Pos then
		return false
	end]]

	return true
end

local function RayCastValidation(origin: Vector3, target: Vector3, range: Number)
    task.desynchronize()

    local raycastResult = game.Workspace:Raycast(origin, (target - origin).Unit * range, raycastParams)

    return raycastResult
end

local function Handle(type, inputState:Enum.UserInputState, inputObject: InputObject)
    task.desynchronize()
    if inputState == Enum.UserInputState.Begin then
        if type == "shoot" then
            local Pos = GetTargetPosition()

            if not CanShoot(Pos) then return false end

            local rayCastResult: RaycastResult = RayCastValidation(Settings.Barrel.Position, Pos, 30)

            task.synchronize()
            Remotes.ShotImpactEvent:FireServer(rayCastResult, Pos, CurrentTool)
            task.desynchronize()

            CreateLine(Settings.Barrel.Position, Pos)
        end
    end
    task.synchronize()
end

_RNS.Heartbeat:ConnectParallel(function(deltaTime)
    local tool = GetTool()
    if CurrentTool and CurrentTool ~= tool then
        task.synchronize()
        --[[if ActiveConnection then
            ActiveConnection:Disconnect()
        end]]
        _CNS:UnbindAction("reload", Handle, true, Enum.KeyCode.R, Enum.KeyCode.ButtonR1)
        _CNS:UnbindAction("shoot")
        task.desynchronize()

        CurrentTool = nil
        Settings = nil
    end

    if tool and CurrentTool ~= tool then 
        CurrentTool = tool

        task.synchronize()
        --ActiveConnection = CurrentTool.Activated:Connect()
        Settings = require(tool.GunSettings)
        raycastParams.FilterDescendantsInstances = {Player.Character or Player.CharacterAdded:Wait(), tool}
        _CNS:BindAction("reload", Handle, true, Enum.KeyCode.R, Enum.KeyCode.ButtonR1)
        _CNS:BindAction("shoot", Handle, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
        task.desynchronize()
    end

    if CurrentTool then

    end
end)

Remotes.ShotFired.OnClientEvent:Connect(function(player: Player, barrelPosition, aimPosition)
    print(true)
    if player == Player then return false end

    CreateLine(barrelPosition, aimPosition)
end)