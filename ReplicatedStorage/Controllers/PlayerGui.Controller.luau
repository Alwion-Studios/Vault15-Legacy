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
local _PS = game:GetService("Players")
local _SGUI = game:GetService('StarterGui')

-- Object
local shopObject = require(script.Parent.Parent.Objects["Shop.Object"])

-- Remotes
local remotes = _RS.Remotes
local shopGuiRemote: BindableEvent = remotes.ShopGUI

local module = {
    player = _PS.LocalPlayer;
    playerGui = _PS.LocalPlayer.PlayerGui;
    playerScripts = _PS.LocalPlayer.PlayerScripts;
    playerModule = require(_PS.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"));

    -- UIs
    shopGui = {
        Instance = _PS.LocalPlayer.PlayerGui:WaitForChild("ShopUI");
        DisableMovement = true;
        DisableRobloxUIs = true
    };

    mainGui = {
        Instance = _PS.LocalPlayer.PlayerGui:WaitForChild("ScreenGui");
    };
}

function module:SwitchGui(guiName: string)
    if not self[guiName] then return false end

    if self.openUI then
        self.openUI.Instance.Enabled = false
        self.openUI = nil
    end

    self.openUI = self[guiName]
    self.openUI.Instance.Enabled = true

    if self.openUI.DisableRobloxUIs then
        -- Disable UIs
        _SGUI:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    else
        -- Enable UIs
        _SGUI:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    end

    if self.openUI.DisableMovement then
        -- Disable movement
        self.playerModule:GetControls():Disable()
    else
        -- Enable Movement
        self.playerModule:GetControls():Enable()
    end
end

function module:Initialise()
    self:SwitchGui("mainGui")
end

return module