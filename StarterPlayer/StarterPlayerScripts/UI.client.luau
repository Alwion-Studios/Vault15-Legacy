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

-- PlayerUI
local PlayerGui = PS.LocalPlayer:WaitForChild("PlayerGui")

-- SaveFile
local SaveFile = PS.LocalPlayer:WaitForChild("SaveFile")

-- UI to Target
local GUI = PlayerGui:WaitForChild("ScreenGui")

-- UI Frames
local LeftBox = GUI:WaitForChild("LeftBox")

-- Code
-- Left Box Caps Rendering
LeftBox.Caps.Text = SaveFile:WaitForChild("Caps").Value
SaveFile:WaitForChild("Caps").Changed:Connect(function(newVal)
  LeftBox.Caps.Text = newVal
end)