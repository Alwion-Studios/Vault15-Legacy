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
local CAS = game:GetService("ContextActionService")

-- Remotes
local remotes = RS.Remotes
local shopGuiRemote: BindableEvent = remotes.ShopGUI

-- Item Template
local itmTemplate = require(RS.ItemData)

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

-- OpenFrame
local openFrame = nil

-- Frame Type
type frame = {
  Pos: {},
  UI: Frame,
  Open: boolean
}

-- Frames
local frames = {
  Menu = {
    Pos = {
      ["InFocus"]=UDim2.new(0.5,0,0.5,0),
      ["Away"]=UDim2.new(0.5,0,2,0)
    },
    UI = GUI:WaitForChild("Menu"),
    Open = false
  },

  Donations = {
    Pos = {
      ["InFocus"]=UDim2.new(0.5,0,0.5,0),
      ["Away"]=UDim2.new(0.5,0,2,0)
    },
    UI = GUI:WaitForChild("Donations"),
    Open = false
  },

  Codes = {
    Pos = {
      ["InFocus"]=UDim2.new(0.5,0,0.5,0),
      ["Away"]=UDim2.new(0.5,0,2,0)
    },
    UI = GUI:WaitForChild("Codes"),
    Open = false
  },

  Shop = {
    Pos = {
      ["InFocus"]=UDim2.new(0.5,0,0.5,0),
      ["Away"]=UDim2.new(0.5,0,2,0)
    },
    UI = GUI:WaitForChild("Shop"),
    Open = false
  }
}

-- Keys
local keys = {
  {Enum.KeyCode.G, frames.Menu, "Menu"},
  {Enum.KeyCode.T, frames.Donations, "Donations"},
  {Enum.KeyCode.V, frames.Codes, "Codes"},
}

-- Close Buttons
local closeBtns = {
  {frames.Menu.UI:WaitForChild("Title").Close, frames.Menu},
  {frames.Donations.UI:WaitForChild("Title").Close, frames.Donations},
  {frames.Codes.UI:WaitForChild("Title").Close, frames.Codes},
  {frames.Shop.UI:WaitForChild("Title").Close, frames.Shop}
}

-- Open Buttons
local openBtns = {
  {GUI:WaitForChild("OpenMenu"), frames.Menu},
  {GUI:WaitForChild("OpenDonations"), frames.Donations},
  {GUI:WaitForChild("OpenCodes"), frames.Codes},
}

-- Current Animation
local currCapAnim

-- Count animation
local function countAnim(currentValue, target, toSet)
  if target > currentValue then
      for i = currentValue, target,1 do
          toSet.Text = formatter(i)
          task.wait()
      end
  else
      for i = currentValue, target,-1 do
          toSet.Text = formatter(i)
          task.wait()
      end
  end
end

-- Animation Functions
local function closeUI(frame: frame)
  if frame.UI.Name == "Shop" then 
    for _, button in pairs(frame.UI.Items.ScrollingFrame:GetChildren()) do
      if not button:IsA("UIListLayout") then button:Destroy() end
    end
  end

  frame.UI:TweenPosition(frame.Pos["Away"], Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
  openFrame = nil
end

local function openUI(frame: frame)
  if openFrame then
    if openFrame == frame then return closeUI(openFrame) end
    closeUI(openFrame)
  end

  openFrame = frame
  frame.UI:TweenPosition(frame.Pos["InFocus"], Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.35, true)
end

local function handleKey(frameName: string, inputState:Enum.UserInputState, inputObject: InputObject)
  if inputState ~= Enum.UserInputState.Begin then return false end

  openUI(frames[frameName])
end

-- Close all Frames
for _, frame in frames do
  closeUI(frame)
end

-- Configure ContextActionService
for _, key in keys do
  CAS:BindAction(key[3], handleKey, true, key[1])
end

-- Configure UI close buttons
for _, btn: table in closeBtns do
  btn[1].Activated:Connect(function()
    closeUI(btn[2])
  end)
end

-- Configure UI Open Buttons
for _, btn: table in openBtns do 
  btn[1].Activated:Connect(function()
    openUI(btn[2])
  end)
end

-- Code
-- Left Box Caps Rendering
LeftBox.Caps.Text = formatter(SaveFile:WaitForChild("Caps").Value)
SaveFile:WaitForChild("Caps").Changed:Connect(function(newVal)
  LeftBox.Caps.Text = formatter(newVal)

  --[[if currCapAnim then
    coroutine.close(currCapAnim)
  end

  currCapAnim = coroutine.create(function()
    countAnim(tonumber(LeftBox.Caps.Text), newVal, LeftBox.Caps)
  end)
  coroutine.resume(currCapAnim)]]
end)