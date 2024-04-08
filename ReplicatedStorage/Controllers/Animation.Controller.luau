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
		local realDist = (tmpHrp.Position - hrp.Position).Unit

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { tmpChar, workspace.VaultShop, workspace.Shop }
		raycastParams.FilterType = Enum.RaycastFilterType.Include

		local rayDestination = tmpHrp.Parent.Head.Position
		local rayOrigin = hrp.Parent.Head.Position
		local rayDirection = rayDestination

		local raycastResult = game.Workspace:Raycast(rayOrigin, realDist * dist, raycastParams)

		if raycastResult then
			if tmpHrp and tmpDist < dist and raycastResult.Instance.Parent == tmpHrp.Parent then
				closestHrp = tmpHrp
				dist = tmpDist
			end
		end
	end
	return closestHrp, dist
end

function RigAnimationController:ConfigureRig(rig: Instance)
	if not rig then
		return false
	end

	-- Configure and Play the Rig's Idle Animation
	local animation = rig:FindFirstChild("Idle")
	if not animation then
		return false
	end

	local track = rig:WaitForChild("Humanoid").Animator:LoadAnimation(animation)
	if not track then
		return false
	end

	animation = nil
	track.Looped = true
	track:Play()
end

function RigAnimationController:ConfigureHeadTracking()
	-- Configure Head Tracking
	_RNS.RenderStepped:Connect(function(deltaTime)
		for _, rig in pairs(_CS:GetTagged("AnimatedRig")) do
			local neck = rig.Head:WaitForChild("Neck")
			local xOffSet = neck.C0.X
			local yOffSet = neck.C0.Y
			local zOffSet = neck.C0.Z

			local closestHrp, dist = getClosestPlayerHrp(rig.HumanoidRootPart, 40)
			if closestHrp then
				local dir = (closestHrp.Position - rig.HumanoidRootPart.Position).Unit
				local vecA =
					Vector2.new(rig.HumanoidRootPart.CFrame.LookVector.X, rig.HumanoidRootPart.CFrame.LookVector.Z)
				local vecB = Vector2.new(dir.X, dir.Z)
				local dotValue = vecA:Dot(vecB)
				local crossValue = vecA:Cross(vecB)
				local ht = rig.HumanoidRootPart.Position.Y - closestHrp.Position.Y
				local upAngle = math.atan(ht / dist)

				local angle = math.atan2(crossValue, dotValue)
				if angle > math.pi / 3 then
					angle = math.pi / 3
				elseif angle < -math.pi / 3 then
					angle = -math.pi / 3
				end
				--[[neck.C0 = (
					CFrame.new(xOffSet, yOffSet, zOffSet)
					* CFrame.Angles(0, -angle, 0)
					* CFrame.Angles(-upAngle, 0, 0)
				)]]
				Tween(neck, 0.15, "Linear", "In", 0, false, {C0 = (CFrame.new(xOffSet, yOffSet, zOffSet)*CFrame.Angles(0, -angle, 0) * CFrame.Angles(-upAngle, 0, 0))})
			else
				Tween(
					neck,
					0.5,
					"Linear",
					"In",
					0,
					false,
					{ C0 = (CFrame.new(xOffSet, yOffSet, zOffSet) * CFrame.Angles(0, 0, 0) * CFrame.Angles(0, 0, 0)) }
				)
			end
		end
	end)
end

function RigAnimationController:Initialise()
	for _, rig in pairs(_CS:GetTagged("AnimatedRig")) do
		self:ConfigureRig(rig)
	end

	self:ConfigureHeadTracking()

	for _, instance: UnionOperation in pairs(_CS:GetTagged("Fan")) do
		local speed = Random.new():NextNumber(-0.25, -2)
		task.spawn(function()
			while task.wait(0.001) do
				instance.CFrame = instance.CFrame * CFrame.Angles(math.rad(speed), 0, 0)
			end
		end)
	end
end

return RigAnimationController
