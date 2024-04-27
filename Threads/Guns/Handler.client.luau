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
local Character: Model = Player.Character or Player.CharacterAdded:Wait()
local Mouse: Mouse = Player:GetMouse()
local Camera: Camera = workspace.CurrentCamera

-- Character
local Torso = Character:WaitForChild("UpperTorso")

-- Motor6D
--local Motor6D = Instance.new("Motor6D")
local Motor6D = Torso.Waist
--Motor6D.Parent = Torso
--Motor6D.Part0 = Torso

-- Remotes
local Remotes = _RS.Remotes

-- Variables
local CurrentTool: Tool = nil
local ActiveConnection: RBXScriptSignal = nil
local Settings: table = nil

-- Raycast Parameters
local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {Player.Character or Player.CharacterAdded:Wait()}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

function GetTargetPosition()
	return Mouse.Hit.Position
end

local function GetTool()
    if not Player.Character then return nil end
    local tool = Player.Character:FindFirstChildOfClass("Tool")
    if not tool or not tool:FindFirstChild("GunSettings") then return nil end

    return tool
end

local function CreateBullet(gun: Tool)
    if not gun then return false end
    task.synchronize()
    -- Bullet Creation
    local bullet = Instance.new("Part")
    bullet.Parent = workspace
    bullet.CanCollide = false
    bullet.Shape = Enum.PartType.Ball
    bullet.Transparency = 1
    bullet.Size = Vector3.new(0.5,0.5,0.5)

    -- Tracer Creation
    local att1: Attachment = gun.Handle.Attch1
    local att2: Attachment = gun.Handle.Attch2
    local trail: Trail = gun.Handle.Trail
    
    -- Clone the Attachment and Beam
    local attch1Clone: Attachment = att1:Clone()
    local attch2Clone: Attachment = att2:Clone()
    local trailClone: Beam = trail:Clone()

    attch1Clone.Parent = bullet
    attch1Clone.Position = Vector3.new(0,.05,0)
    attch2Clone.Parent = bullet
    attch2Clone.Position = Vector3.new(0,-.05,0)

    trailClone.Parent = bullet
    trailClone.Attachment0 = attch1Clone
    trailClone.Attachment1 = attch2Clone
    trailClone.Enabled = true

    trailClone.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0, 0);
        NumberSequenceKeypoint.new(1, 1);
    })

    trailClone.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2, 0);
        NumberSequenceKeypoint.new(1, 1);
    })

    local bulletMass = bullet:GetMass()
    local force = Vector3.new(0, bulletMass * (196.2), 0)
    local bodyForce = Instance.new("BodyForce")
    bodyForce.Parent = bullet

    bullet.CFrame = CFrame.new(att2.WorldPosition, att2.WorldCFrame.LookVector)
    bullet:ApplyImpulse(att2.WorldCFrame.LookVector * 2)
    bodyForce.Force = force

    print(bulletMass, bullet)
    game.Debris:AddItem(bullet, 1000)
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
            if not rayCastResult then return false end

            print(rayCastResult.Instance.Parent, rayCastResult.Instance)

            task.synchronize()
            Remotes.ShotFiredEvent:FireServer(rayCastResult.Instance.Parent, rayCastResult.Instance, Pos, CurrentTool)
            task.desynchronize()

            CreateBullet(CurrentTool)
        end
    end
    task.synchronize()
end

-- Torso Movement
_RNS.RenderStepped:Connect(function(deltaTime)
    Motor6D.C0 = Motor6D.C0 * CFrame.Angles(math.asin((Mouse.Hit.Position - Mouse.Origin.Position).Unit.Y), math.asin((Mouse.Hit.Position - Mouse.Origin.Position).Unit.Z), math.asin((Mouse.Hit.Position - Mouse.Origin.Position).Unit.X))
end)

_RNS.Heartbeat:ConnectParallel(function(deltaTime)
    local tool = GetTool()
    local CameraCFrame = Camera.CoordinateFrame

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
        raycastParams.FilterDescendantsInstances = {Player.Character or Player.CharacterAdded:Wait(), tool}
        --ActiveConnection = CurrentTool.Activated:Connect()
        Settings = require(tool.GunSettings)
        _CNS:BindAction("reload", Handle, true, Enum.KeyCode.R, Enum.KeyCode.ButtonR1)
        _CNS:BindAction("shoot", Handle, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
        task.desynchronize()
    end

    if CurrentTool then

    end
end)

Remotes.ShotFiredEvent.OnClientEvent:Connect(function(player: Player, gun, barrelPosition, aimPosition)
    if player == Player then return false end
    CreateBullet(gun)
end)