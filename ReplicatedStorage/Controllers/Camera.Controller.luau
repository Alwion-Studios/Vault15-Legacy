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
local _CS = game:GetService("CollectionService")

-- Object
local shopObject = require(script.Parent.Parent.Objects["Shop.Object"])

-- Gui Module
local guiModule = require(script.Parent["UI.Controller"])

local function Tween(Object, Time, Style, Direction, Repeat, Customization)
	game:GetService("TweenService"):Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], 0, Repeat, 0), Customization):Play()
end

local module = {
    -- Camera
    camera = workspace.CurrentCamera;
}

function module:RenderCameraOnPart(part: Part)
    local position: Vector3 = part.Position + part.CFrame.LookVector * 5
    self.camera.CameraType = Enum.CameraType.Scriptable

    if guiModule.animationsEnabled then
        Tween(self.camera, 1, "Sine", "In", false, {["CFrame"] = CFrame.lookAt(position, part.Position)})
    else
        self.camera.CFrame = CFrame.lookAt(position, part.Position)
    end
end

function module:ResetCamera()
    self.camera.CameraType = Enum.CameraType.Custom
end

return module