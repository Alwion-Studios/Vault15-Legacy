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
local PolicyService = game:GetService("PolicyService")
local _RS = game:GetService("ReplicatedStorage")
local _PS = game:GetService("Players")
local _CAS = game:GetService("ContextActionService")
local _RNS = game:GetService("RunService")

-- Types
local types = require(_RS.Types)

-- Remotes
local remotes = _RS.Remotes

-- Formatting Function
local formatter = require(_RS.Formatting.Number)

-- UI Controller
local ui_controller = require(_RS.Controllers["UI.Controller"])

-- PlayerUI
local PlayerGui = _PS.LocalPlayer:WaitForChild("PlayerGui")

-- SaveFile
local SaveFile = _PS.LocalPlayer:WaitForChild("SaveFile")

-- UI to Target
local GUI = PlayerGui:WaitForChild("ScreenGui")

-- UI Frames
local LeftBox: Frame = GUI:WaitForChild("LeftBox")
local PVPAlertBox: Frame = GUI:WaitForChild("PVPAlert")

-- Tween Function
local tween = require(_RS.Functions.Tween)

local module = {
    menus = {
        Menu = {
            Pos = {
                ["InFocus"]=UDim2.new(0.5,0,0.5,0),
                ["Away"]=UDim2.new(0.5,0,2,0)
            },
            UI = GUI:WaitForChild("Menu"),
            Open = false,
            KeyBind = Enum.KeyCode.G,
            CloseBtn = GUI:WaitForChild("Menu"):WaitForChild("Title").Close,
            OpenBtn = GUI:WaitForChild("OpenMenu")
        },
    
        Donations = {
            Pos = {
                ["InFocus"]=UDim2.new(0.5,0,0.5,0),
                ["Away"]=UDim2.new(0.5,0,2,0)
            },
            UI = GUI:WaitForChild("Donations"),
            Open = false,
            KeyBind = Enum.KeyCode.H,
            CloseBtn = GUI:WaitForChild("Donations"):WaitForChild("Title").Close,
            OpenBtn = GUI:WaitForChild("OpenDonations")
        },
    
        Codes = {
            Pos = {
                ["InFocus"]=UDim2.new(0.5,0,0.5,0),
                ["Away"]=UDim2.new(0.5,0,2,0)
            },
            UI = GUI:WaitForChild("Codes"),
            Open = false,
            KeyBind = Enum.KeyCode.B,
            CloseBtn = GUI:WaitForChild("Codes"):WaitForChild("Title").Close,
            OpenBtn = GUI:WaitForChild("OpenCodes")
        },
    
        Shop = {
            Pos = {
                ["InFocus"]=UDim2.new(0.5,0,0.5,0),
                ["Away"]=UDim2.new(0.5,0,2,0)
            },
            UI = GUI:WaitForChild("Shop"),
            Open = false,
            CloseBtn = GUI:WaitForChild("Shop"):WaitForChild("Title").Close,
            ClearScrollingFrame = GUI:WaitForChild("Shop").Items.ScrollingFrame
        }
    };

    openMenu = nil,
    debounce = nil,
}

function module:ToggleAnimations()
    if ui_controller.animationsEnabled == true then
        ui_controller.animationsEnabled = false
    else
        ui_controller.animationsEnabled = true
    end

    return ui_controller.animationsEnabled
end

function module:CloseUI(frame: types.frame)
    if self.debounce and self.debounce == true then return false end

    self.debounce = true

    if frame.ClearScrollingFrame and #frame.ClearScrollingFrame:GetChildren() > 0 then 
        for _, button in pairs(frame.ClearScrollingFrame:GetChildren()) do
            if not button:IsA("UIListLayout") then button:Destroy() end
        end
    end

    if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
        tween(frame.UI, 0.35, "Exponential", "In", 0, false, {["Position"]=frame.Pos["Away"]})
    else
        frame.UI.Position = frame.Pos["Away"]
    end

    self.openMenu = nil
    self.debounce = nil
end

function module:OpenUI(frame: types.frame)
    if self.debounce and self.debounce == true  then return false end
    self.debounce = true

    if self.openMenu then 
        self.debounce = false
        if self.openMenu == frame then return self:CloseUI(self.openMenu) end
        self:CloseUI(self.openMenu)
        
        if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
            task.wait(0.35)
        end
    end
    self.openMenu = frame

    if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
        tween(frame.UI, 0.35, "Exponential", "Out", 0, false, {["Position"]=frame.Pos["InFocus"]})
    else
        frame.UI.Position = frame.Pos["InFocus"]
    end

    self.debounce = nil
end

local function handleKey(menu: string, inputState:Enum.UserInputState, inputObject: InputObject)
    if inputState ~= Enum.UserInputState.Begin or not module.menus[menu] then return false end
    module:OpenUI(module.menus[menu])
end

