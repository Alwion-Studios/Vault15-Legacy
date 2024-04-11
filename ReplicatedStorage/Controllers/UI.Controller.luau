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

-- Core Call
local coreCall do
	local MAX_RETRIES = 8

	local StarterGui = game:GetService('StarterGui')
	local RunService = game:GetService('RunService')

	function coreCall(method, ...)
		local result = {}
		for retries = 1, MAX_RETRIES do
			result = {pcall(StarterGui[method], StarterGui, ...)}
			if result[1] then
				break
			end
			RunService.Stepped:Wait()
		end
		return unpack(result)
	end
end

local module = {
    player = _PS.LocalPlayer;
    playerGui = _PS.LocalPlayer.PlayerGui;
    playerScripts = _PS.LocalPlayer.PlayerScripts;
    playerModule = require(_PS.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"));

    -- UIs
    shopGui = {
        Instance = _PS.LocalPlayer.PlayerGui:WaitForChild("ShopUI");
        DisableMovement = true;
        DisableRobloxUIs = true;
        DisableResets = true;
    };

    mainGui = {
        Instance = _PS.LocalPlayer.PlayerGui:WaitForChild("ScreenGui");
    };

    animationsEnabled = true
}

function module:ToggleAnimations()
    if self.animationsEnabled == true then
        self.animationsEnabled = false
    else
        self.animationsEnabled = true
    end

    return self.animationsEnabled
end

function module:SwitchGui(guiName: string)
    if not self[guiName] then return false end

    if self.openUI then
        self.openUI.Instance.Enabled = false
        self.openUI = nil
    end

    self.openUI = self[guiName]
    self.openUI.Instance.Enabled = true

    if self.openUI.DisableResets then 
        assert(coreCall('SetCore', 'ResetButtonCallback', false))
    else
        assert(coreCall('SetCore', 'ResetButtonCallback', true))
    end

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