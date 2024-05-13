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
local _CS = game:GetService("CollectionService")

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

local function CreateBullet(gun: Tool)
    if not gun then return false end
end

local function CreateProjectile(gun: Tool)
    if not gun then return false end
end

local function CreateMuzzleFlash(gun: Tool)
    if not gun or not gun.Barrel or not gun.Barrel.MuzzleFlash then return false end
    
    gun.Barrel.MuzzleFlash.Enabled = true
    task.wait(0.1)
    gun.Barrel.MuzzleFlash.Enabled = false
    
end

local function PlaySound(gun: Tool, status: string)
    if not gun or not status then return false end
    if not gun.Handle[`{status}Sound`] then return false end

    
    gun.Handle[`{status}Sound`]:Play()
    
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

local function CastRay(origin: Vector3, target: Vector3, range: Number)
    local raycastResult = game.Workspace:Raycast(origin, (target - origin).Unit * range, raycastParams)

    return raycastResult
end

local function Handle(type, inputState:Enum.UserInputState, inputObject: InputObject)
    
    if inputState == Enum.UserInputState.Begin then
        if type == "shoot" then
            local Pos = GetTargetPosition()

            if not CanShoot(Pos) then return false end

            local rayCastResult: RaycastResult = CastRay(Settings.Barrel.Position, Pos, 30)
            
            if not rayCastResult then 
                Remotes.ShotFiredEvent:FireServer(nil, nil, Pos, CurrentTool)
            else
                Remotes.ShotFiredEvent:FireServer(rayCastResult.Instance.Parent, rayCastResult.Instance, Pos, CurrentTool)
            end
            

            CreateMuzzleFlash(CurrentTool)
            CreateBullet(CurrentTool)
            PlaySound(CurrentTool, "Fire")
        end
    end
    
end

-- Torso Movement
--[[_RNS.RenderStepped:Connect(function(deltaTime)
    Motor6D.C0 = Motor6D.C0 * CFrame.Angles(math.asin((Mouse.Hit.Position - Mouse.Origin.Position).Unit.Y), math.asin((Mouse.Hit.Position - Mouse.Origin.Position).Unit.Z), math.asin((Mouse.Hit.Position - Mouse.Origin.Position).Unit.X))
end)]]

--[[_RNS.Heartbeat:ConnectParallel(function(deltaTime)
    local tool = GetTool()

    if CurrentTool and CurrentTool ~= tool then
        
       if ActiveConnection then
            ActiveConnection:Disconnect()
        end
        _CNS:UnbindAction("reload", Handle, true, Enum.KeyCode.R, Enum.KeyCode.ButtonR1)
        _CNS:UnbindAction("shoot")
        

        CurrentTool = nil
        Settings = nil
    end

    if tool and CurrentTool ~= tool then
        CurrentTool = tool

        
        raycastParams.FilterDescendantsInstances = {Player.Character or Player.CharacterAdded:Wait(), tool}
        --ActiveConnection = CurrentTool.Activated:Connect()
        Settings = require(tool.GunSettings)
        _CNS:BindAction("reload", Handle, true, Enum.KeyCode.R, Enum.KeyCode.ButtonR1)
        _CNS:BindAction("shoot", Handle, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
        
    end
end)]]

for _, gun: Tool in ipairs(_CS:GetTagged("Gun")) do
    gun.Unequipped:Connect(function()
        CurrentTool = nil
        Settings = nil
        _CNS:UnbindAction("reload")
        _CNS:UnbindAction("shoot")
    end)

    gun.Equipped:Connect(function()
        raycastParams.FilterDescendantsInstances = {Player.Character or Player.CharacterAdded:Wait(), gun}
        Settings = require(gun.GunSettings)
        CurrentTool = gun
        _CNS:BindAction("reload", Handle, true, Enum.KeyCode.R, Enum.KeyCode.ButtonR1)
        _CNS:BindAction("shoot", Handle, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
    end)
end

Remotes.ShotFiredEvent.OnClientEvent:Connect(function(player: Player, gun, barrelPosition, aimPosition)
    if player == Player then return false end
    CreateBullet(gun)
end)