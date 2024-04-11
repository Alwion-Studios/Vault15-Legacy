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
local _CAS = game:GetService("ContextActionService")
local _PS = game:GetService("Players")
local _UIS = game:GetService("UserInputService")
local _MS = game:GetService("MarketplaceService")

-- Object
local shopObject = require(script.Parent.Parent.Objects["Shop.Object"])

-- Gui Module
local guiModule = require(script.Parent["UI.Controller"])

-- Camera Module
local cameraModule = require(script.Parent["Camera.Controller"])

-- Mouse Module
local mouseModule = require(script.Parent["Mouse.Controller"])

-- Remotes
local remotes = _RS.Remotes
local shopGuiRemote: BindableEvent = remotes.ShopGUI

-- Item Details
local itemData = require(_RS.ItemData)

-- GUI Templates
local guiTemplates = _RS.GuiTemplates

-- Formatting Function
local formatter = require(_RS.Formatting.Number)

-- Size Calculation Function
local sizeCalculations = require(script.Parent.Parent.Functions.sizeCalculations)

-- Tween Function
local function Tween(Object, Time, Style, Direction, Repeat, Customization)
	game:GetService("TweenService"):Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], 0, Repeat, 0), Customization):Play()
end

local module = {
    player = _PS.LocalPlayer;
    playerGui = _PS.LocalPlayer.PlayerGui;
    SaveFile = _PS.LocalPlayer:WaitForChild("SaveFile");

    -- UIs

    -- Table
    storeConfig = nil;
    itemDetails = nil;
    itemName = nil;
    categoryTbl = nil;
    currentCategoryId = nil;

    -- Actions
    debounce = false,
    timerCheck = false
}

local function findModelInCategory(category, modelToFind)
    for name, value in pairs(category) do
        if name == "AnimationDirection" or name == "CategoryName" or name == "ModelInstance" or name == "X" or name == "Y" or name == "Z" then continue end
        if value["GunInstance"] == modelToFind then return name, value end
    end
    return false
end

