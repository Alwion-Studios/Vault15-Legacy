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
local PS = game:GetService("Players")

-- Formatting Function
local formatter = require(RS.Formatting.Number)

-- PlayerUI
local PlayerGui = PS.LocalPlayer:WaitForChild("PlayerGui")

-- SaveFile
local SaveFile = PS.LocalPlayer:WaitForChild("SaveFile")

-- UI to Target
local GUI = PlayerGui:WaitForChild("ScreenGui")

-- UI Frames
local LeftBox = GUI:WaitForChild("LeftBox")

-- Current Animation
local currCapAnim

-- Count animation
local function countAnim(currentValue, target, toSet)
  if target > currentValue then
      for i = currentValue, target,1 do
          toSet.Text = i
          task.wait(0.0125)
      end
  else
      for i = currentValue, target,-1 do
          toSet.Text = i
          task.wait(0.0125)
      end
  end
end

-- Animation Functions
local function openUI()
  
end

local function closeUI()
  
end

-- Code
-- Left Box Caps Rendering
LeftBox.Caps.Text = formatter(SaveFile:WaitForChild("Caps").Value)
SaveFile:WaitForChild("Caps").Changed:Connect(function(newVal)
  if currCapAnim then
    coroutine.close(currCapAnim)
  end

  currCapAnim = coroutine.create(function()
    countAnim(tonumber(LeftBox.Caps.Text), newVal, LeftBox.Caps)
  end)
  coroutine.resume(currCapAnim)
end)