function module:Initialise()
    for name, menu: types.frame in pairs(self.menus) do
        if menu.OpenBtn then 
            menu.OpenBtn.Activated:Connect(function()
                self:OpenUI(menu)
            end)
        end

        if menu.CloseBtn then 
            menu.CloseBtn.Activated:Connect(function()
                self:CloseUI(menu)
            end)
        end

        if menu.KeyBind then
            _CAS:BindAction(name, handleKey, false, menu.KeyBind)
        end

        self:CloseUI(menu)
    end

    -- Stamina Box
    task.spawn(function()
        _RNS.RenderStepped:Connect(function()
            local stamina = game.Players.LocalPlayer:GetAttribute("Stamina")

            if stamina >= 100 then
                if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then 
                    tween(LeftBox.Stamina, 0.25, "Linear", "Out", 0, false, {["BackgroundTransparency"]=1})
                else 
                    LeftBox.Stamina.BackgroundTransparency = 1
                end
            else
                if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then 
                    tween(LeftBox.Stamina, 0.25, "Linear", "In", 0, false, {["BackgroundTransparency"]=0})
                else 
                    LeftBox.Stamina.BackgroundTransparency = 0

                end
            end

            if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
                tween(LeftBox.Stamina, 0.1, "Sine", "Out", 0, false, {["Size"]=UDim2.new((stamina/100), 0, 0, 2.5)})
            else
                LeftBox.Stamina.Size = UDim2.new((stamina/100), 0, 0, 2.5)
            end
        end)
    end)

    --PVP Box Code
    local opposites = {
        [true]=false,
        [false]=true
    }

    PVPAlertBox.Visible = opposites[_PS.LocalPlayer:GetAttribute("PVP")]
    _PS.LocalPlayer:GetAttributeChangedSignal("PVP"):Connect(function()
        PVPAlertBox.Visible = opposites[_PS.LocalPlayer:GetAttribute("PVP")]
    end)

    PVPAlertBox.MouseMoved:Connect(function()
        if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
            tween(PVPAlertBox, 0.5, "Exponential", "Out", 0, false, {["Size"]=UDim2.new(0,180,0,120)})
        else
            PVPAlertBox.Size = UDim2.new(0,180,0,120)
        end
        PVPAlertBox.Items.Description.Visible = true
    end)

    PVPAlertBox.MouseLeave:Connect(function()
        if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
            tween(PVPAlertBox, 0.5, "Exponential", "Out", 0, false, {["Size"]=UDim2.new(0,180,0,58)})
        else
            PVPAlertBox.Size = UDim2.new(0,180,0,58)
        end
        PVPAlertBox.Items.Description.Visible = false
    end)

    -- Box Code
    LeftBox.MouseMoved:Connect(function()
        if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
            tween(LeftBox, 0.5, "Exponential", "Out", 0, false, {["Size"]=UDim2.new(0,180,0,120)})
        else
            LeftBox.Size = UDim2.new(0,180,0,120)
        end

        LeftBox.Items.Bullets.Visible = true
        LeftBox.Items.FusionCells.Visible = true
        LeftBox.Items.PlasmaCells.Visible = true
    end)
  
    LeftBox.MouseLeave:Connect(function()
        if ui_controller.animationsEnabled and ui_controller.animationsEnabled == true then
            tween(LeftBox, 0.25, "Exponential", "In", 0, false, {["Size"]=UDim2.new(0,180,0,58)})
        else
            LeftBox.Size = UDim2.new(0,180,0,58)
        end

        LeftBox.Items.Bullets.Visible = false
        LeftBox.Items.FusionCells.Visible = false
        LeftBox.Items.PlasmaCells.Visible = false
    end)
      
    -- Left Box Caps Rendering
    LeftBox.Items.Caps.Caps.Text = formatter(SaveFile:WaitForChild("Caps").Value)
    SaveFile:WaitForChild("Caps").Changed:Connect(function(newVal)
        LeftBox.Items.Caps.Caps.Text = formatter(newVal)
    end)
    
    LeftBox.Items.Bullets.Bullets.Text = formatter(SaveFile:WaitForChild("Bullet").Value)
    SaveFile:WaitForChild("Bullet").Changed:Connect(function(newVal)
        LeftBox.Items.Bullets.Bullets.Text = formatter(newVal)
    end)
    
    LeftBox.Items.FusionCells.FusionCells.Text = formatter(SaveFile:WaitForChild("FusionCell").Value)
    SaveFile:WaitForChild("FusionCell").Changed:Connect(function(newVal)
        LeftBox.Items.FusionCells.FusionCells.Text = formatter(newVal)
    end)
    
    LeftBox.Items.PlasmaCells.PlasmaCells.Text = formatter(SaveFile:WaitForChild("PlasmaCell").Value)
    SaveFile:WaitForChild("PlasmaCell").Changed:Connect(function(newVal)
        LeftBox.Items.PlasmaCells.PlasmaCells.Text = formatter(newVal)
    end)
end

return module