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

local RigAnimationController = {
	areFansEnabled = true
}

local function fanAnimation(instance: UnionOperation)
	local speed = Random.new():NextNumber(-0.25, -2)
	while wait(0.0001) do
		if not RigAnimationController.areFansEnabled then break end
		instance.CFrame = instance.CFrame * CFrame.Angles(math.rad(speed), 0, 0)
	end
end

function RigAnimationController:InitialiseFans()
	if self.areFansEnabled and self.areFansEnabled == true then return false end
	for _, instance: UnionOperation in pairs(_CS:GetTagged("Fan")) do
		task.spawn(fanAnimation, instance)
	end
	self.areFansEnabled = true
end

function RigAnimationController:ToggleAnimations()
	if self.areFansEnabled and self.areFansEnabled == true then
		self.areFansEnabled = false
	else
		self:InitialiseFans()
	end

	return self.areFansEnabled
end

function RigAnimationController:Initialise()
	self.areFansEnabled = false
	self:InitialiseFans()
end

return RigAnimationController