function module:SwitchCategory(categoryName: string, categoryTbl: table)
    if self.debounce == true then return false end

    self.UI.Top.Category.Text = categoryName

    if self.itemDetails then
        local instance: Model = self.itemDetails["GunInstance"]

        if guiModule.animationsEnabled then
            Tween(instance.PrimaryPart, 0.25, "Sine", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
        else
            instance.PrimaryPart.CFrame = self.itemDetails["DefaultPosition"]
        end

        self.UI.ItemDetails.Visible = false
    end

    cameraModule:RenderCameraOnPart(categoryTbl["ModelInstance"].PrimaryPart)
    self.categoryTbl = categoryTbl

    task.spawn(function()
        self.debounce = true
        for name, items in self.categoryTbl do 
            if name == "CategoryName" or name == "ModelInstance" or name == "AnimationCycle" or name == "X" or name == "Y" or name == "Z" then continue end
            
            if guiModule.animationsEnabled then
                task.wait(1)
            end
            
            self.debounce = false
            return self:SwitchItem(name, items)
        end
    end)
end

function module:SwitchItem(name: string, itemTbl: table)
    if self.debounce == true then return false end

    if self.itemDetails == itemTbl then
        local instance: Model = self.itemDetails["GunInstance"]
        
        if guiModule.animationsEnabled then
            Tween(instance.PrimaryPart, 0.25, "Sine", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
        else
            instance.PrimaryPart.CFrame = self.itemDetails["DefaultPosition"]
        end

        self.itemDetails = nil
        self:RefreshItemGui()
        return false
    end

    if self.itemDetails then
        local instance: Model = self.itemDetails["GunInstance"]
        if guiModule.animationsEnabled then
            Tween(instance.PrimaryPart, 0.5, "Sine", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
        else
            instance.PrimaryPart.CFrame = self.itemDetails["DefaultPosition"]
        end
    end

    self.itemName = name
    self.itemDetails = itemTbl
    self:RefreshItemGui()

    if self.itemDetails["GunInstance"] then 
        local instance: Model = self.itemDetails["GunInstance"]
        instance.PrimaryPart.CFrame = self.itemDetails["DefaultPosition"]

        local calculation

        if self.categoryTbl["AnimationCycle"] and self.categoryTbl["AnimationCycle"] == "Opposite" then 
            calculation = (
                CFrame.new(instance.PrimaryPart.Position.X-self.categoryTbl["X"], instance.PrimaryPart.Position.Y-self.categoryTbl["Y"], instance.PrimaryPart.Position.Z-1-self.categoryTbl["Z"])
                * instance.PrimaryPart.CFrame.Rotation
            )
        else
            calculation = (
                CFrame.new(instance.PrimaryPart.Position.X+self.categoryTbl["X"], instance.PrimaryPart.Position.Y+self.categoryTbl["Y"], instance.PrimaryPart.Position.Z+self.categoryTbl["Z"])
                * instance.PrimaryPart.CFrame.Rotation
            )
        end

        if guiModule.animationsEnabled then
            Tween(instance.PrimaryPart, 0.5, "Sine", "Out", false, {["CFrame"] = calculation})
        else
            instance.PrimaryPart.CFrame = calculation
        end
    end

    self.debounce = false
end

function module:RefreshItemGui()
    self.timerCheck = true

    if not self.itemDetails or not itemData[self.itemName] then 
        self.UI.ItemDetails.Visible = false
        return false
    end

    if self.itemDetails["Quantity"] > 1 then
        self.UI.ItemDetails.TopBar.Title.Text = `{formatter(self.itemDetails["Quantity"])} {itemData[self.itemName].Name}`
    else
        self.UI.ItemDetails.TopBar.Title.Text = `{itemData[self.itemName].Name}`
    end

    self.UI.ItemDetails.Description.Text = itemData[self.itemName].Description or "No Description Provided"

    if itemData[self.itemName].GamepassId then
        local status = remotes.GetGamepassOwnershipStatus:InvokeServer(itemData[self.itemName].GamepassId)
        self.UI.ItemDetails.TopBar.Price.Text = "Gamepass"

        if not status then 
            self.UI.ItemDetails.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(50,255,0)
        else
            self.UI.ItemDetails.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(255,0,150)
            self.UI.ItemDetails.TopBar.Price.Text = "Redeemable"
            self.UI.ItemDetails.Options.Right.Purchase.Text = "Redeem"

            -- Redemption System
            local redemptionTime, timeUntilReset = remotes.GetGamepassRedemptionStatus:InvokeServer(itemData[self.itemName].GamepassId)
            if typeof(redemptionTime) == "number" and typeof(timeUntilReset) == "number" then 
                self.timerCheck = false
                task.spawn(function()
                    self.UI.ItemDetails.TopBar.Price.Text = `Redeemable in... 60 seconds`
                    while wait(1) do
                        if self.timerCheck then break end
                        if (os.time()-redemptionTime) > timeUntilReset then
                            self.UI.ItemDetails.TopBar.Price.Text = "Redeemable"
                            break
                        end
                        self.UI.ItemDetails.TopBar.Price.Text = `Redeemable in... {(timeUntilReset-(os.time()-redemptionTime))} seconds`
                    end
                end)
            end
        end
    else
        self.UI.ItemDetails.Options.Right.Purchase.Text = "Purchase"
        self.UI.ItemDetails.TopBar.Price.Text = `{formatter(itemData[self.itemName].Value)} Caps`
        self.UI.ItemDetails.Options.Right.Purchase.BackgroundColor3 = Color3.fromRGB(50,255,0)
    end

    self.UI.ItemDetails.Visible = true
end

function module:ExitUI()
    if not self.MouseConnectionID then return false end
    cameraModule:ResetCamera()

    _CAS:UnbindAction("MOVE_RIGHT")
    _CAS:UnbindAction("MOVE_LEFT")

    mouseModule:Disconnect(self.MouseConnectionID)
    self.MouseConnectionID = nil

    if self.itemDetails then
        local instance: Model = self.itemDetails["GunInstance"]

        if guiModule.animationsEnabled then
            Tween(instance.PrimaryPart, 0.25, "Sine", "In", false, {["CFrame"] = self.itemDetails["DefaultPosition"]})
        else
            instance.PrimaryPart.CFrame = self.itemDetails["DefaultPosition"]
        end

        self.UI.ItemDetails.Visible = false
    end

    -- Destroy Options
    for id, dropdownOption: TextButton in pairs(self.UI.Top.Category.Dropdown:GetChildren()) do
        if not dropdownOption:IsA("TextButton") then continue end
        dropdownOption:Destroy()
    end

    self.storeConfig = nil;
    self.itemDetails = nil;
    self.itemName = nil;
    self.categoryTbl = nil;

    guiModule:SwitchGui("mainGui")
    self.debounce = false
end

local function handleAction(direction, inputState, _inputObject)
    if module.debounce and module.debounce == true then return false end
    if inputState and inputState ~= Enum.UserInputState.Begin then return false end

    if direction == "MOVE_RIGHT" then 
        if not module.storeConfig[module.currentCategoryId-1] then 
            module.currentCategoryId = #module.storeConfig
        else
            module.currentCategoryId -= 1
        end
    end

    if direction == "MOVE_LEFT" then 
        if not module.storeConfig[module.currentCategoryId+1] then
            module.currentCategoryId = 1
        else
            module.currentCategoryId += 1
        end
    end

    module:SwitchCategory(module.storeConfig[module.currentCategoryId]["CategoryName"], module.storeConfig[module.currentCategoryId])
end

function module:Initialise()
    self.UI = self.playerGui:WaitForChild("ShopUI")

    shopGuiRemote.Event:Connect(function(shopInst: Part, importedConfig: table)
        if not importedConfig then return false end

        self.UI.StoreName.Text = shopInst.Name or "Store"

        self.StoreInstance = shopInst
        self.storeConfig = importedConfig
        guiModule:SwitchGui("shopGui")

        -- Initial Category Selection
        self.currentCategoryId = 3
        self:SwitchCategory(self.storeConfig[self.currentCategoryId]["CategoryName"], self.storeConfig[self.currentCategoryId])

        -- Create Dropdown
        self.UI.Top.Category.Dropdown.Size = sizeCalculations.calculateYSize(120, #self.storeConfig)
        self.UI.Top.Category.Dropdown.Visible = false

        self.UI.Top.Category.Activated:Connect(function()
            if self.UI.Top.Category.Dropdown.Visible then
                self.UI.Top.Category.Dropdown.Visible = false
            else
                self.UI.Top.Category.Dropdown.Visible = true
            end
        end)

        -- Create Options
        for id, dropdownOption in pairs(self.storeConfig) do 
            local newTextBtn: TextButton = guiTemplates.CategoryBtn:Clone()
            newTextBtn.Name = id
            newTextBtn.Text = dropdownOption["CategoryName"]
            newTextBtn.Parent = self.UI.Top.Category.Dropdown
            newTextBtn.Activated:Connect(function()
                self:SwitchCategory(dropdownOption["CategoryName"], dropdownOption)
            end)
            newTextBtn:SetAttribute("isDropdown", true)
        end

        self.MouseConnectionID = mouseModule:Connect()

        _CAS:BindAction("MOVE_RIGHT", handleAction, false, Enum.KeyCode.D, Enum.KeyCode.Right, Enum.KeyCode.DPadRight)
        _CAS:BindAction("MOVE_LEFT", handleAction, false, Enum.KeyCode.A, Enum.KeyCode.Left, Enum.KeyCode.DPadLeft)
    end)

    remotes.MouseClickEvent.Event:Connect(function(id: number, target: Model)
        if not self.MouseConnectionID then return false end
        if self.MouseConnectionID ~= id then return false end

        if target:GetAttribute("isDropdown") then
            self.UI.Top.Category.Dropdown.Visible = true
        else
            self.UI.Top.Category.Dropdown.Visible = false
        end

        self:SwitchItem(findModelInCategory(self.categoryTbl, target.Parent))
    end)

    self.UI.ItemDetails.Options.Right.Purchase.Activated:Connect(function()
        if not self.itemDetails or not self.itemName then return false end
        local status

        if not itemData[self.itemName].GamepassId then 
            status = remotes.RequestPurchase:InvokeServer(self.currentCategoryId, self.itemName, self.StoreInstance)
        else
            status =  remotes.GetGamepassOwnershipStatus:InvokeServer(itemData[self.itemName].GamepassId)
            if not status then _MS:PromptGamePassPurchase(self.player, itemData[self.itemName].GamepassId) return false end
            status = remotes.RedeemGamepass:InvokeServer(itemData[self.itemName].GamepassId)
        end

        if status then 
            self.UI.Sounds.Purchase:Play()
        end

        self:RefreshItemGui()
    end)

    _MS.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
        if wasPurchased == false then return false end
        task.wait(1)
        self:RefreshItemGui()
    end)

    self.UI.Top.Left.Activated:Connect(function()
        handleAction("MOVE_LEFT")
    end)

    self.UI.Top.Right.Activated:Connect(function()
        handleAction("MOVE_RIGHT")
    end)

    self.UI.Exit.Activated:Connect(function()
        if self.debounce == true then return false end
        self:ExitUI()
    end)

    self.UI.Box.Caps.Caps.Text = formatter(self.SaveFile:WaitForChild("Caps").Value)
    self.SaveFile:WaitForChild("Caps").Changed:Connect(function(newVal)
        self.UI.Box.Caps.Caps.Text = formatter(newVal)
    end)

    self.UI.Box.Bullets.Bullets.Text = formatter(self.SaveFile:WaitForChild("Bullet").Value)
    self.SaveFile:WaitForChild("Bullet").Changed:Connect(function(newVal)
        self.UI.Box.Bullets.Bullets.Text = formatter(newVal)

    --[[if currCapAnim then
        coroutine.close(currCapAnim)
    end

    currCapAnim = coroutine.create(function()
        countAnim(tonumber(self.UI.Box.Caps.Text), newVal, self.UI.Box.Caps)
    end)
    coroutine.resume(currCapAnim)]]
    end)

    self.UI.Box.FusionCells.FusionCells.Text = formatter(self.SaveFile:WaitForChild("FusionCell").Value)
    self.SaveFile:WaitForChild("FusionCell").Changed:Connect(function(newVal)
        self.UI.Box.FusionCells.FusionCells.Text = formatter(newVal)

    --[[if currCapAnim then
        coroutine.close(currCapAnim)
    end

    currCapAnim = coroutine.create(function()
        countAnim(tonumber(self.UI.Box.Caps.Text), newVal, self.UI.Box.Caps)
    end)
    coroutine.resume(currCapAnim)]]
    end)

    self.UI.Box.PlasmaCells.PlasmaCells.Text = formatter(self.SaveFile:WaitForChild("PlasmaCell").Value)
    self.SaveFile:WaitForChild("PlasmaCell").Changed:Connect(function(newVal)
        self.UI.Box.PlasmaCells.PlasmaCells.Text = formatter(newVal)

    --[[if currCapAnim then
        coroutine.close(currCapAnim)
    end

    currCapAnim = coroutine.create(function()
        countAnim(tonumber(self.UI.Box.Caps.Text), newVal, self.UI.Box.Caps)
    end)
    coroutine.resume(currCapAnim)]]
    end)
end

return module