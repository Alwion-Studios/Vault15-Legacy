--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]

--Imports
local PS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local _GS = game:GetService("GroupService")

local formattingFunctions = require(RS.Formatting.Number)

--Overhead UI
local overheadUI = RS:WaitForChild("GuiTemplates"):WaitForChild("Overhead")

local OverheadController = {}

function OverheadController:GetGroupIcon(id)
    return _GS:GetGroupInfoAsync(id).EmblemUrl
end

function OverheadController:GetGroupName(id)
    return _GS:GetGroupInfoAsync(id).Name
end

function OverheadController:HandleGroup(plr: Player, overhead: BillboardGui)
    if not plr:GetAttribute("Group") then 
        overhead:WaitForChild("Hold").Group.Visible = false
        overhead:WaitForChild("Hold").Names.Size = UDim2.new(1,0,1,0)
        overhead:WaitForChild("Hold"):WaitForChild("Names").Username.Text = plr.Name
        return false
    end

    overhead:WaitForChild("Hold").Group.Decal.Image = self:GetGroupIcon(plr:GetAttribute("Group"))
    overhead:WaitForChild("Hold").Names.Username.Text = self:GetGroupName(plr:GetAttribute("Group"))
    overhead:WaitForChild("Hold").Names.Size = UDim2.new(0.75,0,1,0)
    overhead:WaitForChild("Hold").Group.Visible = true
end

function OverheadController:AssignToPlayer(plr: Player)
    if not plr then return false end
    local char = plr.Character or plr.CharacterAdded:Wait()
    if not char then return false end

    local clonedOverhead: BillboardGui = overheadUI:Clone()
    char:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    clonedOverhead:WaitForChild("Hold"):WaitForChild("Names").DisplayName.Text = plr.DisplayName
    clonedOverhead:WaitForChild("Hold"):WaitForChild("Names").Username.Text = plr.Name
    clonedOverhead:WaitForChild("Hold").BackgroundColor3 = plr.Team.TeamColor.Color

    plr:GetPropertyChangedSignal("Team"):Connect(function()
        clonedOverhead:WaitForChild("Hold").BackgroundColor3 = plr.Team.TeamColor.Color
    end)

    self:HandleGroup(plr, clonedOverhead)
    plr:GetAttributeChangedSignal("Group"):Connect(function()
        self:HandleGroup(plr, clonedOverhead)
    end)

    clonedOverhead.Parent = char:WaitForChild("Head")
    clonedOverhead.Adornee = char.Head
end

function OverheadController:Initialise()
    --Get all Players and add the Overhead UI
    for _, plr in pairs(PS:GetChildren()) do
        --if plr == PS.LocalPlayer then print(false) continue end
        plr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").Died:Connect(function()
                self:AssignToPlayer(plr)
            end)
            self:AssignToPlayer(plr)
        end)
        
        self:AssignToPlayer(plr)
    end

    --After Player has Joined
    PS.PlayerAdded:Connect(function(newPlr)
        newPlr.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").Died:Connect(function()
                self:AssignToPlayer(newPlr)
            end)
            self:AssignToPlayer(newPlr)
        end)
        --if newPlr == PS.LocalPlayer then return false end 
        self:AssignToPlayer(newPlr)
    end)
end

return OverheadController