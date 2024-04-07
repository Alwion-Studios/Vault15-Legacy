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
local _PS = game:GetService("Players")
local _MPS = game:GetService("MarketplaceService")
local _CAS = game:GetService("ContextActionService")
local _SGUI = game:GetService('StarterGui')

-- Remotes
local remotes = _RS.Remotes
local shopGuiRemote: BindableEvent = remotes.ShopGUI

--Camera Settings
local camera = workspace.CurrentCamera
local cameraPoint = camera.CFrame.Position

-- Get the Player's UI
local player = _PS.LocalPlayer
local playerGui = player.PlayerGui

-- Get the Player's Mouse
local mouse = player:GetMouse()

-- Variables
local config = nil
local currentCategory = nil
local currentItem = nil

-- Item Details
local itemData = require(_RS.ItemData)

local function Tween(Object, Time, Style, Direction, Repeat, Customization)
	game:GetService("TweenService"):Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], 0, Repeat, 0), Customization):Play()
end

-- Camera Functions
local function renderCameraOnPart(part: Part)
	if part:IsA("Part") then
        local position: Vector3 = part.Position + part.CFrame.LookVector * 5

		camera.CameraType = Enum.CameraType.Scriptable
		Tween(camera, 1, "Quad", "In", false, {["CFrame"] = CFrame.lookAt(position, part.Position)})
	end
end

local function handleGamepassItem(itemInfo)
    local itemDetailsUI: Frame = playerGui:WaitForChild("ShopUI").ItemDetails

    local redemptionTime, timeUntilReset = remotes.GetGamepassRedemptionStatus:InvokeServer(itemInfo.GamepassId)

    if not redemptionTime then
        itemDetailsUI.Options.Right.Purchase.Text = "Purchase"
        itemDetailsUI.TopBar.Price.Text = "Purchaseable"
        itemDetailsUI.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(50,255,0)

        itemDetailsUI.Options.Right.Purchase.Activated:Connect(function()
            _MPS:PromptGamePassPurchase(player, itemInfo.GamepassId)
            handleGamepassItem(itemInfo)
        end)

        return true
    elseif typeof(redemptionTime) ~= "number" then
        itemDetailsUI.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(255,0,150)
        itemDetailsUI.TopBar.Price.Text = "Redeem"
        itemDetailsUI.Options.Right.Purchase.Text = "Redeem"

        itemDetailsUI.Options.Right.Purchase.Activated:Connect(function()
            remotes.RedeemGamepass:InvokeServer(itemInfo.GamepassId)
        end)

        return true
    end

    if typeof(redemptionTime) == "number" then
        task.spawn(function()
            repeat
                itemDetailsUI.TopBar.Price.Text = `Redeemable in {(redemptionTime-os.time())} seconds...`
            until (redemptionTime - os.time()) < timeUntilReset
        end)
        handleGamepassItem(itemInfo)
    end
end

-- Item Selection Function
local function switchItem(itemName: string, itemTable: table)
    -- If an Item is already selected, stop it from hovering
    if currentItem then
        local instance: Model = currentItem["GunInstance"]

        Tween(instance.PrimaryPart, 0.5, "Quad", "In", false, {["CFrame"] = currentItem["DefaultPosition"]})
        task.wait(0.5)
    end

    currentItem = itemTable
    local itemInfo = itemData[itemName]
    
    local itemDetailsUI: Frame = playerGui:WaitForChild("ShopUI").ItemDetails
    itemDetailsUI.TopBar.Title.Text = itemInfo.Name
    itemDetailsUI.Description.Text = itemInfo.Description or "No Description Provided"
    itemDetailsUI.Visible = true

    if itemInfo.GamepassId then
        print(true)
        handleGamepassItem(itemInfo)
    else
        itemDetailsUI.Options.Right.Purchase.Text = "Purchase"
        itemDetailsUI.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(50,255,0)
        itemDetailsUI.TopBar.Price.Text = `{itemInfo.Value} Caps`
    end

    -- Configure Model Animation
    if currentItem["GunInstance"] then 
        local instance = currentItem["GunInstance"]

        local calculation = (
            CFrame.new(instance.PrimaryPart.Position.X, instance.PrimaryPart.Position.Y, instance.PrimaryPart.Position.Z-1)
            * CFrame.Angles(math.rad(instance.PrimaryPart.Orientation.X), math.rad(instance.PrimaryPart.Orientation.Y), math.rad(instance.PrimaryPart.Orientation.Z))
        )

        Tween(instance.PrimaryPart, 0.5, "Quad", "Out", false, {["CFrame"] = calculation})
    end
end

-- Category Selection Function
local function switchCategory(name: string, category: table)
    --shopUI.Category.Text = name
    playerGui:WaitForChild("ShopUI").Category.Text = name
    renderCameraOnPart(category["ModelInstance"].PrimaryPart)
    currentCategory = name
end

local function findModelInCategory(model)
    for name, value in pairs(config[currentCategory]) do
        if value["GunInstance"] == model then return value end
    end
    return false
end

shopGuiRemote.Event:Connect(function(importedConfig)
    if not importedConfig then return false end
    
    config = importedConfig

    playerGui:WaitForChild("ScreenGui").Enabled = false
    playerGui:WaitForChild("ShopUI").Enabled = true

    -- Disable movement and UI
    _SGUI:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    local playerscripts = player.PlayerScripts
    local playermodule = require(playerscripts:WaitForChild("PlayerModule"))
    local controls = playermodule:GetControls()
    controls:Disable()

    -- Initial Category Selection
    for category, value in pairs(config) do 
        if not value["ModelInstance"] then continue end
        switchCategory(category, value)
    end

    mouse.Button1Down:Connect(function() 
        if not mouse.Target then return end

        local modelConfig = findModelInCategory(mouse.Target.Parent) or nil

        if mouse.Target.Parent.ClassName ~= "Model" or not modelConfig or modelConfig == currentItem then return false end

        local model = mouse.Target.Parent
        switchItem(model.Name, modelConfig)
    end)
end)