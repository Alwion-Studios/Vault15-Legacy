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

-- Object
local shopObject = require(script.Parent.Parent.Objects["Shop.Object"])

-- Gui Module
local guiModule = require(script.Parent["PlayerGui.Controller"])

-- Camera Module
local cameraModule = require(script.Parent["Camera.Controller"])

-- Mouse Module
local mouseModule = require(script.Parent["Mouse.Controller"])

-- Remotes
local remotes = _RS.Remotes
local shopGuiRemote: BindableEvent = remotes.ShopGUI

-- Item Details
local itemData = require(_RS.ItemData)

-- Tween Function
local function Tween(Object, Time, Style, Direction, Repeat, Customization)
	game:GetService("TweenService"):Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], 0, Repeat, 0), Customization):Play()
end

local module = {
    player = _PS.LocalPlayer;
    playerGui = _PS.LocalPlayer.PlayerGui;

    -- UIs

    -- Table
    storeConfig = nil;
    itemDetails = nil;
    itemName = nil;
    categoryTbl = nil;
    currentCategoryId = nil;
}

local function findModelInCategory(category, modelToFind)
    for name, value in pairs(category) do
        if name == "AnimationDirection" or name == "CategoryName" or name == "ModelInstance" then continue end
        if value["GunInstance"] == modelToFind then return name, value end
    end
    return false
end

function module:SwitchCategory(categoryName: string, categoryTbl: table)
    self.UI.Top.Category.Text = categoryName

    if self.itemDetails then
        local instance: Model = self.itemDetails["GunInstance"]

        Tween(instance.PrimaryPart, 0.5, "Quad", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
        self.UI.ItemDetails.Visible = false
    end

    cameraModule:RenderCameraOnPart(categoryTbl["ModelInstance"].PrimaryPart)
    self.categoryTbl = categoryTbl
end

function module:SwitchItem(name: string, itemTbl: table)
    if self.itemDetails == itemTbl then return false end

    if self.itemDetails then
        local instance: Model = self.itemDetails["GunInstance"]

        Tween(instance.PrimaryPart, 0.5, "Quad", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
    end

    self.itemName = name
    self.itemDetails = itemTbl
    self:RefreshItemGui()

    if self.itemDetails["GunInstance"] then 
        local instance: Model = self.itemDetails["GunInstance"]

        local calculation

        if self.categoryTbl["AnimationDirection"] and self.categoryTbl["AnimationDirection"] == "Up" then 
            calculation = (
                CFrame.new(instance.PrimaryPart.Position.X, instance.PrimaryPart.Position.Y+1, instance.PrimaryPart.Position.Z)
                * CFrame.Angles(math.rad(instance.PrimaryPart.Orientation.X), math.rad(instance.PrimaryPart.Orientation.Y), math.rad(instance.PrimaryPart.Orientation.Z))
            )
        else
            calculation = (
                CFrame.new(instance.PrimaryPart.Position.X, instance.PrimaryPart.Position.Y, instance.PrimaryPart.Position.Z-1)
                * CFrame.Angles(math.rad(instance.PrimaryPart.Orientation.X), math.rad(instance.PrimaryPart.Orientation.Y), math.rad(instance.PrimaryPart.Orientation.Z))
            )
        end

        Tween(instance.PrimaryPart, 0.5, "Quad", "Out", false, {["CFrame"] = calculation})
    end
end

function module:RefreshItemGui()
    self.UI.ItemDetails.TopBar.Title.Text = itemData[self.itemName].Name
    self.UI.ItemDetails.Description.Text = itemData[self.itemName].Description or "No Description Provided"

    if itemData[self.itemName].GamepassId then
        local redemptionTime, timeUntilReset = remotes.GetGamepassRedemptionStatus:InvokeServer(itemData[self.itemName].GamepassId)
        self.UI.ItemDetails.TopBar.Price.Text = "Gamepass"

        if not redemptionTime then
            self.UI.ItemDetails.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(50,255,0)
        elseif typeof(redemptionTime) ~= "number" then
            self.UI.ItemDetails.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(255,0,150)
            self.UI.ItemDetails.TopBar.Price.Text = "Redeem"
            self.UI.ItemDetails.Options.Right.Purchase.Text = "Redeem"
        end
    else
        self.UI.ItemDetails.Options.Right.Purchase.Text = "Purchase"
        self.UI.ItemDetails.TopBar.Price.Text = `{itemData[self.itemName].Value} Caps`
        self.UI.ItemDetails.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(50,255,0)
    end

    self.UI.ItemDetails.Visible = true
end

function module:ExitUI()
    if not self.MouseConnectionID then return false end

    mouseModule:Disconnect(self.MouseConnectionID)
    self.MouseConnectionID = nil

    if self.itemDetails then
        local instance: Model = self.itemDetails["GunInstance"]

        Tween(instance.PrimaryPart, 0.5, "Quad", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
        self.UI.ItemDetails.Visible = false
    end

    self.storeConfig = nil;
    self.itemDetails = nil;
    self.itemName = nil;
    self.categoryTbl = nil;

    cameraModule:ResetCamera()
    guiModule:SwitchGui("mainGui")
end

function module:Initialise()
    self.UI = self.playerGui:WaitForChild("ShopUI")

    shopGuiRemote.Event:Connect(function(shopInst: Part, importedConfig: table)
        if not importedConfig then return false end

        self.StoreInstance = shopInst
        self.storeConfig = importedConfig
        guiModule:SwitchGui("shopGui")

        -- Initial Category Selection
        self.currentCategoryId = 3
        self:SwitchCategory(self.storeConfig[self.currentCategoryId]["CategoryName"], self.storeConfig[self.currentCategoryId])

        self.MouseConnectionID = mouseModule:Connect()
    end)

    remotes.MouseClickEvent.Event:Connect(function(id: number, target: Model)
        if not self.MouseConnectionID then return false end
        if self.MouseConnectionID ~= id then return false end

        self:SwitchItem(findModelInCategory(self.categoryTbl, target.Parent))
    end)

    self.UI.ItemDetails.Options.Right.Purchase.Activated:Connect(function()
        if not self.itemDetails or not self.itemName then return false end

        if not itemData[self.itemName].GamepassId then 
            remotes.RequestPurchase:InvokeServer(self.currentCategoryId, self.itemName, self.StoreInstance)
        else
            remotes.RedeemGamepass:InvokeServer(itemData[self.itemName].GamepassId)
        end
    end)

    self.UI.Top.Left.Activated:Connect(function()
        if not self.storeConfig[self.currentCategoryId+1] then print(false) return false end
        self.currentCategoryId += 1

        self:SwitchCategory(self.storeConfig[self.currentCategoryId]["CategoryName"], self.storeConfig[self.currentCategoryId])
    end)

    self.UI.Top.Right.Activated:Connect(function()
        if not self.storeConfig[self.currentCategoryId-1] then return false end
        self.currentCategoryId -= 1

        self:SwitchCategory(self.storeConfig[self.currentCategoryId]["CategoryName"], self.storeConfig[self.currentCategoryId])
    end)

    self.UI.Exit.Activated:Connect(function()
        self:ExitUI()
    end)
end

return module