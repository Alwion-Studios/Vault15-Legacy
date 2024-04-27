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
local _GS = game:GetService("TweenService")

--Tween Function
local Tween = function (Object, Time, Style, Direction, RepeatCount, Repeat, Customization)
	task.synchronize()
	_GS:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], RepeatCount, Repeat, 0), Customization):Play()
end

-- Get the Rig's Nearest Player
local function getClosestPlayerHrp(hrp, dist)
	local closestHrp = nil

	for i, v in pairs(game.Players:GetChildren()) do
		local tmpChar = v.Character or v.CharacterAdded:Wait()
		local tmpHrp = tmpChar:FindFirstChild("HumanoidRootPart")
		local tmpDist = (tmpHrp.Position - hrp.Position).Magnitude
		local realDist = (tmpHrp.Position - hrp.Position).Unit

        task.synchronize()
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {tmpChar, workspace.VaultShop, workspace.Shop}
        raycastParams.FilterType = Enum.RaycastFilterType.Include
        task.desynchronize()
        
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

local function ConfigureRig(rig: Instance)
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

local function ConfigureHeadTracking()
	-- Configure Head Tracking
	_RNS.RenderStepped:ConnectParallel(function(deltaTime)
		for _, rig in pairs(_CS:GetTagged("AnimatedRig")) do
			task.synchronize()
			if not rig or not rig:FindFirstChild("Head") then continue end
			local neck = rig:FindFirstChild("Head").Neck
			task.desynchronize()
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
				task.desynchronize()
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
				task.desynchronize()
			end
		end
	end)
end

print(true)
for _, rig in pairs(_CS:GetTagged("AnimatedRig")) do
    ConfigureRig(rig)
end
ConfigureHeadTracking()